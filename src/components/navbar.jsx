import React, { useState } from "react";
import {
  Navbar,
  Collapse,
  Typography,
  IconButton,
} from "@material-tailwind/react";
import { Bars3Icon, XMarkIcon } from "@heroicons/react/24/outline";
import useAuth from "../context/userContext";
import PropTypes from "prop-types";
import AddUsers from "../pages/addUsers";
import Modal from 'react-modal';


NavList.propTypes = {
  handleModel: PropTypes.func,
};
function NavList({ handleModel }) {
  const { logOut } = useAuth();

  return (
    <ul className="my-2 flex flex-col gap-2 lg:mb-0 lg:mt-0 lg:flex-row lg:items-center lg:gap-6">
      {/* <Typography
        as="li"
        variant="small"
        color="white"
        className="p-1 font-medium"
      >
        <button
          onClick={() =>
            location.pathname === "/reports"
              ? navigate("/dashboard")
              : navigate("/reports")
          }
          type="button"
          className="flex items-center hover:text-black transition-colors"
        >
          {location.pathname === "/reports" ? "Dashboard" : "Reports"}
        </button>
      </Typography> */}

      <Typography
        as="li"
        variant="small"
        color="white"
        className="p-1 font-medium"
      >
        <button
          onClick={handleModel}
          type="button"
          className="flex items-center hover:text-black transition-colors"
        >
          Add User
        </button>
      </Typography>

      <Typography
        as="li"
        variant="small"
        color="white"
        className="p-1 font-medium"
      >
        <button
          onClick={logOut}
          type="button"
          className="flex items-center hover:text-black transition-colors"
        >
          Logout
        </button>
      </Typography>
    </ul>
  );
}

export default function NavBar() {
  const [openNav, setOpenNav] = useState(false);
  Modal.setAppElement('#root');

  const [modalIsOpen, setIsOpen] = useState(false);

  function openModal() {
    setIsOpen((prev) => !prev);
    console.log("working");
  }
  const handleWindowResize = () =>
    window.innerWidth >= 960 && setOpenNav(false);

  React.useEffect(() => {
    window.addEventListener("resize", handleWindowResize);

    return () => {
      window.removeEventListener("resize", handleWindowResize);
    };
  }, []);

  return (
    <>
      <Navbar className="mx-auto max-w-screen-2xl px-6 py-3 opacity-100 bg-accent2-primary border-accent2-primary">
        <div className="flex items-center justify-between text-white">
          <Typography
            as="a"
            href="#"
            variant="h6"
            className="mr-4 cursor-pointer py-1.5"
          >
            Bandhu
          </Typography>
          <div className="hidden lg:block">
            <NavList handleModel={openModal} />
          </div>
          <IconButton
            variant="text"
            className="ml-auto h-6 w-6 text-inherit hover:bg-transparent focus:bg-transparent active:bg-transparent lg:hidden"
            ripple={false}
            onClick={() => setOpenNav(!openNav)}
          >
            {openNav ? (
              <XMarkIcon className="h-6 w-6" strokeWidth={2} />
            ) : (
              <Bars3Icon className="h-6 w-6" strokeWidth={2} />
            )}
          </IconButton>
        </div>
        <Collapse open={openNav}>
          <NavList handleModel={openModal}  />
        </Collapse>
      </Navbar>
      <Modal
        isOpen={modalIsOpen}
        style={customStyles}
        contentLabel="Example Modal"
      >
        <AddUsers handleModel={openModal} />
      </Modal>
    </>
  );
}

const customStyles = {
  
  content: {
    top: "50%",
    left: "50%",
    right: "auto",
    bottom: "auto",
    marginRight: "-50%",
    background:"transparent",
    border:0,
    transform: "translate(-50%, -50%)",
  },
  overlay:{
    background:"rgba(0, 0, 0, 0.7)",
  }
};
