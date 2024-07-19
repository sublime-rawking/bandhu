import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import moment from "moment/moment";


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
                        gte: moment.utc(searchParams.get("date") , "YYYY-MM").startOf('month').toDate(),
                        lte: moment.utc(searchParams.get("date") , "YYYY-MM").endOf('month').toDate(),
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

        // Group the give and ask records by date
        const groupedData = giveAndAsk.reduce((acc, item) => {
            const date = item.date.toISOString().split('T')[0];
            if (!acc[date]) {
                acc[date] = { length: 0 };
            }
            acc[date].length++;
            acc[date].date = moment.utc(item.date);
            return acc;
        }, {});

        // Convert the grouped data to an array
        const groupedDataArray = Object.values(groupedData);

        // Return the grouped data in the response
        return Response.json({
            success: true,
            message: "give and ask successfully",
            data: groupedDataArray,
        }, { status: 200 });

    } catch (error) {
        // Log any errors that occur
        console.error(error);

        // Return an error response
        return Response.json({
            success: false,
            message: error.message,
            error: error,
            data: {},
        })
    }
}
