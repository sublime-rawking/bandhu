// import { StoreImage } from "@/helper/store-image";
import prisma from "@/config/dbConfig";
import validator from "@/helper/validate";
import { Promise } from 'es6-promise';
import { GenerateToken } from "@/config/jwtConfig";
import { decrypt, encrypt } from "@/helper/security";
import { StoreImage } from "@/helper/store-image";

/**
 * Handles the GET request to authenticate a user.
 *
 * @param {Request} request - The request object containing user credentials.
 * @return {Response} JSON response with authentication status and user data.
 */

export async function GET(request) {

    try {
        const { searchParams } = new URL(request.url);


        const { error, status } = await new Promise((resolve) => {
            validator({ ...Object.fromEntries(searchParams) }, {
                mobileNo: "required",
                password: "required",
            }, {}, (error, status) => {
                resolve({ error, status });
            });
        });


        if (!status) {
            return Response.json({
                success: false,
                message: "validation error",
                data: { ...error.errors },
            });
        }




        const mobileNo = searchParams.get("mobileNo");
        const password = searchParams.get("password");

        const user = await prisma.members.findFirst({
            where: {
                mobile: mobileNo,
                status: {
                    not: 2
                }
            }
        });

        if (!user) {
            return Response.json({
                success: false,
                message: "User not found",
            }, { status: 404 });
        }
        if (user.status != 1) {
            return Response.json({
                success: false,
                message: "User is not active",
            }, { status: 401 });
        }

        const decryptedPassword = decrypt(user.password);


        if (password !== decryptedPassword) {
            return Response.json({
                success: false,
                message: "Invalid Credentials",
            }, { status: 401 });
        }


        const giveAskCount = await prisma.give_ask.count({
            where: {
                member_id: user.id
            }
        });

        user.giveAskCount = giveAskCount;

        const token = GenerateToken({ id: user.id, email: user.email, name: user.name });
        return Response.json({
            success: true,
            message: "Login successful",
            data: {
                ...user,
                token
            },
        }, {
            status: 200
        });



    } catch (error) {
        console.error(error);
        return Response.json({
            success: false,
            message: error.message,
            data: {
            },
            error
        }, {
            status: 500
        });
    }
}



/**
 * Handles the POST request for user registration.
 *
 * @param {Request} request - The request object containing the form data.
 * @return {Promise<Response>} - A promise that resolves to a response object containing the result of the registration.
 */

export async function POST(request) {

    try {


        const formData = await request.formData();



        const ValidatorRules = {
            name: "required",
            email: "required",
            mobile: "required",
            password: "required",
        };

        const { error, status } = await new Promise((resolve) => {
            validator({ ...Object.fromEntries(formData) }, ValidatorRules, {}, (error, status) => {
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


        const userWithSameMobile = await prisma.members.findFirst({
            where: {
                mobile: formData.get("mobile"),
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
            });
        }


        const encryptedPassword = encrypt(formData.get("password"));
        let user = await prisma.members.create({
            data: {
                name: formData.get("name"),
                email: formData.get("email"),
                mobile: formData.get("mobile"),
                password: encryptedPassword,

            },

            select: {
                id: true,
                name: true,
                email: true,
                mobile: true,
                profile_image: true
            }

        });

        console.log(formData);
        let photo = formData.get("profile_image");
        if (photo) {
            photo = await StoreImage({
                id: user.id,
                path: "reffergenix/users",
                image: photo
            });
        } else {
            photo = "";
        }


        user = await prisma.members.update({
            where: {
                id: user.id
            },
            data: {
                profile_image: photo
            },
            select: {
                id: true,
                name: true,
                email: true,
                mobile: true,
                profile_image: true,
                dcp: true,

            },

        });

        const token = GenerateToken({ id: user.id, email: user.email, name: user.name });


        return Response.json({
            success: true, message: "success", data: {
                ...user, give_ask: 0, token
            }
        }, {
            status: 200,
        });
    } catch (error) {
        console.error(error);
        return Response.json({ success: false, message: error.message, data: {}, error }, { status: 500 });
    }
}




