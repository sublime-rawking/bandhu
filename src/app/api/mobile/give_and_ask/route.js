
import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import validator from "@/helper/validate";
import { Promise } from "es6-promise";
import moment from "moment";


/**
 * Handles the POST request to create a new give and ask.
 *
 * @param {Request} request - The request object containing the give and ask data.
 * @return {Promise<Response>} A promise that resolves to the response object.
 */
export const POST = async (request) => {
    try {

        const token = await VerifyToken();
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        const bodyData = await request.json();

        const { error, status } = await new Promise((resolve) => {
            validator(bodyData, {
                date: "required",
                given: "required",
                ask: "required",
                remark: "required",
            }, {}, (error, status) => {
                resolve({ error, status });
            });
        });

        if (!status) {
            return Response.json({
                success: false,
                message: "validation error",
                data: {},
                error
            }, { status: 400 });
        }

        const giveAndAsk = await prisma.give_ask.create({
            data: {
                ask: bodyData.ask,
                date: moment("YYYY-MM-DD").format(bodyData.date),
                given: bodyData.given,
                remark: bodyData.remark,
                member_id: token.data.id
            }
            , include: {
                memberDetail: true
            }
        });


        return Response.json({
            success: true,
            message: "Added give and ask successfully",
            data: giveAndAsk,
        }, { status: 200 });
    } catch (error) {
        console.error(error);

        return Response.json({
            success: false,
            message: error.message,
            error: error,
            data: {},
        }, { status: 500 });
    }
}


