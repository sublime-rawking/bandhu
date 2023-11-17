import { Card, Typography, Button, CardFooter } from "@material-tailwind/react";
import { MagnifyingGlassIcon } from "@heroicons/react/24/solid";
import { useEffect, useState } from "react";
import { Input } from "@material-tailwind/react";
import React from "react";
import PropTypes from "prop-types";
import { StatusUsers } from "../api/usersApi";
import { toast } from "react-toastify";

const header = [
  "Sr. No",
  "User Id",
  "Name",
  "Email",
  "Mobile No.",
  "Ask and Given | DCP",
  "Status",
];

UserTable.propTypes = {
  data: PropTypes.array.isRequired, // change to match the actual data type
};
export default function UserTable({ data }) {
  const [page, setPage] = useState(1);
  var [tableData, setTableData] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");
  const [toggleStates, setToggleStates] = useState(
    data.reduce(
      (acc, item) => ({ ...acc, [item.user_id]: item.status == "1" }),
      {}
    )
  );
  const itemsPerPage = 10;

  // Update searchTerm whenever the input changes
  const handleSearchChange = (e) => {
    setSearchTerm(e.target.value);
  };

  const handlePagination = ({ next }) => {
    // If there is no next value and the current page is 1, return.
    if (!next && page === 1) return;

    // If there is a next value and the current page is the last page, return.
    if (next && page === Math.ceil(data.length / itemsPerPage)) return;

    // Update the page based on the next value.
    setPage((prev) => (next ? prev + 1 : prev - 1));
  };

  useEffect(() => {
    let indexOfLastItem = page * itemsPerPage;
    let indexOfFirstItem = indexOfLastItem - itemsPerPage;
    setTableData(data);

    setTableData((prev) => {
      // Filter tableData based on searchTerm
      const filteredData = prev.filter((item) =>
        item.Name.toLowerCase().includes(searchTerm.toLowerCase())
      );
      return filteredData.slice(indexOfFirstItem, indexOfLastItem);
    });
  }, [page, searchTerm]);

  // Function to toggle the state of a specific item
  const toggle = async (id) => {
    let res = await StatusUsers({ 
      userId: id,
      status: !toggleStates[id] ? 1 : 2,
    });
    if (res) {
      setToggleStates((prev) => ({ ...prev, [id]: !prev[id] }));
      return;
    }
    toast.error("Something went wrong", {
      position: toast.POSITION.BOTTOM_RIGHT,
    });
  };

  return (
    <Card className="h-full w-full overflow-x-scroll bg-accent2-primary ">
      <div className=" flex items-center  w-full  bg-accent2-primary p-4">
        <Typography variant="h5" color="white">
          Users
        </Typography>
        <div className="w-9  ml-3">
          <Input
            color="white"
            label="Search User"
            className="text-white "
            onChange={(e) => handleSearchChange(e)}
            icon={
              <MagnifyingGlassIcon
                className="items-center m-auto  text-white"
                strokeWidth={2}
              />
            }
          />
        </div>
      </div>

      {tableData.length === 0 ? (
        <></>
      ) : (
        <table className="w-full min-w-max table-auto text-center">
          <thead>
            <tr>
              {header.map((head) => (
                <th
                  key={head}
                  className="border-b border-yellow-400 bg-gray-900 p-4 text-white"
                >
                  <Typography
                    variant="small"
                    color="white"
                    className="font-normal leading-none opacity-70"
                  >
                    {head}
                  </Typography>
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="bg-black ">
            {tableData.length === 0 ? (
              <></>
            ) : (
              tableData.map(
                (
                  { user_id, Name, email, Mobile, give_ask_count, DCP },
                  index
                ) => {
                  const classes =
                    index === data.length - 1
                      ? "p-4"
                      : "p-4 border-b border-blue-gray-50";
                  const toggleClass = toggleStates[user_id]
                    ? "translate-x-6 inline-block w-4 h-4 transform bg-white rounded-full transition-transform duration-200 ease-in-out"
                    : "translate-x-1 inline-block w-4 h-4 transform bg-white rounded-full transition-transform duration-200 ease-in-out";
                  return (
                    <tr key={index}>
                      <td className={classes}>
                        <Typography
                          variant="small"
                          color="white"
                          className="font-normal"
                        >
                          {(page - 1) * itemsPerPage + index + 1}
                        </Typography>
                      </td>
                      <td className={classes}>
                        <Typography
                          variant="small"
                          color="white"
                          className="font-normal"
                        >
                          {user_id}
                        </Typography>
                      </td>
                      <td className={classes}>
                        <Typography
                          variant="small"
                          color="white"
                          className="font-normal"
                        >
                          {Name}
                        </Typography>
                      </td>
                      <td className={classes}>
                        <Typography
                          variant="small"
                          color="white"
                          className="font-normal"
                        >
                          {email}
                        </Typography>
                      </td>
                      <td className={classes}>
                        <Typography
                          variant="small"
                          color="white"
                          className="font-normal"
                        >
                          {Mobile}
                        </Typography>
                      </td>
                      <td className={classes}>
                        <Typography
                          variant="small"
                          color="white"
                          className="font-normal"
                        >
                          {`${give_ask_count} | ${DCP ? "Yes" : "No"}`}
                        </Typography>
                      </td>
                      <td className={classes}>
                        <button
                          onClick={() => toggle(user_id)}
                          className={`relative inline-flex items-center h-6 rounded-full w-11 focus:outline-none ${
                            toggleStates[user_id]
                              ? "bg-primary"
                              : "bg-accent2-primary"
                          }`}
                        >
                          {/* <span className="sr-only">Toggle Switch</span> */}
                          <span className={toggleClass} />
                        </button>
                      </td>
                    </tr>
                  );
                }
              )
            )}
          </tbody>
        </table>
      )}

      <CardFooter className="flex w-full items-center justify-between border-t border-blue-gray-50 bg-accent2-primary py-2 px-3">
        <Typography
          variant="small"
          color="white"
          className="font-normal"
        >{`  Page ${page} of ${Math.ceil(
          data.length / itemsPerPage
        )}`}</Typography>
        <div className="flex gap-2 flex-col-reverse sm:flex-row">
          <Button
            className={page === 1 ? "hidden" : "text-white border-white "}
            variant="outlined"
            size="sm"
            onClick={() => handlePagination({ next: false })}
          >
            Previous
          </Button>
          <Button
            className={
              page === Math.ceil(data.length / itemsPerPage)
                ? "hidden"
                : " text-white border-white "
            }
            variant="outlined"
            size="sm"
            onClick={() => handlePagination({ next: true })}
          >
            Next
          </Button>
        </div>
      </CardFooter>
    </Card>
  );
}
