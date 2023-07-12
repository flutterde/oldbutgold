/**
 * Triggered by a change to a Firestore document.
 *
 * @param {!Object} event Event payload.
 * @param {!Object} context Metadata for the event.
 */
const admin = require('firebase-admin');
admin.initializeApp();
const video = require('@google-cloud/video-intelligence').v1;



const bucket = 'gs://old-butgold.appspot.com/';



exports.videoProcess = async (event, context) => {
    const documentData = event.value.fields;
    const postId = documentData.id.stringValue;
    const userLang = documentData.user_lang_code.stringValue;
    const videoUrl = documentData.videoUrl.stringValue;
    const userDeviceToken = documentData.fcmToken.stringValue;
    const videoMetadata = documentData.meta_data.mapValue.fields;
    const videoFullPath = videoMetadata.fullPath.stringValue;
    console.log(`Processing video for ${videoFullPath}...`);
    const gcsUri = bucket + videoFullPath;


    const client = new video.VideoIntelligenceServiceClient();


    const request = {
        inputUri: gcsUri,
        features: ['EXPLICIT_CONTENT_DETECTION'],
    };

    // Human-readable likelihoods
    const likelihoods = [
        'UNKNOWN',
        'VERY_UNLIKELY',
        'UNLIKELY',
        'POSSIBLE',
        'LIKELY',
        'VERY_LIKELY',
    ];




    console.log(`Processing video for ${gcsUri}...`);



    try {
        const [operation] = await client.annotateVideo(request);
        console.log('Waiting for operation to complete...');
        const [operationResult] = await operation.promise();
        const explicitContentResults =
            operationResult.annotationResults[0].explicitAnnotation;

        console.log('Explicit annotation results:');



        const veryLikelyCount = explicitContentResults.frames.reduce((count, result) => {
            if (result.pornographyLikelihood === 5 /* VERY_LIKELY */) {
                return count + 1;
            } else {
                return count;
            }
        }, 0);

        const likelyCount = explicitContentResults.frames.reduce((count, result) => {
            if (result.pornographyLikelihood === 4 /* LIKELY */) {
                return count + 1;
            } else {
                return count;
            }
        }, 0);




        console.log(`VERY_LIKELY count: ${veryLikelyCount}`);
        console.log(`LIKELY count: ${likelyCount}`);

        const isRejected = veryLikelyCount >= 2 || likelyCount >= 5;

        // Here you can perform further actions based on the explicit content results,
        await updatePost(isRejected);

        if (isRejected) {
            await sendPushNotification('Post Rejected', 'Your post has been rejected due to explicit content.');
            return;
        } else {
            await sendPushNotification('Post Approved', 'Your post has been approved.');
        }
        // such as deleting or flagging the post if explicit content is detected.

    } catch (error) {
        console.error('Error processing video:', error);
    }





    async function updatePost(isRejected) {
        try {
            const db = admin.firestore();
            await db.collection('posts').doc(postId).update({
                'is_processed': true,
                'isRejected': isRejected,
            });
        } catch (err) {
            console.error('Error Updating post: ', err);
        }
    }


    // Send a message to devices subscribed to the provided topic.
    async function sendPushNotification(title, body) {
        const message = {
            token: userDeviceToken,
            notification: {
                title: title,
                body: body,
            },
        };

        try {
            const response = await admin.messaging().send(message);
            console.log('Push notification sent successfully:', response);
        } catch (error) {
            console.error('Error sending push notification:', error);
        }
    }




};