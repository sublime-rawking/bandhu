import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import { Buffer } from "buffer";
import { writeFileSync } from 'fs';
import { extname } from "path";


/**
 * Handles the POST request to upload a DCP file.
 *
 * This function is responsible for validating and processing the upload of a DCP file.
 * It verifies the user's token, checks the file type, saves the file to the server,
 * and updates the user's record with the file's details.
 *
 * @param {Request} request - The incoming request object.
 * @return {Promise<Response>} A promise that resolves with the JSON response indicating the outcome of the operation.
 */
export async function POST(request) {
    try {
        // Verify the user's token
        const token = await VerifyToken();
        if (!token.success) {
            // If token verification fails, return a 401 Unauthorized response
            return Response.json(token, { status: 401 });
        }

        // Extract the file from the request
        const formData = await request.formData();
        const file = formData.get("dcp");

        // Ensure the file is a PDF
        const buffer = Buffer.from(await file.arrayBuffer());
        const extension = extname(file.name);
        if (extension !== ".pdf") {
            // Respond with an error if the file is not a PDF
            return Response.json({
                success: false,
                message: "Only PDF files are allowed",
                data: {},
            }, { status: 400 });
        }

        // Save the PDF file to the server
        const fileName = token.data.id + extension;
        writeFileSync(`public/dcp/${fileName}`, buffer);

        // Update the user's record with the new file details
        const user = await prisma.members.update({
            where: {
                id: token.data.id,
            },
            data: {
                dcp: fileName,
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

        // Respond with success and the updated user details
        return Response.json({ success: true, message: "File uploaded successfully", data: { ...user } });
    } catch (error) {
        // Log and respond with error details in case of an exception
        console.error(error);
        return Response.json({ success: false, message: error.message, data: {}, error });
    }
}

