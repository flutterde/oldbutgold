
const admin = require("firebase-admin");
const path = require("path");
const ffmpegPath = require('@ffmpeg-installer/ffmpeg').path;
const ffmpeg = require("fluent-ffmpeg");
const fs = require('fs');

ffmpeg.setFfmpegPath(ffmpegPath);

admin.initializeApp();


exports.generateGif = async (event, context) => {
    const documentData = event.value.fields;
    const postId = documentData.post_id.stringValue;
    const vGsUri = documentData.videoGsUri.stringValue;
    const gGsUri = replaceAfterLastSlashWithImage(vGsUri);
    const bucketName = 'gs://old-butgold.appspot.com';



    await generateGif(vGsUri, 5, 7, bucketName, gGsUri, postId);


};




function replaceAfterLastSlashWithImage(filePath) {
    const directory = path.dirname(filePath);
    const basename = path.basename(filePath);

    const newBasename = basename.substring(0, basename.lastIndexOf('/')) + 'image.gif';
    const newFilePath = path.join(directory, newBasename);

    return newFilePath;
}













async function generateGif(vGsUri, startTime, duration, bucketName, gGsUri, postID) {
  const destBucket = admin.storage().bucket(bucketName);
  const tempFilePath = `/tmp/${path.parse(vGsUri).base}`;

  // Download file from bucket.
  await destBucket.file(vGsUri).download({destination: tempFilePath});

  // Generate the gif using ffmpeg
  return new Promise((resolve, reject) => {
    ffmpeg(tempFilePath)
      .setStartTime(startTime)
      .setDuration(duration)
      .output(`/tmp/${path.parse(vGsUri).name}.gif`)
      .outputOptions(
        '-vf',
        'fps=7,scale=486:864:flags=lanczos,split[s0][s1];[s0]palettegen=max_colors=64:stats_mode=diff[p];[s1][p]paletteuse=dither=bayer:bayer_scale=5:diff_mode=rectangle'
      )
      .on('end', () => {
        console.log('GIF generation complete!');
        // Upload the generated GIF file to Firebase Storage
        const destFile = destBucket.file(gGsUri);
        const writeStream = destFile.createWriteStream({
          metadata: {
            contentType: 'image/gif',
          },
        });
        writeStream.on('error', (uploadErr) => {
          console.error('Error uploading GIF file:', uploadErr);
          reject(uploadErr);
        });
        writeStream.on('finish', async () => {
          console.log('GIF file uploaded successfully!');
          await updatePprocess(postID, gGsUri);
          resolve();
        });
        const readStream = fs.createReadStream(`/tmp/${path.parse(vGsUri).name}.gif`);
        readStream.on('error', (readErr) => {
          console.error('Error reading GIF file:', readErr);
          reject(readErr);
        });
        readStream.pipe(writeStream);
      })
      .on('error', (ffmpegErr) => {
        console.error('Error generating GIF:', ffmpegErr.message);
        // Delete the temporary video and GIF files
        destBucket.file(vGsUri).delete();
        destBucket.file(gGsUri).delete();
        reject(ffmpegErr);
      })
      .run();
  });
}



async function updatePprocess(postUid, gGsUrl) {
   try{
    const db = admin.firestore();
    await db.collection('pprocess').doc(postUid).update({
        'status': 'done',
        'gGsUri': gGsUrl,
    });
    

   } catch (err) {
      console.log('Error while updating Pprocess',err);
   }
}