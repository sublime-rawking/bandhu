import "./index.css";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import Login from "./pages/login";
import Dashboard from "./pages/dashboard";
import { AuthUserProvider } from "./context/userContext";

function App() {
  return (
    <Router>
      <AuthUserProvider>
        <div className="">
          <div className="p-10">
            <Routes>
              <Route exact path="/" Component={Login} />
              <Route path="/dashboard" Component={Dashboard} />
            </Routes>
          </div>
        </div>
      </AuthUserProvider>
    </Router>
  );
}

export default App;
