

export async function POST({ request }) {
    const body = await request.json();
    const { email, password } = body;
}