import React, { useState } from "react";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/solid";
import useAuth from "../context/userContext";
import { withPublic } from "../context/protectedroutes";
const Login = () => {
  const { loginWithEmail } = useAuth();

  const [loginData, setLoginData] = useState({
    username: "",
    password: "",
  });
  const [showPassword, setShowPassword] = useState(false);
  // const history = useHistory();

  const handleSubmit = (event) => {
    event.preventDefault();
    console.log(loginData);
    loginWithEmail({
      userName: loginData.username,
      password: loginData.password,
    });
  };

  return (
    <div className="flex justify-center items-center h-screen bg-black">
      <div className="bg-gray-900 p-10 rounded shadow-xl max-w-md w-full m-5">
        <h1 className="text-xl font-bold mb-5 text-white">Login</h1>
        <form onSubmit={handleSubmit}>
          <label className="block text-sm mb-2 text-white" htmlFor="username">
            Username
          </label>
          <input
            className="w-full px-3 py-2 mb-3 border border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent bg-gray-700 text-white"
            id="username"
            type="text"
            onChange={(e) =>
              setLoginData({ ...loginData, username: e.target.value })
            }
            required
          />
          <label className="block text-sm mb-2 text-white" htmlFor="password">
            Password
          </label>
          <div className="relative h-auto mb-3">
            <input
              className="w-full px-3 py-2  border border-gray-600 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-600 focus:border-transparent bg-gray-700 text-white pr-10"
              id="password"
              type={showPassword ? "text" : "password"}
              onChange={(e) =>
                setLoginData({ ...loginData, password: e.target.value })
              }
              required
            />
            <button
              type="button"
              className="absolute w-10    text-center right-0 pr-3 my-2 items-center"
              onClick={() => setShowPassword(!showPassword)}
            >
              {showPassword ? (
                <EyeSlashIcon
                  className="items-center m-auto text-black"
                  strokeWidth={2}
                />
              ) : (
                <EyeIcon
                  className="items-center  m-auto text-black"
                  strokeWidth={2}
                />
              )}
            </button>
          </div>

          <button
            className="w-full mt-4 py-2 px-4 bg-primary hover:bg-dark-primary text-white font-semibold rounded-lg shadow-md focus:outline-none focus:ring-2 focus:ring-blue-600 focus:ring-opacity-50"
            type="submit"
          >
            Login
          </button>
        </form>
      </div>
    </div>
  );
};

export default withPublic(Login);
