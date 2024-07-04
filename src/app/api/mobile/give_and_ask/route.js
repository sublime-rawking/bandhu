
import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import validator from "@/helper/validate";
import { Promise } from "es6-promise";
import moment from "moment/moment";


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

        const dateTime = moment.utc(bodyData.date).toDate();
        const giveAndAsk = await prisma.give_ask.create({
            data: {
                ask: bodyData.ask,
                date: dateTime,
                given: bodyData.given,
                remark: bodyData.remark,
                member_id: token.data.id
            },
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




export const GET = async (request) => {
    try {

        const token = await VerifyToken();
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }


        const searchParams = new URL(request.url).searchParams;
        const id = searchParams.get('id');
        let giveAndAsk = []
        if (searchParams.get("date")) {
            giveAndAsk = await prisma.give_ask.findMany({
                where: {
                    member_id: id ? Number(id) : token.data.id,
                    date: {
                        gte: moment.utc(searchParams.get("date"), "YYYY-MM").startOf('month').toDate(),
                        lte: moment.utc(searchParams.get("date"), "YYYY-MM").endOf('month').toDate(),
                    }
                },
                orderBy: {
                    date: 'asc'
                }
            });

        } else {
            giveAndAsk = await prisma.give_ask.findMany({
                where: {
                    member_id: id ? Number(id) : token.data.id
                },
                orderBy: {
                    date: 'asc'
                }

            });
        }

        return Response.json({
            success: true,
            message: "give and ask successfully",
            data: giveAndAsk,
        }, { status: 200 });


    } catch (error) {
        console.error(error);
        return Response.json({
            success: false,
            message: error.message,
            error: error,
            data: {},
        })
    }
} 