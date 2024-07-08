import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import validator from "@/helper/validate";
import { userData } from "@/services/UserDataServices";
import { Promise } from "es6-promise";

/**
 * Retrieves user details from the database based on the provided token.
 *@param {String} _token - The token to be verified.
 * @return {Promise<Object>} A JSON object containing the user details, including name, email, mobile, profile_image, id, dcp, and give_ask.
 *                           If the token is invalid or the user is not found, a JSON object with success set to false and an error message is returned.
 * @throws {Error} If an error occurs during the retrieval process, an error object with success set to false and an error message is returned.
 */
export async function GET(_token) {
    try {
        const token = await VerifyToken();

        if (!token.success && !_token) {

            return Response.json(token, { status: 401 });
        }

        const users = await userData();

        return Response.json({
            success: true,
            message: "Get user details successful",
            data: users
        });
    } catch (error) {
        console.error(error);

        return Response.json({ success: false, message: error.message, data: {}, error });
    }
}


/**
 * Disable a user by updating their status to 0.
 *
 * @param {Request} request - The request object containing the user id.
 * @return {Promise<Object>} A JSON object indicating the success or failure of the operation.
 */
export async function PUT(request) {
    try {
        const token = await VerifyToken();

        if (!token.success) {
            return Response.json(token, { status: 401 });
        }
        const { id, isDisable } = await request.json();


        const ValidatorRules = {
            id: "required",
            isDisable: "required",
        };

        
        const { error, status } = await new Promise((resolve) => {
            validator({ id, isDisable }, ValidatorRules, {}, (error, status) => {
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
        await prisma.members.update({
            where: {
                id
            },
            data: {
                status: isDisable
            }
        })


        return Response.json({ success: true, message: "User disabled successfully" });
    } catch (error) {

        console.error("error");
        console.error(error);
        return Response.json({ success: false, message: error.message, data: {}, error });
    }
}
