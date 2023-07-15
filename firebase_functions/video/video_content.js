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
exports.videoContentDetection = async (event, context) => {
    const documentData = event.value.fields;
    const postId = documentData.id.stringValue;
    const userId = documentData.user_id.stringValue;
    const userLang = documentData.user_lang_code.stringValue;
    const videoUrl = documentData.videoUrl.stringValue;
    const userDeviceToken = documentData.fcmToken.stringValue;
    const videoMetadata = documentData.meta_data.mapValue.fields;
    const videoFullPath = videoMetadata.fullPath.stringValue;
    const videoExtension = videoMetadata.video_extension.stringValue;
    const videoContentType = videoMetadata.contentType.stringValue;
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

        if (isRejected === true) {
            console.log('================= Video Rejected =================');
            await updatePost(postId, isRejected);
            await sendPushNotification(userDeviceToken, 'Post Rejected', 'Your post has been rejected due to explicit content.');
            return;

        } else {
            console.log('================= Video Approved =================');
            await updatePost(postId, isRejected);
            await nextProcess(postId, userId, userLang, videoUrl, userDeviceToken, videoExtension, videoContentType, videoFullPath);
            return;



        }



    } catch (error) {
        console.error('Error processing video:', error);
    }




};




async function updatePost(postUid, isRejected) {
    try {
        const db = admin.firestore();
        await db.collection('posts').doc(postUid).update({
            'is_processed': true,
            'isRejected': isRejected,

        });
    } catch (err) {
        console.error('Error Updating post: ', err);
    }
}

async function nextProcess(postUid, userUid, userLang, videoUrl, dToken, videoExtension, videoContentType, vPath) {
    try {
        const db = admin.firestore();
        await db.collection('pprocess').doc(postUid).set({
            'post_id': postUid,
            'user_id': userUid,
            'user_lang_code': userLang,
            'videoUrl': videoUrl,
            'fcmToken': dToken,
            'video_extension': videoExtension,
            'contentType': videoContentType,
            'videoGsUri': vPath,
        });
    } catch (err) {
        console.error('Error Updating post: ', err);
    }

}

async function sendPushNotification(dToken, title, body) {
    const message = {
        token: dToken,
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