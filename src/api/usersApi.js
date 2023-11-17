import axios from 'axios';
import { toast } from 'react-toastify';

export const baseUrl = 'http://192.168.29.129/BNI_25oct18/BNI_25oct18';

export async function GetUsers() {
    try {
        var res = await axios.get(`${baseUrl}/Api/getMembers`);
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

export async function StatusUsers({ userId, status }) {
    try {
        const formData = new FormData();
        formData.append('id', userId);
        formData.append('status', status);
        var res = await axios.post(`${baseUrl}/Api/userstatus`, formData);
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