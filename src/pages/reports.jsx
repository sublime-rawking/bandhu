import React, { useEffect, useState } from "react";
import Navbar from "../components/navbar";
import { users } from "../data/users";
import { withProtected } from "../context/protectedroutes";
import { Spinner } from "@material-tailwind/react";
import ReportTable from "../components/reportTable";
// import { GetUsers } from "../api/usersApi";
const Reports = () => {
//   const [usersData, setUsersData] = useState([]); // Replace "User" with actual username
  const [loader, setLoader] = useState(true);
  async function getUsers() {
    // const data = await GetUsers();
    // setUsersData(data);
    setLoader(false);
  }
  useEffect(() => {
    getUsers();
  }, []);

  return (
    <div>
      <Navbar />
      <br />
      {loader ? (
        <Spinner className="h-12 w-12 mx-auto text-primary " color="amber" />
      ) : (
        <ReportTable data={users} />
      )}
    </div>
  );
};

export default withProtected(Reports);
