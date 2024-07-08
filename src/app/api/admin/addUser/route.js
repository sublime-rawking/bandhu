import prisma from "@/config/dbConfig";
import validator from "@/helper/validate";
import { Promise } from "es6-promise";

export async function POST(request) {

    try {

        const formData = await request.formData();

        const { error, status } = await new Promise((resolve) => {
            validator({ ...Object.fromEntries(formData) }, {
                name: "required",
                mobile: "required",
                email: "required",
                password: "required",
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


        const user = await prisma.members.create({
            data: {
                mobile: formData.get("mobile"),
                name: formData.get("name"),
                email: formData.get("email"),
                password: formData.get("password"),
                add_by: "admin",

            }
        });





        return Response.json({
            success: true, message: "Successfully added user", data: {
                user
            }
        });

    } catch (error) {
        console.error(error);
        return Response.json({
            success: false,
            message: error.message,
            data: {},
            error
        }, { status: 500 })


    }
} 