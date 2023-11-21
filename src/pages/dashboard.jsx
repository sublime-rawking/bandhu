import React, { useEffect, useState } from "react";
import UserTable from "../components/userTable";
import Navbar from "../components/navbar";
import { withProtected } from "../context/protectedroutes";
import { Spinner } from "@material-tailwind/react";
import { GetUsers } from "../api/usersApi";
const Dashboard = () => {
  const [usersData, setUsersData] = useState([]); // Replace "User" with actual username
  const [loader, setLoader] = useState(true);

  async function getUsers() {
    const data = await GetUsers();
    setUsersData(data);
    setLoader(false);
  }
  useEffect(() => {
    getUsers();
  }, []);

  return (
    <div>
      <Navbar  />
      <br />
      {loader ? (
        <Spinner className="h-12 w-12 mx-auto text-primary " color="amber" />
      ) : (
        <UserTable data={usersData} />
      )}
     
    </div>
  );
};


export default withProtected(Dashboard);
