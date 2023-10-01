const admin = require("firebase-admin");
const path = require("path");
const fs = require('fs');
const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");

admin.initializeApp();

exports.uploadMp3ToR2 = async (event, context) => {
    const documentData = event.value.fields;
    const postId = context.params.uid;
    const auGsUri = documentData.audioUrl.stringValue;
    const userID = documentData.user_id.stringValue;
    const bucketName = 'gs://old-butgold.appspot.com';
    const r2BucketName = 'oldbutgold';

    const year = new Date().getFullYear();
    const month = new Date().getMonth() + 1;
    const day = new Date().getDate();
    const hour = new Date().getHours();
    const minute = new Date().getMinutes();
    const second = new Date().getSeconds();

    const audioR2Path = `uploads/${userID}/videos/${year}/${month}/${day}/${hour}/${minute}-${second}/audio.mp3`;

    console.log('Start downloading the Audio from Google Storage');
    const destBucket = admin.storage().bucket(bucketName);
    const tempFilePath = `/tmp/${path.parse(auGsUri).base}`;
    try {
        const fileContent = await destBucket.file(auGsUri).download({ destination: tempFilePath });
        console.log('Audio downloaded locally to');
        const fileContentBuffer = fs.readFileSync(tempFilePath);
        await uploadFile(r2BucketName, audioR2Path, fileContentBuffer, 'audio/mpeg');
        console.log('Audio uploaded to Cloudflare R2');
        await updatePost(postId, audioR2Path);
        console.log('Post updated successfully');
        await deleteFileFromGoogleStorage(auGsUri, bucketName);
        console.log('Audio deleted from Google Storage');
        await deleteDocFromFirestore(postId);
        console.log('Post deleted from Firestore');
        return;
    } catch (err) {
        console.log('Eorror in try catch');
        console.log(err);
        console.log('End of Eorror in try catch');
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

// store video in cloudflare r2
const uploadFile = async (bucketName, fileName, fileContent, contentType) => {
    console.log('Upload to r2 Taks ========================');
    console.log(`Uploading file: ${fileName} to bucket: ${bucketName}`);
    const command = new PutObjectCommand({
        Bucket: bucketName,
        Key: fileName,
        Body: fileContent,
        ContentType: contentType,
    });
    try {
        const { ETag, Location } = await s3.send(command);
        console.log(`File uploaded successfully at ${Location}`);
    }
    catch (err) {
        console.log("Error", err);
    }
};

async function updatePost(postID, audioUrl) {
    const postRef = admin.firestore().collection('posts').doc(postID);
    await postRef.update({
        'audioUrl': audioUrl,
        'audio_status': 'ready',
    });
    console.log('!!Audio Url updated in the database!!');
}

async function deleteFileFromGoogleStorage(auGsUri, bucketName) {
    const destBucket = admin.storage().bucket(bucketName);
    await destBucket.file(auGsUri).delete();
    console.log('!!Audio deleted from Google Storage!!');
}

async function deleteDocFromFirestore(postID) {
    const db = admin.firestore();
    await db.collection('process_mp3').doc(postID).delete();
    console.log('!!Process_mp3 deleted from Firestore!!');
}
