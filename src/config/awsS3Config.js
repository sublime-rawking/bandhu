import amazon from "aws-sdk";

export const Bucket = process.env.BUCKET_NAME;

const s3 = new amazon.S3({
    region: process.env.AWS_REGION,
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
});


/**
 * Removes an image from an AWS S3 bucket.
 *
 * @param {Object} params - The parameters for deleting the image.
 * @param {string} params.Bucket - The name of the bucket.
 * @param {string} params.Key - The key of the object to delete.
 * @return {Promise<void>} A promise that resolves when the image is successfully deleted.
 */
export async function RemoveImage(params) {
    await s3.deleteObject(params, function (err, data) {
        if (err) console.log(err, err.stack); // an error occurred
        else console.log(data);           // successful response
    }).promise();
}

export async function UploadAndSetACL(params) {
    const uploadResult = await s3.upload(params).promise();
    // delete params.Body;
    // const aclResult = await s3.putObjectAcl(params).promise()
    // console.log('Successfully set ACL data', aclResult);

    return uploadResult.Location;
}