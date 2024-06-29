import { verify, sign } from "jsonwebtoken";
import { encrypt, decrypt } from "@/helper/security";
import { headers } from "next/headers";


/**
 * Verifies a JSON Web Token (JWT) for authentication.
 *
 * @return {Promise<Object>} An object containing the verification status, data, and message.
 * - `message` (string): A message describing the verification status.
 * - `success` (boolean): Indicates whether the verification was successful.
 * - `data` (Object): The decoded data from the JWT.
 * - `error` (Object): An error object if the verification fails.
 *
 * @throws {Error} If the JWT is invalid or missing.
 */
export async function VerifyToken() {
  try {
    const headersList = headers();
    const token = headersList.get("x-access-token");
    if (!token) {
      return {
        message: "A Token is Required for Authentication",
        success: false,
        data: {},
      };
    }
    const _decryptToken = decrypt(token);
    let decodedData = verify(_decryptToken, process.env.JWT_SECRET_KEY || "");

    if (typeof decodedData !== "object") {
      decodedData = {};
    }

    return { success: true, data: decodedData.data, message: "Token Verified" };
  } catch (error) {
    return {
      success: false,
      data: {
      },
      message: "Authentication Token is invalid",
      error
    };
  }
}



/**
 * Generates a JSON Web Token (JWT) with the provided data and returns an encrypted version of it.
 *
 * @param {Object} data - The data to be included in the JWT.
 * @return {string} The encrypted JWT.
 */
export function GenerateToken(data) {

  data.iat = Date.now();
  const token = sign({ data }, process.env.JWT_SECRET_KEY || "", {
    expiresIn: "10d",
  });
  return encrypt(token);
}
