import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";

/**
 * Retrieves user details from the database based on the provided token.
 *
 * @return {Promise<Object>} A JSON object containing the user details, including name, email, mobile, profile_image, id, dcp, and give_ask.
 *                           If the token is invalid or the user is not found, a JSON object with success set to false and an error message is returned.
 * @throws {Error} If an error occurs during the retrieval process, an error object with success set to false and an error message is returned.
 */
export async function GET() {
    try {
        // Verify the token
        const token = await VerifyToken();

        // If the token is invalid, return unauthorized response
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        // Retrieve user details from the database
        const user = await prisma.members.findMany({
            select: {
                id: true, // User ID
                name: true, // User name
                email: true, // User email
                mobile: true, // User mobile number
                profile_image: true, // User profile image
                dcp: true, // User DCP status
            }
        });

        // If the user is not found, return not found response
        if (!user) {
            return Response.json({
                success: false,
                message: "User not found",
                data: {}
            });
        }

        // Return the user details with success status and message
        return Response.json({
            success: true,
            message: "Get user details successful",
            data: user
        });
    } catch (error) {
        // Log the error and return error response
        console.error(error);
        return Response.json({
            success: false,
            message: error.message,
            data: {},
            error
        });
    }
}
