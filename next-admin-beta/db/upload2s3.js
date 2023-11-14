"use client";
import { S3Client, PutObjectCommand } from "@aws-sdk/client-s3";

const s3 = new S3Client({
    region: 'auto',
    endpoint: process.env.NEXT_PUBLIC_CF_ENDPOINT,
    credentials: {
        accessKeyId: process.env.NEXT_PUBLIC_CF_ACCESS_KEY_ID,
        secretAccessKey: process.env.NEXT_PUBLIC_CF_SECRET_ACCESS_KEY,
    },
});

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
        return (true);
    }
    catch (err) {
        console.log("Error", err);
        return (false);
    }
};


const handleUploadFn = async ( fileName, fileContent, contentType) => {
    const date = new Date();
    const year = date.getFullYear();
    const month = date.getMonth() + 1;
    const milliseconds = date.getMilliseconds();
    const s3_path = 'ads/' + year + '/' + month + '/' + milliseconds + '/' + fileName;
    try {
        const result = await uploadFile("my-bucket-1234", s3_path, fileContent, contentType);
        if (result) {
            console.log('File uploaded successfully');
            return { status: 200, message: "File uploaded successfully", path: s3_path };
        } else {
            console.log('File upload failed');
            return { status: 500, message: "File upload failed" };
        }

    } catch (error) {
        console.log('File upload failed');
        return { status: 500, message: "File upload failed" };

    }
}

export default handleUploadFn;