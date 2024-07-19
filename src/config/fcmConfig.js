import admin from "firebase-admin";
import serviceAccount from "@/assets/fcm/serviceAccountKey.json";
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

/**
 * Sends a message to a device using the Firebase Cloud Messaging (FCM) API.
 *
 * @param {Object} payload - The payload to be sent to the device.
 * @return {Promise<Object>} A Promise that resolves to the response object or rejects with the error.
 */
export async function sendMsgFunction({ payload }) {

  const messaging = admin.messaging();

  try {
    const response = await messaging.send(payload);
    console.log("Successfully sent message:", response);
    return response;
  } catch (error) {
    console.error("fcm error:", error);
    throw error;
  }
}

