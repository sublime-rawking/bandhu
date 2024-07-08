import prisma from "@/config/dbConfig";
import { VerifyToken } from "@/config/jwtConfig";
import { Buffer } from "buffer";
import { writeFileSync } from 'fs';
import { extname } from "path";

/**
 * Handles a POST request to upload a DCP file.
 *
 * @param {Request} request - The request object containing the DCP file.
 * @return {Promise<Response>} A JSON response indicating the success or failure of the upload.
 */

export async function POST(request) {

    try {
        const token = await VerifyToken();
        if (!token.success) {
            return Response.json(token, { status: 401 });
        }
        const formData = await request.formData();

        const file = formData.get("dcp");
        const buffer = Buffer.from(await file.arrayBuffer());
        const extension = extname(file.name);
        if (extension !== ".pdf") {
            return Response.json({
                success: false,
                message: "Only PDF files are allowed",
                data: {},
            }, { status: 400 });
        }
        const fileName = token.data.id + extension
        writeFileSync(`public/dcp/${fileName}`, buffer);
        const user = await prisma.members.update({
            where: {
                id: token.data.id
            },
            data: {
                dcp: fileName

            },
            select: {
                id: true,
                name: true,
                email: true,
                mobile: true,
                profile_image: true,
                dcp: true
            }
        });


        return Response.json({ success: true, message: "File uploaded successfully", data: { ...user } });
    } catch (error) {
        console.error(error);

        return Response.json({ success: false, message: error.message, data: {}, error });
    }

}

