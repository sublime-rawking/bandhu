import { AES, enc, HmacSHA256 } from "crypto-js";

/**
 * Encrypts the provided data using AES encryption.
 * 
 * This function uses the AES encryption method from the crypto-js library
 * to encrypt the given data. The encryption key is retrieved from an
 * environment variable named AES_TOKEN. If AES_TOKEN is not set, an empty
 * string is used as the fallback encryption key.
 *
 * @param {string} data The data to be encrypted.
 * @return {string} The encrypted data as a string.
 */
export const encrypt = (data) => {
    // Encrypt the data using AES encryption with the key from environment variable or fallback to an empty string
    return AES.encrypt(data, process.env.AES_TOKEN || "").toString();
};

/**
 * Decrypts the provided data using AES decryption.
 * 
 * This function decrypts the data that was encrypted with the AES method, using
 * a key that is retrieved from the environment variable AES_TOKEN. If AES_TOKEN
 * is not found, an empty string is used as a fallback. The decrypted data is
 * returned as a UTF-8 encoded string.
 *
 * @param {string} data The encrypted data to be decrypted.
 * @return {string} The decrypted data as a UTF-8 string.
 */
export const decrypt = (data) => {
    // Decrypt the data using AES with the key from environment variable or an empty string as fallback
    return AES.decrypt(data, process.env.AES_TOKEN || "").toString(enc.Utf8);
};


/**
 * Generates a hash of the provided data using HMAC SHA256 encryption.
 * 
 * This function uses the HMAC SHA256 encryption method from the crypto-js library
 * to generate a hash of the given data. The encryption key is retrieved from an
 * environment variable named HMAC_TOKEN. If HMAC_TOKEN is not set, an empty
 * string is used as the fallback encryption key.
 *
 * @param {string} data The data to be hashed.
 * @return {string} The hash of the data as a string.
 */
export const generateHash = (data) =>
    HmacSHA256(data, process.env.HMAC_TOKEN || "").toString();

