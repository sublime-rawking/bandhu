import prisma from "@/config/dbConfig"
export const userData = async () => {
    let users = await prisma.members.findMany({
        select: {
            id: true,
            name: true,
            email: true,
            mobile: true,
            profile_image: true,
            dcp: true,
            give_asks: true,
            status: true
        }
    });
    users.map(user => user.give_ask_count = user.give_asks.length);
    if (!users) {
        return Response.json({ success: false, message: "User not found", data: {} });
    }
    return users
}


