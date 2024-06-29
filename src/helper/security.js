import { AES, enc, HmacSHA256 } from "crypto-js";

export const encrypt = (data) =>
    AES.encrypt(data, process.env.AES_TOKEN || "").toString();

export const decrypt = (data) =>
    AES.decrypt(data, process.env.AES_TOKEN || "").toString(enc.Utf8);


export const generateHash = (data) =>
    HmacSHA256(data, process.env.HMAC_TOKEN || "").toString();

