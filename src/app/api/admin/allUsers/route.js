import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import validator from "@/helper/validate";
import { userData } from "@/services/UserDataServices";
import { Promise } from "es6-promise";

/**
 * Retrieves user details from the database based on the provided token.
 *
 * @param {String} _token - The token to be verified.
 * @return {Promise<Object>} A JSON object containing the user details, including name, email, mobile, profile_image, id, dcp, and give_ask.
 *                           If the token is invalid or the user is not found, a JSON object with success set to false and an error message is returned.
 * @throws {Error} If an error occurs during the retrieval process, an error object with success set to false and an error message is returned.
 */
export async function GET(_token) {
    try {
        // Verify the token
        const token = await VerifyToken();

        // If token is invalid, return error response
        if (!token.success && !_token) {
            return Response.json(token, { status: 401 });
        }

        // Retrieve user data from the database
        const users = await userData();

        // Return the user data with success status and message
        return Response.json({
            success: true,
            message: "Get user details successful",
            data: users
        });
    } catch (error) {
        // Log the error and return error response
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
        // Verify the token
        const token = await VerifyToken();

        // If token is invalid, return error response
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        // Extract user id and status from request body
        const { id, isDisable } = await request.json();


        // Define validation rules
        const ValidatorRules = {
            id: "required",
            isDisable: "required",
        };

        // Validate user input
        const { error, status } = await new Promise((resolve) => {
            validator({ id, isDisable }, ValidatorRules, {}, (error, status) => {
                resolve({ error, status });
            });
        });

        // If validation fails, return error response
        if (!status) {
            return Response.json({
                success: false,
                message: "validation error",
                data: {},
                error
            }, { status: 400 });
        }

        // Update user status in database
        await prisma.members.update({
            where: {
                id
            },
            data: {
                status: isDisable
            }
        });

        // Return success response
        return Response.json({ success: true, message: "User disabled successfully" });
    } catch (error) {

        // Log and return error response
        console.error("error");
        console.error(error);
        return Response.json({ success: false, message: error.message, data: {}, error });
    }
}
