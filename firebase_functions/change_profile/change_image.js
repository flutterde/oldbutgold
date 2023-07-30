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
exports.changeProfile = async (event, context) => {
  const documentData = event.value.fields;
  const user_id = documentData.user_id.stringValue;
  const iGsUri = documentData.img_file_path.stringValue;
  const iContentType = documentData.img_content_type.stringValue;
  const iExtension = documentData.extension.stringValue;
  const bucketName = 'gs://old-butgold.appspot.com';
  const r2BucketName = 'oldbutgold';



  const hour = new Date().getHours();
  const minute = new Date().getMinutes();
  const second = new Date().getSeconds();

  const imageR2Path = `uploads/${user_id}/profile/${hour}/${minute}-${second}/image.${iExtension}`;




  // Start downloading the image from Google Storage
  console.log('Start downloading the image from Google Storage');

  const destBucket = admin.storage().bucket(bucketName);
  const tempImagePath = `/tmp/${path.parse(iGsUri).base}`;

  try {
    //
    const iFileContent = await destBucket.file(iGsUri).download({ destination: tempImagePath });
    console.log('image downloaded locally to');
    const imageFileContent = fs.readFileSync(tempImagePath);


    // Upload the image to Cloudflare R2
    console.log('Upload the image to Cloudflare R2');

    await uploadFile(r2BucketName, imageR2Path, imageFileContent, iContentType);
    console.log('image uploaded to Cloudflare R2');


    await updateUserData(user_id, imageR2Path);
    console.log('User updated successfully');

    await deleteFileFromBucket(bucketName, iGsUri);
    console.log('File deleted successfully');
    await deleteDoc(user_id);
    console.log('Pprocess deleted successfully');
    return;

  } catch (err) {
    console.log('Error while downloading or uploading image', err);
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






async function updateUserData(userUid, iR2Path) {
  try {
    // Update the post to indicate that the video has been uploaded.
    const db = admin.firestore();
    await db.collection('users').doc(userUid).update({
        'profile': {
            'profile_photo_url':iR2Path,
        }

    });
    console.log('User  updated successfully');
  } catch (err) {
    console.log('Error while updating user', err);
  }
}


// delete pprocess

async function deleteDoc(userUid) {
  try {
    // Update the post to indicate that the video has been uploaded.
    const db = admin.firestore();
    await db.collection('change_profile').doc(userUid).delete();
    console.log('doc deleted successfully');
  } catch (err) {
    console.log('Error while deleting doc', err);
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

