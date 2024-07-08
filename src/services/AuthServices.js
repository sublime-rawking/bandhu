

export const LoginService = async ({ email, password }) => {
    const res = await fetch(`/api/admin/auth?username=${email}&password=${password}`, {
        method: "GET",
    });
    const data = await res.json();
    console.log(res, data);
    if (res.status === 200) {
        sessionStorage.setItem("user", data.data.token);
    }

    return { status: res.status, message: data.message }
};'bh'  