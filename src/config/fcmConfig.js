import admin from "firebase-admin";
import serviceAccount from "@/assets/fcm/serviceAccountKey.json";
if (!admin.apps.length) {
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });
}

export async function sendMsgFunction({ payload }) {

  let response = await admin
    .messaging()
    .send(payload)
    .then((response) => {
      console.log("Successfully sent message:", response);
      return response;
    })
    .catch((error) => {
      console.error("fcm error:", error);
    });
  return response;
}
