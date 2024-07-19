import { decrypt, encrypt } from "@/helper/security";
import { GetEmailVerificationMessage, SendMail } from "@/helper/send-mail";
import validator from "@/helper/validate";
import { Promise } from "es6-promise";
import prisma from "@/config/dbConfig";
import { GenerateOTP } from "@/helper/otpProvider";


/**
 * Handles the GET request to send a password reset email to the user.
 *
 * @param {Request} request - The request object containing the user's email.
 * @return {Response} JSON response with the status of the password reset email.
 */
export async function GET(request) {
    try {
        // Extract the email from the request URL
        const { searchParams } = new URL(request.url);

        // Validate the email
        const { error, status } = await new Promise((resolve) => {
            validator({ ...Object.fromEntries(searchParams) }, {
                email: "required",
            }, {}, (error, status) => {
                resolve({ error, status });
            });
        });

        // If the email is invalid, return an error response
        if (!status) {
            return Response.json({
                success: false,
                message: "validation error",
                data: { ...error.errors },
            }, { status: 400 });
        }

        // Generate an OTP and encrypt it
        const email = searchParams.get("email");
        const otp = encrypt(GenerateOTP().toString());

        // Find the user with the given email and check if the user is active
        await prisma.members.findFirst({
            where: {
                email: email,
                status: {
                    not: 2
                }
            },

        });

        // Create the mail options for the password reset email
        const mailOptions = {
            from: 'noreply@reffergenix',
            to: email,
            subject: 'RefferGenix - Reset Password',
            html: GetEmailVerificationMessage({ otpCode: decrypt(otp) }),
        }

        // Send the password reset email to the user
        const emailSend = await SendMail(mailOptions)

        // If the email is not sent, return an error response
        if (!emailSend) {
            return Response.json({
                success: false,
                message: "email not sent",
                data: {},
            }, { status: 500 });
        }

        // Return a success response
        return Response.json({
            success: true,
            message: "email has been sent",
            data: {},
        }, { status: 200 });
    } catch (error) {
        // Log the error and return an error response
        console.error(error);
        return Response.json({ success: false, message: error.message, data: {}, error }, { status: 500 });
    }
}
