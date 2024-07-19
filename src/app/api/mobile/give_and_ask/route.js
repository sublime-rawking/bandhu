
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
 *
 * The response object contains the success status, a message, and the created give and ask data.
 * If there is an error, the response object contains the error message.
 */
export const POST = async (request) => {
    try {

        // Verify the token
        const token = await VerifyToken();
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        // Extract the give and ask data from the request body
        const bodyData = await request.json();

        // Validate the give and ask data
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

        // If the give and ask data is invalid, return an error response
        if (!status) {
            return Response.json({
                success: false,
                message: "validation error",
                data: {},
                error
            }, { status: 400 });
        }

        // Convert the give and ask date to a moment object
        const dateTime = moment.utc(bodyData.date).toDate();

        // Create a new give and ask record in the database
        const giveAndAsk = await prisma.give_ask.create({
            data: {
                ask: bodyData.ask,
                date: dateTime,
                given: bodyData.given,
                remark: bodyData.remark,
                member_id: token.data.id
            },
        });

        // Return a success response with the created give and ask data
        return Response.json({
            success: true,
            message: "Added give and ask successfully",
            data: giveAndAsk,
        }, { status: 200 });
    } catch (error) {
        console.error(error);

        // Return an error response with the error message
        return Response.json({
            success: false,
            message: error.message,
            error: error,
            data: {},
        }, { status: 500 });
    }
}




/**
 * Handles the GET request to retrieve give and ask records for a given member
 * and date range.
 * 
 * @param {Request} request - The request object containing the search parameters.
 * @return {Promise<Response>} A promise that resolves to a response object containing the result of the query.
 */
export const GET = async (request) => {
    try {

        // Verify the token
        const token = await VerifyToken();
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        // Extract the search parameters
        const searchParams = new URL(request.url).searchParams;
        const id = searchParams.get('id');

        // Define the database query
        let giveAndAsk = []
        if (searchParams.get("date")) {

            // If a date is provided, filter by the given date range
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

            // If no date is provided, return all give and ask records for the given member
            giveAndAsk = await prisma.give_ask.findMany({
                where: {
                    member_id: id ? Number(id) : token.data.id
                },
                orderBy: {
                    date: 'asc'
                }

            });
        }

        // Return the result of the query
        return Response.json({
            success: true,
            message: "give and ask successfully",
            data: giveAndAsk,
        }, { status: 200 });

    } catch (error) {
        console.error(error);

        // Return an error response if an error occurs
        return Response.json({
            success: false,
            message: error.message,
            error: error,
            data: {},
        })
    }
}
