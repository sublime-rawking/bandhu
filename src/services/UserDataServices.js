import prisma from "@/config/dbConfig"
/**
 * Fetches user data from the database.
 * 
 * This function asynchronously retrieves a list of users from the database with specific fields selected.
 * It also calculates the count of give_asks for each user and adds it as a new property to each user object.
 * If no users are found, it returns a JSON response indicating failure.
 * 
 * @returns {Promise<Array|Object>} An array of user objects with additional give_ask_count property,
 *                                  or a JSON object indicating failure if no users are found.
 */
export const dataService = async () => {
    // Retrieve users with selected fields from the database
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

    // Calculate and add give_ask_count for each user
    users.map(user => user.give_ask_count = user.give_asks.length);

    // Check if no users were found and return a failure response
    if (!users) {
        return Response.json({ success: false, message: "User not found", data: {} });
    }

    // Return the list of users
    return users;
}


