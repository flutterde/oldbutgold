const admin = require("firebase-admin");
const path = require("path");
const ffmpegPath = require('@ffmpeg-installer/ffmpeg').path;
const ffmpeg = require("fluent-ffmpeg");
const fs = require('fs');

ffmpeg.setFfmpegPath(ffmpegPath);
admin.initializeApp();

exports.videToMp3 = async (event, context) => {
    const documentData = event.value.fields;
    const postId = context.params.uid;
    const userId = documentData.user_id.stringValue;
    const videoMetadata = documentData.meta_data.mapValue.fields;
    const videoFullPath = videoMetadata.fullPath.stringValue;
    const aGsUri = replaceAfterLastSlashWithImage(videoFullPath);
    const bucketName = 'gs://old-butgold.appspot.com';
    await extractAudio(videoFullPath, bucketName, aGsUri, postId, userId);
};


function replaceAfterLastSlashWithImage(filePath) {
    const directory = path.dirname(filePath);
    const basename = path.basename(filePath);
    const newBasename = basename.substring(0, basename.lastIndexOf('/')) + 'audio.mp3';
    const newFilePath = path.join(directory, newBasename);
    return newFilePath;
}


async function extractAudio(vGsUri, bucketName,
    gGsUri, postID, userUid) {
    const destBucket = admin.storage().bucket(bucketName);
    const tempFilePath = `/tmp/${path.parse(vGsUri).base}`;
    // Download file from bucket.
    await destBucket.file(vGsUri).download({ destination: tempFilePath });
    // Extract the audio using ffmpeg
    return new Promise((resolve, reject) => {
        ffmpeg()
            .input(tempFilePath)
            .audioCodec('libmp3lame')
            .audioChannels(2)
            .toFormat('mp3')
            .output(`/tmp/${path.parse(vGsUri).name}.mp3`)
            .on('end', () => {
                console.log('!!Audio extraction finished.!!');
                // Upload the generated Audio file to Firebase Storage
                const destFile = destBucket.file(gGsUri);
                const writeStream = destFile.createWriteStream({
                    metadata: {
                        contentType: 'audio/mpeg',
                    },
                });
                writeStream.on('error', (uploadErr) => {
                    console.error('Error uploading Audio file:', uploadErr);
                    reject(uploadErr);
                });
                writeStream.on('finish', async () => {
                    console.log('Audio file uploaded successfully!');
                    await updatePost(postID, gGsUri, userUid);
                    resolve();
                });
                const readStream = fs.createReadStream(`/tmp/${path.parse(vGsUri).name}.mp3`);
                readStream.on('error', (readErr) => {
                    console.error('Error reading Audio file:', readErr);
                    reject(readErr);
                });
                readStream.pipe(writeStream);
            })
            .on('error', (ffmpegErr) => {
                console.error('Error generating Audio:', ffmpegErr.message);
                // Delete the temporary video and Audio files
                destBucket.file(vGsUri).delete();
                destBucket.file(gGsUri).delete();
                reject(ffmpegErr);
            })
            .run();
    });
}

async function updatePost(postID, audioUrl, user) {
    const postRef = admin.firestore().collection('process_mp3').doc(postID);
    await postRef.set({
        'audioUrl': audioUrl,
        'status': 'done',
        'user_id': user,
        'post_id': postID,
    });
    console.log('!!Audio Url updated in the database!!');
}