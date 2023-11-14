import axios from 'axios';

export const baseUrl = 'http://192.168.29.129/BNI_25oct18/BNI_25oct18';

export async function GetUsers() {
    try {
        var res = await axios.get(`${baseUrl}/Api/getMembers`);
        var resBody = res.data;
        console.log(resBody);
        return [];
    } catch (error) {
        console.log(error);
        return []
    }
}