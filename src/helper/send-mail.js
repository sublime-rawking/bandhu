import { createTransport } from 'nodemailer';

/**
 * Sends an email using the provided mail options.
 *
 * @param {Object} mailOptions - The options for sending the email.
 * @param {string} mailOptions.from - The sender's email address.
 * @param {string} mailOptions.to - The recipient's email address.
 * @param {string} mailOptions.subject - The subject of the email.
 * @param {string} mailOptions.html - The HTML content of the email.
 * @return {Promise<boolean>} A Promise that resolves to true if the email is sent successfully, otherwise false.
 */
export async function SendMail({ mailOptions }) {
    try {

        const transporter = createTransport({
            host: "smtp.gmail.com",
            port: 587,
            secure: false,
            auth: {
                user: process.env.NODEMAILER_USERNAME,
                pass: process.env.NODEMAILER_PASSWORD,
            },
        });

        const result = await transporter.sendMail(mailOptions);
        return result.messageId ? true : false;

    } catch (error) {
        console.error(error);
        return false
    }
}

/**
 * Generates an HTML email verification message with the given OTP code.
 *
 * @param {Object} options - The options object.
 * @param {string} options.otpCode - The OTP code to include in the message.
 * @return {string} The HTML email verification message.
 */
export function GetEmailVerificationMessage({ otpCode }) {
    return `
 <!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>RefferGenix - Email Verification</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f5f5f5;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #fff;
            border-radius: 5px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }

        .header {
            background: linear-gradient(to right, #972929, #df4e4e);
            color: #fff;
            padding: 20px;
            text-align: center;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
        }

        .content {
            padding: 20px;
            color: #333;
        }

        h1 {
            /* font-size: 10px; */
            margin: 0;
        }

        p {
            font-size: 16px;
            margin-top: 10px;
            line-height: 1.5;
        }

        .otp {
            font-size: 28px;
            font-weight: bold;
            color: #df4e55;
            margin-top: 15px;
        }

        .note {
            font-size: 14px;
            color: #888;
            margin-top: 10px;
        }
    </style>
</head>

<body>
    <div class="container">
        <div class="header">
            <h1>RefferGenix</h1>
            <p>Email Verification</p>
        </div>
        <div class="content">
            <p>Dear RefferGenix User,</p>
            <p>Your One-Time Password (OTP) for email verification is:</p>
            <p class="otp">${otpCode}</p>
            <p class="note">This OTP will expire in 10 minutes. Please use it to verify your email address and access
                your RefferGenix account securely.</p>

            <p class="note">If you did not request this verification, please ignore this email.</p>
            <p>Thank you for verification of email</p>
        </div>
    </div>
</body>

</html>
 `;
}