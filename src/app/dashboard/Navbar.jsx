"use client";
import Cookies from "js-cookie";
import Link from "next/link";
import React from "react";

function Navbar() {
  const handleLogout = () => {
    "use client";
    Cookies.remove("userId");
    Cookies.remove("token");
    Cookies.remove("data");
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
              <Link href="/dashboard?user=true">Add User</Link>
            </li>
            <li>
              <Link href="/" onClick={handleLogout}>
                Logout
              </Link>
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default Navbar;
