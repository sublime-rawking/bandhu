import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import moment from "moment/moment";


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
                        gte: moment.utc(searchParams.get("date") , "YYYY-MM").startOf('month').toDate(),
                        lte: moment.utc(searchParams.get("date") , "YYYY-MM").endOf('month').toDate(),
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


        const groupedData = giveAndAsk.reduce((acc, item) => {
            const date = item.date.toISOString().split('T')[0];
            if (!acc[date]) {
                acc[date] = { length: 0 };
            }
            acc[date].length++;
            acc[date].date = moment.utc(item.date);
            return acc;
        }, {});

        const groupedDataArray = Object.values(groupedData);
        return Response.json({
            success: true,
            message: "give and ask successfully",
            data: groupedDataArray,
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