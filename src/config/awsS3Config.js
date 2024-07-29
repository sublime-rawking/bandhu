import { S3 } from "aws-sdk";


export const Bucket = process.env.BUCKET_NAME;


var s3 = new S3({
    region: process.env.AWS_REGION,
    accessKeyId: process.env.AWS_ACCESS_KEY_ID,
    secretAccesskey: process.env.AWS_SECRET_ACCESS_KEY,

});

/**
 * Retrieves a list of buckets in the AWS S3 account.
 *
 * @returns {Promise<Array>} - A promise that resolves to an array of bucket names.
 */
export async function getFile() {
    try {
        // Call the S3 listBuckets method to retrieve a list of buckets.
        // The listBuckets method returns a promise that resolves to an array of bucket names.
        const data = await s3.listBuckets().promise();
        return data;
    } catch (error) {
        // Log any errors that occur during the bucket retrieval process.
        console.error("error:", error);
        return []
    }
}

/**
 * Deletes an image from the AWS S3 bucket.
 *
 * @param {Object} params - The parameters for deleting the image.
 * @returns {Promise<boolean>} - A promise that resolves to true if the image was successfully deleted, or false otherwise.
 */
export async function removeImage(params) {
    try {
        // Call the S3 deleteObject method to delete the image from the bucket.
        // The deleteObject method accepts a params object with the Bucket and Key properties.
        // The method returns a promise that resolves to the result of the deletion.
        const removingS3 = await s3.deleteObject(params, function (err, data) {
            if (err) {
                console.error(err, err.stack, data); // Log an error if it occurred
                return false; // Return false if an error occurred
            }
        }).promise();

        // Return the DeleteMarker property of the deletingS3 object.
        // The DeleteMarker property indicates whether a delete marker was created.
        return removingS3.DeleteMarker;
    } catch (error) {
        console.error("error:", error); // Log any errors that occur
        return false; // Return false if an error occurred
    }
}


/**
 * Uploads a file to the AWS S3 bucket and sets its access control list (ACL).
 *
 * @param {Object} params - The parameters for uploading the file.
 * @returns {Promise<string>} - A promise that resolves to the URL of the uploaded file.
 */
export async function uploadAndSetACL(params) {
    // Call the S3 upload method to upload the file to the bucket.
    // The upload method accepts a params object with the Bucket, Key, Body, and ACL properties.
    // The method returns a promise that resolves to the result of the upload.
    const uploadResult = await s3.upload(params).promise();
    // Return the Location property of the uploadResult object.
    // The Location property contains the URL of the uploaded file.
    return uploadResult.Location;
}
