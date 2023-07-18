/**
 * Triggered by a change to a Firestore document.
 *
 * @param {!Object} event Event payload.
 * @param {!Object} context Metadata for the event.
 */
const path = require('path');
const fs = require('fs');
const admin = require('firebase-admin');
admin.initializeApp();

const { S3Client, PutObjectCommand } = require("@aws-sdk/client-s3");
exports.uploadPostFiles2R2 = async (event, context) => {
  const documentData = event.value.fields;
  const postId = documentData.post_id.stringValue;
  const vGsUri = documentData.videoGsUri.stringValue;
  const gGsUri = documentData.gGsUri.stringValue;
  const userLang = documentData.user_lang_code.stringValue;
  const vContentType = documentData.contentType.stringValue;
  const vExtension = documentData.video_extension.stringValue;
  const status = documentData.status.stringValue;
  const fcmToken = documentData.fcmToken.stringValue;
  const userID = documentData.user_id.stringValue;
  const bucketName = 'gs://old-butgold.appspot.com';
  const r2BucketName = 'oldbutgold';



  const year = new Date().getFullYear();
  const month = new Date().getMonth() + 1;
  const day = new Date().getDate();
  const hour = new Date().getHours();
  const minute = new Date().getMinutes();
  const second = new Date().getSeconds();

  const videoR2Path = `uploads/${userID}/videos/${year}/${month}/${day}/${hour}/${minute}-${second}/video.${vExtension}`;
  const gifR2Path = `uploads/${userID}/videos/${year}/${month}/${day}/${hour}/${minute}-${second}/image.gif`;




  // Start downloading the video from Google Storage
  console.log('Start downloading the video from Google Storage');

  const destBucket = admin.storage().bucket(bucketName);
  const tempVideoPath = `/tmp/${path.parse(vGsUri).base}`;
  const tempGifPath = `/tmp/${path.parse(gGsUri).base}`;

  try {
    //
    const vFileContent = await destBucket.file(vGsUri).download({ destination: tempVideoPath });
    console.log('Video downloaded locally to');
    const videoFileContent = fs.readFileSync(tempVideoPath);
    const gFileContent = await destBucket.file(gGsUri).download({ destination: tempGifPath });
    console.log('Gif downloaded locally to');
    const gifFileContent = fs.readFileSync(tempGifPath);

    // Upload the video to Cloudflare R2
    console.log('Upload the video to Cloudflare R2');

    await uploadFile(r2BucketName, videoR2Path, videoFileContent, vContentType);
    console.log('Video uploaded to Cloudflare R2');
    await uploadFile(r2BucketName, gifR2Path, gifFileContent, 'image/gif');
    console.log('Gif uploaded to Cloudflare R2');
    await updatePost(postId, videoR2Path, gifR2Path);
    console.log('Post updated successfully');
    await sendPushNotification(fcmToken, 'Old but Gold', 'Your video is ready');
    console.log('Push notification sent successfully');
    await deleteFileFromBucket(bucketName, vGsUri);
    console.log('Video deleted successfully');
    await deleteFileFromBucket(bucketName, gGsUri);
    console.log('Gif deleted successfully');
    await deletePprocess(postId);
    console.log('Pprocess deleted successfully');
    return;

  } catch (err) {
    console.log('Error while downloading or uploading video', err);
    return;
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


// Send a message to devices subscribed to the provided topic.
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



async function updatePost(postId, vR2Path, gR2Path) {
  try {
    // Update the post to indicate that the video has been uploaded.
    const db = admin.firestore();
    await db.collection('posts').doc(postId).update({
      'is_ready': true,
      'thumbnailGifUrl': gR2Path,
      'videoUrl': vR2Path,

    });
    console.log('Post updated successfully');
  } catch (err) {
    console.log('Error while updating post', err);
  }
}


// delete pprocess

async function deletePprocess(postUid) {
  try {
    // Update the post to indicate that the video has been uploaded.
    const db = admin.firestore();
    await db.collection('pprocess').doc(postUid).delete();
    console.log('Pprocess deleted successfully');
  } catch (err) {
    console.log('Error while deleting pprocess', err);
  }
}


async function deleteFileFromBucket(bucketName, fileName) {
  try {
    const bucket = admin.storage().bucket(bucketName);
    await bucket.file(fileName).delete();
    console.log('File deleted successfully');
  } catch (err) {
    console.log('Error while deleting file', err);
  }
}

