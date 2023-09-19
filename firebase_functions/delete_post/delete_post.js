/**
 * Triggered by a change to a Firestore document.
 *
 * @param {!Object} event Event payload.
 * @param {!Object} context Metadata for the event.
 */

const admin = require('firebase-admin');
admin.initializeApp({
    databaseURL: "https://old-butgold-default-rtdb.europe-west1.firebasedatabase.app",
});

const { S3Client, DeleteObjectCommand } = require("@aws-sdk/client-s3");



exports.deletePost = async (event, context) => {
    const documentData = event.value.fields;
    const postId = documentData.post_id.stringValue;
    const userLang = documentData.user_lang_code.stringValue;
    const fcmToken = documentData.fcmToken.stringValue;
    const userID = documentData.user_id.stringValue;
    const r2BucketName = 'oldbutgold';

    try {
        const db = admin.firestore().collection('posts');
        await db.doc(postId).get().then(async (doc) => {
            const data = doc.data();
            const userid = data.user_id;
            const videoUrl = data.videoUrl;
            const gifUrl = data.thumbnailGifUrl;
            if (userID === userid) {
                // Delete the video from Cloudflare R2
                await deleteVideoFromR2(videoUrl, r2BucketName);
                console.log('Video deleted from R2');
                await deleteVideoFromR2(gifUrl, r2BucketName);
                console.log('Gif deleted from R2');
                // Delete the post from Firestore
                await db.doc(postId).delete();
                console.log('Post deleted from Firestore');
                // Delete the post from RealtimeDB
                await deletePostFromRealtimeDB(postId);
                // Delete the post from delete_post collection
                await admin.firestore().collection('delete_post').doc(postId).delete();
                console.log('Delete-post document deleted from Firestore');
            } else {
                console.log('User not authorized to delete this post');
            }
        });

    } catch (error) {
        console.log(`Error::::: ${error}`);
    }
};



const s3 = new S3Client({
    region: 'auto',
    endpoint: process.env.CF_ENDPOINT,
    credentials: {
        accessKeyId: process.env.CF_ACCESS_KEY_ID,
        secretAccessKey: process.env.CF_SECRET_ACCESS_KEY,
    },
});


async function deleteVideoFromR2(videoUrl, r2BucketName) {

    const params = {
        Bucket: r2BucketName,
        Key: videoUrl,
    };
    try {
        const data = await s3.send(new DeleteObjectCommand(params));
        console.log('Success', data);
    } catch (err) {
        console.log('Error', err);
    }
}


async function deletePostFromRealtimeDB(postId) {
    try {
        await admin.database().ref('posts').child(postId).remove();
        console.log('Post deleted from RealtimeDB');
    } catch (error) {
        console.log(`Error::::: ${error}`);
    }
}


