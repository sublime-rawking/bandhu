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
        const token = await VerifyToken();
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        const user = await prisma.members.findFirst({
            where: {
                id: token.data.id,
            },

        });

        if (!user) {
            return Response.json({ success: false, message: "User not found", data: {} });
        }

        const give_ask = await prisma.give_ask.findMany({
            where: {
                member_id: user.id
            }
        });

        user.give_ask = give_ask

        return Response.json({
            success: true,
            message: "Get user details successful",
            data: {
                name: user.name,
                email: user.email,
                mobile: user.mobile,
                profile_image: user.profile_image,
                id: user.id,
                dcp: user.dcp,
                give_ask: user.give_ask
            }
        });
    } catch (error) {
        console.error(error);

        return Response.json({ success: false, message: error.message, data: {}, error });
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
        const token = await VerifyToken();
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }

        const formData = await request.formData();

        const ValidatorRules = {
            name: "required",
            email: "required",
            mobile: "required",
        };

        const { error, status } = await new Promise((resolve) => {
            validator({ ...Object.fromEntries(formData) }, ValidatorRules, {}, (error, status) => {
                resolve({ error, status });
            });
        });


        if (!status) {
            return Response.json({
                success: false,
                message: "",
                data: {},
                error
            }, { status: 400 });
        }


        const userWithSameMobile = await prisma.members.findFirst({
            where: {
                mobile: formData.get("mobile"),
                id: {
                    not: token.data.id

                },
                status: {
                    not: 2
                }
            }
        });

        if (userWithSameMobile) {
            return Response.json({
                success: false,
                message: "A user with this mobile number already exists",
                data: {},
            }, { status: 400 });
        }


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

        if (!updatedMember) {
            return Response.json({ success: false, message: "User not found", data: {} }, { status: 404 });
        }

        if (formData.get("profile_image")) {
            const profile_image = formData.get("profile_image");
            updatedMember.profile_image = profile_image;
            await prisma.members.update({ where: { id: token.data.id }, data: { profile_image: profile_image } });

        }
        return Response.json({
            success: true,
            message: "User data updated successfully",
            data: updatedMember,
        }, { status: 200 });
    } catch (error) {
        console.error(error);

        return Response.json({ success: false, message: error.message, data: {}, error }, { status: 500 });
    }
}
