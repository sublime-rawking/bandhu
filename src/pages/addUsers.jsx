import React, { useEffect, useRef, useState } from "react";
import { XMarkIcon } from "@heroicons/react/24/solid";
import { EyeIcon, EyeSlashIcon } from "@heroicons/react/24/solid";

import PropTypes from "prop-types";
import { addUser } from "../api/usersApi";

AddUsers.propTypes = {
  handleModel: PropTypes.func.isRequired,
};

export default function AddUsers({ handleModel }) {
  const [user, setUser] = useState({
    name: "",
    email: "",
    password: "",
    mobile: "",
    profile: "",
  });
  const [error, setError] = useState({
    email: "",
    mobile: "",
  });
  const [profileSrc, setProfileSrc] = useState(null);
  const fileInputRef = useRef();

  const handleFileChange = (e) => {
    const file = e.target.files[0];
    setUser((prev) => ({ ...prev, profile: file }));

    // Create an object URL to preview the image
    setProfileSrc(URL.createObjectURL(file));
  };
  const [showPassword, setShowPassword] = useState(false);

  const handleSubmit = async (e) => {
    e.preventDefault();
    var res = await addUser({ ...user });
    if (!res) return;
    setUser({
      name: "",
      email: "",
      password: "",
      mobile: "",
    });
    setError({
      email: "",
      mobile: "",
    });
    setProfileSrc(null);
  };

  const openFilePicker = () => {
    fileInputRef.current.click();
  };

  useEffect(() => {
    if (user.email.length == 0) {
      setError((prev) => ({
        ...prev,
        email: "",
      }));
      return;
    }
  }, [user.email]);
  const handleEmailChange = (e) => {
    setUser((prev) => ({ ...prev, email: e.target.value }));
    const emailPattern = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    if (!emailPattern.test(e.target.value)) {
      setError((prev) => ({
        ...prev,
        email: "Please enter a valid email address.",
      }));
    } else {
      setError((prev) => ({
        ...prev,
        email: "",
      }));
    }
  };

  return (
    <div className="p-6 max-w-sm mx-auto bg-gray-900 rounded-xl shadow-md flex items-center my-5 ">
      <form onSubmit={handleSubmit} className="w-full">
        <div
          className="flex flex-row my-3 justify-between"
          onClick={handleModel}
        >
          <label
            className="block text-white text-sm font-bold"
            htmlFor="profile"
          >
            Profile
          </label>
          <XMarkIcon className="h-6 w-6 text-white cursor-pointer" />
        </div>

        <div className=" my-3 ">
          <img
            onClick={openFilePicker}
            className="h-24 w-24  cursor-pointer rounded-full items-center text-center mx-auto object-fill object-center shadow-lg border-2 border-primary"
            src={
              profileSrc
                ? profileSrc
                : "https://img.freepik.com/free-vector/illustration-businessman_53876-5856.jpg"
            }
            alt="nature image"
          />
          <input
            className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
            id="profile"
            ref={fileInputRef}
            style={{ display: "none" }}
            type="file"
            accept="image/*"
            onChange={handleFileChange}
          />
        </div>
        <div className=" grid grid-cols-1 md:grid-cols-2 gap-4">
          <div className="mb-4">
            <label
              className="block text-white text-sm font-bold mb-2"
              htmlFor="name"
            >
              Name
            </label>
            <input
              className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              id="name"
              type="text"
              value={user.name}
              onChange={(e) =>
                setUser((prev) => ({ ...prev, name: e.target.value }))
              }
              required
            />
          </div>
          <div className="mb-4">
            <label
              className="block text-white text-sm font-bold mb-2"
              htmlFor="email"
            >
              Email
            </label>
            <input
              className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              id="email"
              type="email"
              required
              value={user.email}
              onChange={(e) => handleEmailChange(e)}
            />
            {error.email && (
              <p className="text-red-500 text-xs italic">{error.email}</p>
            )}
          </div>
          <div className="mb-4">
            <label
              className="block text-white text-sm font-bold mb-2"
              htmlFor="password"
            >
              Password
            </label>

            <div className="relative h-auto mb-3">
              <input
                className="shadow appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
                id="password"
                type={showPassword ? "text" : "password"}
                value={user.password}
                required
                onChange={(e) =>
                  setUser((prev) => ({ ...prev, password: e.target.value }))
                }
              />
              <button
                type="button"
                className="absolute w-9 text-center right-0 pr-3 my-2 items-center"
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
          </div>

          <div className="mb-4">
            <label
              className="block text-white text-sm font-bold mb-2"
              htmlFor="mobile"
            >
              Mobile
            </label>
            <input
              className="shadowe  appearance-none border rounded w-full py-2 px-3 text-gray-700 leading-tight focus:outline-none focus:shadow-outline"
              id="mobile"
              type="tel"
              required
              pattern="[0-9]{10}"
              maxLength="10"
              value={user.mobile}
              onChange={(e) =>
                setUser((prev) => ({ ...prev, mobile: e.target.value }))
              }
            />
          </div>
        </div>
        <input
          className="bg-dark-primary hover:bg-primary w-full my-2 text-white font-bold py-2 px-4 rounded focus:outline-none focus:shadow-outline"
          type="submit"
          value="Submit"
        />
      </form>
    </div>
  );
}
