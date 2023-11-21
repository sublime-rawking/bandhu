import axios from 'axios';
import { toast } from 'react-toastify';

// export const import.meta.env.BASE_URL = 'http://192.168.29.129/BNI_25oct18/BNI_25oct18';

export async function GetUsers() {
    try {
        var res = await axios.get(`${import.meta.env.VITE_BASEURL}/Api/getMembers`);
        var resBody = res.data;
        if (resBody["success"]) {

            return resBody["members"];
        }
        return []
    } catch (error) {
        console.error(error);
        return []
    }
}

export async function addUser({ name, email, password, mobile, profile }) {
    try {
        const formData = new FormData();
        formData.append('Name', name);
        formData.append('email', email);
        formData.append('password', password);
        formData.append('Mobile', mobile);
        formData.append('Profile', profile);
        var res = await axios.post(`${import.meta.env.VITE_BASEURL}/Api/signup`, formData);
        var resBody = res.data;
        console.log(resBody);
        if (resBody["success"]) {
            toast("User added successfully", {
                position: toast.POSITION.BOTTOM_RIGHT,
                closeOnClick: true,
                draggable: true,
            });
            return true;
        } else {
            toast.error(resBody["message"], {
                position: toast.POSITION.BOTTOM_RIGHT,
                closeOnClick: true,
                draggable: true,
            });
        }
        return false;
    } catch (error) {
        console.error(error);
        toast("Something went wrong", {
            position: toast.POSITION.BOTTOM_RIGHT,
            closeOnClick: true,
            draggable: true,
        });
        return false;
    }
}

export async function StatusUsers({ userId, status }) {
    try {
        const formData = new FormData();
        formData.append('id', userId);
        formData.append('status', status);
        var res = await axios.post(`${import.meta.env.VITE_BASEURL}/Api/userstatus`, formData);
        var resBody = res.data;
        if (resBody["res"] == "2") {
            toast("User disabled successfully", {
                position: toast.POSITION.BOTTOM_RIGHT,
                closeOnClick: true,
                draggable: true,


            });
        } else {

            toast("User enabled successfully", {
                position: toast.POSITION.BOTTOM_RIGHT,
                closeOnClick: true,
                draggable: true,

            });
        }

        return resBody["success"]
    } catch (error) {
        console.error(error);
        return false
    }
}