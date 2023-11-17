import { Card, Typography, Button, CardFooter } from "@material-tailwind/react";
import { MagnifyingGlassIcon } from "@heroicons/react/24/solid";
import { useEffect, useState, useRef } from "react";
import { Input } from "@material-tailwind/react";
import React from "react";
import PropTypes from "prop-types";

const header = ["SR. No", "User Id", "Name", "Email"];

ReportTable.propTypes = {
  data: PropTypes.array.isRequired, // change to match the actual data type
};
export default function ReportTable({ data }) {
  const [page, setPage] = useState(1);
  var [tableData, setTableData] = useState([]);
  const [searchTerm, setSearchTerm] = useState("");

  const itemsPerPage = 10;
  const [month, setMonth] = useState("");
  const monthPickerRef = useRef();

  useEffect(() => {
    const date = new Date();
    const year = date.getFullYear();
    let month = date.getMonth() + 1;

    if (month < 10) {
      month = `0${month}`;
    }

    const formattedMonth = `${year}-${month}`;
    setMonth(formattedMonth);
    monthPickerRef.current.setAttribute("max", formattedMonth);
  }, []);

  const handleMonthChange = (event) => {
    setMonth(event.target.value);
  };

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
        item.name.toLowerCase().includes(searchTerm.toLowerCase())
      );
      return filteredData.slice(indexOfFirstItem, indexOfLastItem);
    });
  }, [page, searchTerm]);

  // Function to toggle the state of a specific item

  return (
    <Card className="h-full w-full overflow-x-scroll bg-accent2-primary ">
      <div className=" flex items-center  w-full  bg-accent2-primary p-4">
        <Typography variant="h5" color="white">
          Reports
        </Typography>

        <div className=" mx-3 ">
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
        <div className="mx-3">
          <style>
        {`
          #month-picker::-webkit-calendar-picker-indicator {
            filter: invert(1);
          }
        `}
      </style>
          <input
            className="shadow appearance-none border rounded py-2 px-3 text-white  bg-transparent  leading-tight focus:outline-none focus:shadow-outline"
            id="month-picker"
            ref={monthPickerRef}
            label="Select month"
            type="month"
            value={month}
            onChange={handleMonthChange}
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
              tableData.map(({ id, name, email }, index) => {
                const classes =
                  index === data.length - 1
                    ? "p-4"
                    : "p-4 border-b border-blue-gray-50";

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
                        {id}
                      </Typography>
                    </td>
                    <td className={classes}>
                      <Typography
                        variant="small"
                        color="white"
                        className="font-normal"
                      >
                        {name}
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
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      )}
      <CardFooter className="flex w-full  items-center justify-between border-t border-blue-gray-50 bg-accent2-primary py-2 px-3">
        <Typography
          variant="small"
          color="white"
          className="font-normal"
        >{`  Page ${page} of ${Math.ceil(
          data.length / itemsPerPage
        )}`}</Typography>
        <div className="flex gap-2 flex-col-reverse sm:flex-row">
          <Button
            className={page === 1 ? "hidden" : "text-white border-white"}
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
                : " text-white border-white  "
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
