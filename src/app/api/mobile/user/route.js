import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import validator from "@/helper/validate";
import { Promise } from "es6-promise";

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
        const user = await prisma.members.findFirst({
            where: {
                id: token.data.id, // User ID
            },

        });

        // If the user is not found, return not found response
        if (!user) {
            return Response.json({
                success: false,
                message: "User not found",
                data: {}
            });
        }

        // Count the number of give_ask records associated with the user
        const give_ask = await prisma.give_ask.count({
            where: {
                member_id: user.id // User ID
            }
        });

        // Return the user details with success status and message
        return Response.json({
            success: true,
            message: "Get user details successful",
            data: {
                name: user.name, // User name
                email: user.email, // User email
                mobile: user.mobile, // User mobile number
                profile_image: user.profile_image, // User profile image
                id: user.id, // User ID
                dcp: user.dcp, // User DCP status
                giveAskCount: give_ask // Number of give_ask records associated with the user
            }
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


/**
 * Updates user information based on the provided request data.
 *
 * @param {Request} request - The request object containing user data to update.
 * @return {Object} A JSON response object indicating the success or failure of the update operation.
 */
export async function PUT(request) {
    try {
        // Verify the token to ensure the request is authenticated
        const token = await VerifyToken();
        // If token verification fails, return an unauthorized response
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        // Parse the request form data
        const formData = await request.formData();

        // Define validation rules for the incoming data
        const ValidatorRules = {
            name: "required",
            email: "required",
            mobile: "required",
        };

        // Validate the request data against the defined rules
        const { error, status } = await new Promise((resolve) => {
            validator({ ...Object.fromEntries(formData) }, ValidatorRules, {}, (error, status) => {
                resolve({ error, status });
            });
        });

        // If validation fails, return a bad request response
        if (!status) {
            return Response.json({
                success: false,
                message: "Validation failed",
                data: {},
                error
            }, { status: 400 });
        }

        // Check if a user with the same mobile number already exists, excluding the current user
        const userWithSameMobile = await prisma.members.findFirst({
            where: {
                mobile: formData.get("mobile"),
                id: {
                    not: token.data.id
                },
                status: {
                    not: 2 // Assume status 2 means 'deleted' or 'inactive'
                }
            }
        });

        // If a user with the same mobile number exists, return a conflict response
        if (userWithSameMobile) {
            return Response.json({
                success: false,
                message: "A user with this mobile number already exists",
                data: {},
            }, { status: 400 });
        }

        // Update the member's information in the database
        const updatedMember = await prisma.members.update({
            where: {
                id: token.data.id,
            },
            data: {
                name: formData.get("name"),
                email: formData.get("email"),
                mobile: formData.get("mobile"),
            }
        });

        // If the member cannot be found, return a not found response
        if (!updatedMember) {
            return Response.json({ success: false, message: "User not found", data: {} }, { status: 404 });
        }

        // If a profile image is provided, update it separately
        if (formData.get("profile_image")) {
            const profile_image = formData.get("profile_image");
            updatedMember.profile_image = profile_image;
            // Update the profile image in the database
            await prisma.members.update({ where: { id: token.data.id }, data: { profile_image: profile_image } });
        }
        // Return a success response with the updated user data
        return Response.json({
            success: true,
            message: "User data updated successfully",
            data: updatedMember,
        }, { status: 200 });
    } catch (error) {
        // Log any errors to the console and return an internal server error response
        console.error(error);
        return Response.json({ success: false, message: error.message, data: {}, error }, { status: 500 });
    }
}
