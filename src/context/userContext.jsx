import { createContext, useContext, useEffect } from "react";
import { useState } from "react";
import { login } from '../api/login';
import { useNavigate } from "react-router-dom";

const authUserContext = createContext();
export function AuthUserProvider(props) {
    const [user, setUser] = useState(null);

    const navigate = useNavigate();
    // const [error, setError] = useState(null);

    useEffect(() => {
        // Check if the user is already authenticated
        const storedUser = localStorage.getItem("user");

        if (storedUser) {
            setUser(JSON.parse(storedUser));
        }
    }, []);



    const loginWithEmail = async ({ userName, password }) => {

        const user = await login({ userName, password, });
        setUser(user ?? null);
        console.log(user);
        // setError(error ?? "");

        localStorage.setItem("user", JSON.stringify(user));
        navigate(user == null ? "/" : "/dashboard");
        return user ? true : false;
    };
    const logOut = async () => {

        setUser(null);
        navigate("/");
        localStorage.clear();
    };

    const value = { user, loginWithEmail, logOut, setUser };
    return <authUserContext.Provider value={value} {...props} />;
};

const useAuth = () => useContext(authUserContext);
export default useAuth;