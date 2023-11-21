import "./index.css";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Login from "./pages/login";
import React from "react";
import Dashboard from "./pages/dashboard";
import { AuthUserProvider } from "./context/userContext";
import Reports from "./pages/reports";

import { ToastContainer } from "react-toastify";
import "react-toastify/dist/ReactToastify.css";
import AddUsers from "./pages/addUsers";

function App() {
  return (
    <Router>
      <AuthUserProvider>
        <div className="p-10">
          <Routes>
            <Route exact path="/" Component={Login} />
            <Route path="/adduser" Component={AddUsers} />
            <Route path="/dashboard" Component={Dashboard} />
            <Route path="/reports" Component={Reports} />
          </Routes>
          <ToastContainer />
        </div>
      </AuthUserProvider>
    </Router>
  );
}

export default App;
