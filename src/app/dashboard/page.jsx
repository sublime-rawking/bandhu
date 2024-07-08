import React from "react";
import Navbar from "@/app/dashboard/Navbar";
import UserTable from "./userTable";
import { userData } from "@/services/UserDataServices";
import AddDetails from "./addUser";

export default async function Dashboard(params) {
  const users = await userData();
  const isOpen = params.searchParams["user"];
  return (
    <div>
      <Navbar />
      <UserTable users={users} />
      <AddDetails isOpen={isOpen} />
    </div>
  );
}
