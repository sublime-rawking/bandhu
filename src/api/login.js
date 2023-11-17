import axios from "axios";
import { baseUrl } from "./usersApi";
import { toast } from "react-toastify";

export async function login({ userName, password }) {
    try {

        var res = await axios.get(`${baseUrl}/Api/login?credential=${userName}&password=${password}`);
        const resBody = res.data;
        if (resBody["success"]) {
            localStorage.setItem("user", "login");
        } else {
            toast.error("Username or password is incorrect", {
                position: toast.POSITION.BOTTOM_RIGHT,
                closeOnClick: true,
                draggable: true,
            });
        }
        return resBody["success"];
    } catch (error) {
        console.error(error);
        return false;
    }

}