
export async function login({ userName, password }) {
    try {
        if (userName === 'admin' && password === 'admin') {
            localStorage.setItem("user", "login");
            return true;
        }
        return false;
    } catch (error) {
        console.log(error);
        return false;
    }

}