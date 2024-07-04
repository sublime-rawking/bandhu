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
        const token = await VerifyToken();
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        const user = await prisma.members.findMany({
            select: {
                id: true,
                name: true,
                email: true,
                mobile: true,
                profile_image: true,
                dcp: true,
            }
        });

        if (!user) {
            return Response.json({ success: false, message: "User not found", data: {} });
        }



        return Response.json({
            success: true,
            message: "Get user details successful",
            data: user
        });
    } catch (error) {
        console.error(error);

        return Response.json({ success: false, message: error.message, data: {}, error });
    }
}
