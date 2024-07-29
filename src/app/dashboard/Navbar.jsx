"use client";
import Cookies from "js-cookie";
import React from "react";

function Navbar() {
  /**
   * Removes the userId, token, and data from the Cookies
   *
   * @function
   * @name handleLogout
   * @returns {void}
   */
  const handleLogout = () => {
    // Removing the userId from the Cookies
    Cookies.remove("userId");

    // Removing the token from the Cookies
    Cookies.remove("token");

    // Removing the data from the Cookies
    Cookies.remove("data");

    // Redirecting the user to the login page
    window.location.href = "/";
  };

  /**
   * Redirects the user to the login page
   *
   * @function
   * @name handleLogin
   * @returns {void}
   */
  const handleAddUser = () => {
    window.location.href = "/dashboard?user=true";
  };

  return (
    <div className="navbar bg-base-100">
      <div className="flex-1">
        <h1 className="font-semibold text-3xl bg-gradient-to-r from-[#c45050] to-primary bg-clip-text text-transparent">
          RefferGenix
        </h1>
      </div>
      <div className="flex-none">
        <div className="navbar bg-base-100">
          <ul className="menu menu-horizontal px-1">
            <li>
              <div onClick={handleAddUser} >Add User</div>
            </li>
            <li>
              <div onClick={handleLogout}>Logout</div>
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default Navbar;
