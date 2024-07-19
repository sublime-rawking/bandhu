import prisma from "@/config/dbConfig";
import validator from "@/helper/validate";
import { Promise } from "es6-promise";

/**
 * Handles the POST request to create a new user.
 * @param {Request} request - The request object containing the user data.
 * @return {Promise<Response>} A promise that resolves to the response object.
 */
export async function POST(request) {

    try {

        // Extract the form data from the request
        const formData = await request.formData();

        // Validate the form data
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

        // If the form data is invalid, return an error response
        if (!status) {
            return Response.json({
                success: false,
                message: "validation error",
                data: {},
                error
            }, { status: 400 });
        }

        // Create a new user in the database
        const user = await prisma.members.create({
            data: {
                mobile: formData.get("mobile"),
                name: formData.get("name"),
                email: formData.get("email"),
                password: formData.get("password"),
                add_by: "admin",

            }
        });

        // Return a success response with the created user data
        return Response.json({
            success: true, message: "Successfully added user", data: {
                user
            }
        });

    } catch (error) {
        // If there is an error, log it and return an error response
        console.error(error);
        return Response.json({
            success: false,
            message: error.message,
            data: {},
            error
        }, { status: 500 })
    }
}
