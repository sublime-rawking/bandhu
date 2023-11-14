import React, { useEffect, useState } from "react";
import UserTable from "../components/userTable";
import Navbar from "../components/navbar";
import { users } from "../data/users";
import { withProtected } from "../context/protectedroutes";

import { GetUsers } from "../api/usersApi";
const Dashboard = () => {
  const [username, setUsername] = useState("User"); // Replace "User" with actual username

  async function getUsers() {
    const data = await GetUsers();
    console.log(data);
  }

  // useEffect(() => {
  //   getUsers();
  // }, []);

  const handleLogout = () => {
    console.log("User logged out");
    // Add your logout logic here
  };

  return (
    <div>
      <Navbar />
      <br />
      <UserTable data={users} />
    </div>
  );
};

export default withProtected(Dashboard);
