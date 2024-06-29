import { decrypt, encrypt } from "@/helper/security";
import { GetEmailVerificationMessage, SendMail } from "@/helper/send-mail";
import validator from "@/helper/validate";
import { Promise } from "es6-promise";
import prisma from "@/config/dbConfig";
import { GenerateOTP } from "@/helper/otpProvider";


export async function GET(request) {

    try {
        const { searchParams } = new URL(request.url);

        const { error, status } = await new Promise((resolve) => {
            validator({ ...Object.fromEntries(searchParams) }, {
                email: "required",
            }, {}, (error, status) => {
                resolve({ error, status });
            });
        });


        if (!status) {
            return Response.json({
                success: false,
                message: "validation error",
                data: { ...error.errors },
            }, { status: 400 });
        }

        const email = searchParams.get("email");
        const otp = encrypt(GenerateOTP().toString());
        await prisma.members.findFirst({
            where: {
                email: email,
                status: {
                    not: 2
                }
            },

        });
        const mailOptions = {
            from: 'noreply@reffergenix',
            to: email,
            subject: 'RefferGenix - Reset Password',
            html: GetEmailVerificationMessage({ otpCode: decrypt(otp) }),
        }
        const emailSend = await SendMail(mailOptions)
        if (!emailSend) {
            return Response.json({
                success: false,
                message: "email not send",
                data: {},
            }, { status: 500 });
        }

        //send email to user
        return Response.json({
            success: true,
            message: "email has been sent",
            data: {},
        }, { status: 200 });
    } catch (error) {
        console.error(error);
        return Response.json({ success: false, message: error.message, data: {}, error }, { status: 500 });
    }
}
