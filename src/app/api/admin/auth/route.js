import prisma from "@/config/dbConfig";
import { GenerateToken } from "@/config/jwtConfig";
import { decrypt, encrypt } from "@/helper/security";
import validator from "@/helper/validate";
import { Promise } from "es6-promise";
import moment from "moment/moment";


/**
 * Handles the POST request to create a new user in the system.
 *
 * @param {Request} request - The request object containing the user data.
 * @return {Promise<Response>} A promise that resolves to the response object.
 * The response object contains the success status, a message, and the created user data.
 * If there is an error, the response object contains the error message.
 */
export async function POST(request) {
    try {
        // Extract the user data from the request body
        const bodyData = await request.json();

        // Validate the user data
        const { error, status } = await new Promise((resolve) => {
            validator(bodyData, {
                username: "required",
                email: "required",
                password: "required",
            }, {}, (error, status) => {
                resolve({ error, status });
            });
        });

        // If the user data is invalid, return an error response
        if (!status) {
            return Response.json({
                success: false,
                message: "validation error",
                data: {},
                error
            }, { status: 400 });
        }

        // Encrypt the user password
        const encryptedPassword = encrypt(bodyData.password);

        // Create a new user in the database
        const user = await prisma.users.create({
            data: {
                username: bodyData.username,
                password: encryptedPassword,
                email: bodyData.email,
                last_login: moment.utc().toDate(),
                status: 1
            },
            select: {
                id: true,
                username: true,
                email: true,
                last_login: true
            }
        });

        // Generate a JWT token for the user
        const token = GenerateToken({ id: user.id });
        user.token = token;

        // Return a success response with the created user data
        return Response.json({
            success: true,
            message: "User created successfully",
            data: user
        }, { status: 200 });
    } catch (error) {
        // Log any errors that occur during the request
        console.error(error);
    }
}


/**
 * Handles the GET request to authenticate a user.
 *
 * @param {Request} request - The request object containing user credentials.
 * @return {Response} JSON response with authentication status and user data.
 */
export async function GET(request) {
    try {

        const searchParams = new URL(request.url).searchParams;


        const { error, status } = await new Promise((resolve) => {
            validator({ ...Object.fromEntries(searchParams) }, {
                username: "required",
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

        const user = await prisma.users.findFirst({
            where: {
                username: searchParams.get("username"),
                status: 1
            },
        });


        if (!user) {
            return Response.json({
                success: false,
                message: "User not found",
                data: {}
            }, { status: 404 });
        }


        if (decrypt(user.password) !== searchParams.get("password")) {
            return Response.json({
                success: false,
                message: "Invalid credentials",
                data: {}
            }, { status: 401 });
        }

        const token = GenerateToken({ id: user.id });
        user.token = token;
        delete user.password;
        return Response.json({
            success: true,
            message: "User logged in successfully",
            data: user
        }, { status: 200 });
    } catch (error) {
        console.error(error);

        return Response.json({ success: false, message: error.message, data: {}, error }, { status: 500 });
    }
}
