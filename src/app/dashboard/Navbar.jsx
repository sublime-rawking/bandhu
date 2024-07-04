import Link from "next/link";
import React from "react";

function Navbar() {
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
              <a>Add User</a>
            </li>
            <li>
              <Link href="/">Logout</Link>
            </li>
          </ul>
        </div>
      </div>
    </div>
  );
}

export default Navbar;
