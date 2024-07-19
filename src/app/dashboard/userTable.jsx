"use client";
import Image from "next/image";
import React, { useRef, useState } from "react";
import { SortAmountDownAlt, SortAmountUpAlt } from "react-flaticons";
import UserDetails from "./userDetails";
import { SortingProvider } from "@/helper/sortingProvider";
/**
 * Renders a table of users with sorting functionality.
 *
 * @param {Object} props - The properties passed to the component.
 * @param {Array} props.users - The array of user objects to render in the table.
 * @return {JSX.Element} The rendered table component.
 */
function UserTable({ users }) {
  // State variables to store the data, selected member, and modal reference
  const [data, setData] = useState(users);
  const [selectedMember, setSelectedMember] = useState(
    users.length > 0 ? users[0] : null
  );
  const modalRef = useRef();

  // Table header data
  const TABLE_HEAD = [
    { name: "Sr No.", field: "" },
    { name: "Name", field: "name" },
    { name: "Mobile", field: "mobile" },
    { name: "give_asks", field: "mobile" },
    { name: "dcp", field: "mobile" },
    { name: "Status", field: "status" },
  ];

  // State variables to store the sorting order and by
  const [order, setOrder] = useState("decs");
  const [orderBy, setOrderBy] = useState("id");

  /**
   * Sorts the data based on the specified key and order.
   *
   * @param {string} key - The field to sort by.
   */
  const sortData = (key) => {
    // Call the sorting provider with the key, order, orderBy, and data
    const sortingData = SortingProvider({
      key,
      order,
      orderBy,
      data,
    });

    // Update the orderBy and order state variables
    setOrderBy(sortingData.prevOrderBy);
    setOrder(sortingData.prevOrder);

    // Update the data state variable with the sorted data
    setData(sortingData.sortedData);
  };

  /**
   * Opens the modal with the user details at the specified index.
   *
   * @param {number} index - The index of the user.
   */
  const onPressView = (index) => {
    // Set the selected member to the user at the specified index
    setSelectedMember(users.at(index));

    // Show the modal
    modalRef.current.showModal();
  };
  return (
    <>
      <div className="overflow-x-auto mx-10">
        <div className=" w-full overflow-scroll z-0">
          <table className="w-full min-w-max  table-auto text-left">
            <thead>
              <tr>
                {TABLE_HEAD.map((head, index) => (
                  <th
                    key={index}
                    className="border-b border-blue-gray-100 bg-blue-gray-50 p-4"
                  >
                    <h4
                      variant="small"
                      color="blue-gray"
                      className="font-normal flex  group "
                      onClick={() => sortData(head.field)}
                    >
                      {head.name}
                      <span className="ml-1 my-auto opacity-0  group-hover:opacity-100 transition-opacity ">
                        {head.field !== "" ? (
                          order === "decs" && orderBy === head.field ? (
                            <SortAmountDownAlt className="w-5 h-5" />
                          ) : (
                            <SortAmountUpAlt className="w-5 h-5" />
                          )
                        ) : (
                          <></>
                        )}
                      </span>
                    </h4>
                  </th>
                ))}
                <th
                  key={"Actions"}
                  className="border-b text-end border-blue-gray-100 bg-blue-gray-50 p-4"
                >
                  <h4
                    variant="small"
                    color="blue-gray"
                    className="font-normal leading-none opacity-70"
                  >
                    View
                  </h4>
                </th>
              </tr>
            </thead>
            <tbody>
              {data.map(
                (
                  {
                    id,
                    name,
                    mobile,
                    profile_image,
                    email,
                    give_ask_count,
                    dcp,
                    status,
                  },
                  index
                ) => {
                  const isLast = index === data.length - 1;
                  const classes = isLast
                    ? "p-4"
                    : "p-4 border-b border-blue-gray-50  ";
                  return (
                    <tr key={index}>
                      <td className={classes}>
                        <h4
                          variant="small"
                          color="blue-gray"
                          className="font-normal"
                        >
                          {index + 1}
                        </h4>
                      </td>

                      <td className={classes}>
                        <div className="flex  align-middle ">
                          <Image
                            src={
                              profile_image
                                ? profile_image
                                : "https://images.unsplash.com/photo-1569173112611-52a7cd38bea9"
                            }
                            alt={`profile image of ${name}`}
                            priority
                            width={1000}
                            height={1000}
                            className="w-10  h-10 my-auto rounded-xl mr-3"
                          />

                          <div className="font-normal flex flex-col max-w-40  ">
                            <h6 className="text-sm">Member Id :{id}</h6>
                            <h4>{name}</h4>
                            <h4 title={email} className="tooltip-secondary ">
                              {email}
                            </h4>
                          </div>
                        </div>
                      </td>
                      <td className={classes}>
                        <h4
                          variant="small"
                          color="blue-gray"
                          className="font-normal "
                        >
                          {mobile}
                        </h4>
                      </td>
                      <td className={classes}>
                        <h4
                          variant="small"
                          color="blue-gray"
                          className="font-normal "
                        >
                          {give_ask_count}
                        </h4>
                      </td>
                      <td className={classes}>
                        <h4
                          variant="small"
                          color="blue-gray"
                          className="font-normal "
                        >
                          {dcp ? "Yes" : "No"}
                        </h4>
                      </td>
                      <td className={`${classes} `}>
                        <h4
                          variant="small"
                          color="blue-gray"
                          className="font-normal  "
                        >
                          {status == 1 ? "Active" : "Inactive"}
                        </h4>
                      </td>
                      <td className={`${classes}  text-end items-end`}>
                        <button
                          className="border-black  border-2  w-20 h-8 rounded-xl"
                          onClick={() => onPressView(index)}
                        >
                          View
                        </button>
                      </td>
                    </tr>
                  );
                }
              )}
            </tbody>
          </table>
        </div>
      </div>

      <UserDetails user={selectedMember} modalRef={modalRef} />
    </>
  );
}

export default UserTable;
