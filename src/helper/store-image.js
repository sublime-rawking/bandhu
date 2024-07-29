import { Bucket, removeImage, uploadAndSetACL } from "@/config/awsS3Config";


/**
 * Stores an image in an AWS S3 bucket with a unique name based on the provided id and current date.
 *
 * @param {Object} options - An object containing the image, path, and id.
 * @param {File} options.image - The image file to be stored.
 * @param {string} options.path - The path in the S3 bucket where the image will be stored.
 * @param {string} options.id - The unique identifier used to generate the image name.
 * @return {Promise<string>} The URL of the stored image, or an empty string if an error occurred.
 */
export async function StoreImage({ image, path, id }) {
  try {

    const bytes = await image.arrayBuffer();
    const buffer = Buffer.from(bytes);
    const imageNameArray = image.name.split(".");
    const ext = imageNameArray[imageNameArray.length - 1];
    const currentDate = new Date().toISOString().replace(/[:.]/g, '-').substring(0, 19);
    const imageName = `${id}-${currentDate}.${ext}`;

    let params = {
      Bucket: Bucket,
      Key: `${path}/${imageName}`,
      Body: buffer,
      ACL: 'public-read',
    };

    return await uploadAndSetACL(params).catch((err) => {
      console.error('ERROR MSG: ', err);
      return ""
    });


  } catch (err) {
    console.error('ERROR MSG: ', err);
    return ''
  }

}

/**
 * Deletes an image from an AWS S3 bucket.
 *
 * @param {Object} options - The options for deleting the image.
 * @param {string} options.image - The URL of the image to be deleted.
 * @return {Promise<void>} A promise that resolves when the image is successfully deleted.
 */
export async function DeleteFile({ image, path }) {
  const fileName = image.split('/').pop();
  var params = {
    Bucket: Bucket,
    Key: `${path}/${fileName}`,
    /* 
       where value for 'Key' equals 'pathName1/pathName2/.../pathNameN/fileName.ext'
       - full path name to your file without '/' at the beginning
    */
  };

  await removeImage(params);

} 