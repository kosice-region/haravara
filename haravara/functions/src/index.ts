import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import * as nodemailer from "nodemailer";
/* eslint-disable */
admin.initializeApp();
const db = admin.database();

const transporter = nodemailer.createTransport({
  host: "smtp.m1.websupport.sk",
  port: 465,
  secure: true,
  auth: {
    user: process.env.SENDER_EMAIL,
    pass: process.env.SENDER_PASSWORD,
  },
});

exports.sendVerificationCode = functions.https.onCall(
  async (data: { email: string }) => {
    const email = data.email;
    const code = Math.floor(1000 + Math.random() * 9000);

    console.log("entry");
    const mailOptions = {
      from: "users@haravara.sk",
      to: email,
      subject: "Your Verification Code",
      text: `Your verification code is ${code}`,
    };

    try {
      console.log("try");
      await transporter.sendMail(mailOptions);
      console.log("try2");
      await db.ref("verificationCodes/" + encodeURIComponent(email)).set({
        code: code,
        timestamp: admin.database.ServerValue.TIMESTAMP,
      });
      return {success: true};
    } catch (error) {
      console.error("Error sending email: ", error);
      throw new functions.https.HttpsError(
        "unknown",
        "Failed to send email",
        error
      );
    }
  }
);
