import { Card, Typography, Button, CardFooter } from "@material-tailwind/react";
import { MagnifyingGlassIcon } from "@heroicons/react/24/solid";
import { useEffect, useState } from "react";
import { Input } from "@material-tailwind/react";

const header = ["id", "name", "email", "role", "Action"];

export default function UserTable({ data }) {
  const [page, setPage] = useState(1);
  var [tableData, setTableData] = useState([]);
  const itemsPerPage = 10;

  const nextTableData = ({ next }) => {
    if (!next && page === 1) return;
    if (next && page === Math.ceil(data.length / itemsPerPage)) return;
    setPage((prev) => (next ? prev + 1 : prev - 1));
  };

  useEffect(() => {
    let indexOfLastItem = page * itemsPerPage;
    let indexOfFirstItem = indexOfLastItem - itemsPerPage;
    console.log(indexOfFirstItem, indexOfLastItem);
    setTableData(data);
    setTableData((prev) => prev.slice(indexOfFirstItem, indexOfLastItem));
    console.log(tableData);
  }, [page]);

  const [toggleStates, setToggleStates] = useState(
    tableData.reduce((acc, item) => ({ ...acc, [item.id]: false }), {})
  );

  // Function to toggle the state of a specific item
  const toggle = (id) => {
    setToggleStates((prev) => ({ ...prev, [id]: !prev[id] }));
  };

  return (
    <Card className="h-full w-full overflow-x-scroll bg-accent2-primary ">
      <div className=" flex items-center  w-full  bg-accent2-primary p-4">
        <Typography variant="h5" color="white" children="Users" />
        <div className="w-9  ml-3">
          <Input
            color="white"
            label="Search User"
            className="text-white "
            icon={
              <MagnifyingGlassIcon
                className="items-center m-auto text-white"
                strokeWidth={2}
              />
            }
          />
        </div>
      </div>

      {tableData.length === 0 ? (
        <></>
      ) : (
        <table className="w-full min-w-max table-auto text-left">
          <thead>
            <tr>
              {header.map((head) => (
                <th
                  key={head}
                  className="border-b border-yellow-400 bg-accent2-primary p-4 text-white"
                >
                  <Typography
                    variant="small"
                    color="white"
                    className="font-normal leading-none opacity-70"
                    children={head}
                  />
                </th>
              ))}
            </tr>
          </thead>
          <tbody className="bg-black">
            {tableData.length === 0 ? (
              <></>
            ) : (
              tableData.map(({ id, name, email, role }, index) => {
                // const [isToggled, setIsToggled] = useState(false);

                // const toggle = () => {
                //   setIsToggled((prev) => !prev);
                // };

                const classes =
                  index === data.length - 1
                    ? "p-4"
                    : "p-4 border-b border-blue-gray-50";
                const toggleClass = toggleStates[id]
                  ? "translate-x-6 inline-block w-4 h-4 transform bg-white rounded-full transition-transform duration-200 ease-in-out"
                  : "translate-x-1 inline-block w-4 h-4 transform bg-white rounded-full transition-transform duration-200 ease-in-out";
                return (
                  <tr key={index}>
                    <td className={classes}>
                      <Typography
                        variant="small"
                        color="white"
                        className="font-normal"
                        children={(page - 1) * itemsPerPage + index + 1}
                      />
                    </td>
                    <td className={classes}>
                      <Typography
                        variant="small"
                        color="white"
                        className="font-normal"
                        children={name}
                      />
                    </td>
                    <td className={classes}>
                      <Typography
                        variant="small"
                        color="white"
                        className="font-normal"
                        children={email}
                      />
                    </td>
                    <td className={classes}>
                      <Typography
                        variant="small"
                        color="white"
                        className="font-normal"
                        children={role}
                      />
                    </td>
                    <td className={classes}>
                      <button
                        onClick={() => toggle(id)}
                        className={`relative inline-flex items-center h-6 rounded-full w-11 focus:outline-none ${
                          toggleStates[id] ? "bg-primary" : "bg-accent2-primary"
                        }`}
                      >
                        <span className="sr-only">Toggle Switch</span>
                        <span className={toggleClass} />
                      </button>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      )}
      <CardFooter className="flex w-full  items-center justify-between border-t border-blue-gray-50 bg-black py-2 px-3">
        <Typography
          variant="small"
          color="white"
          className="font-normal"
          children={`  Page ${page} of ${Math.ceil(
            data.length / itemsPerPage
          )}`}
        />
        <div className="flex gap-2 flex-col-reverse sm:flex-row">
          <Button
            className={page === 1 ? "hidden" : "text-white "}
            variant="outlined"
            size="sm"
            onClick={() => nextTableData({ next: false })}
          >
            Previous
          </Button>
          <Button
            className={
              page === Math.ceil(data.length / itemsPerPage)
                ? "hidden"
                : " text-white  "
            }
            variant="outlined"
            size="sm"
            onClick={() => nextTableData({ next: true })}
          >
            Next
          </Button>
        </div>
      </CardFooter>
    </Card>
  );
}
