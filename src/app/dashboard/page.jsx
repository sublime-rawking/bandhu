import React from "react";
import Navbar from "@/app/dashboard/Navbar";
import UserTable from "./userTable";
import { userData } from "@/services/UserDataServices";
import AddDetails from "./addUser";

/**
 * Dashboard Component
 * Asynchronously fetches user data and renders the dashboard including the Navbar,
 * UserTable, and AddDetails components.
 *
 * @param {Object} params - The parameters passed to the dashboard component, expected
 * to contain searchParams for conditional rendering.
 */
export default async function Dashboard(params) {
  // Fetch user data asynchronously
  const users = await userData();

  // Determine if AddDetails component should be open based on URL search parameters
  const isOpen = params.searchParams["user"];

  // Render the Dashboard with Navbar, UserTable (passing in users), and AddDetails components
  return (
    <div>
      <Navbar />
      <UserTable users={users} />
      <AddDetails isOpen={isOpen} />
    </div>
  );
}
