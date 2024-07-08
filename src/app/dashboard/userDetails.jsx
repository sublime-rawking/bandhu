import Image from "next/image";
import React, { useState } from "react";

function UserDetails({ user, modalRef }) {
  const [status, setStatus] = useState(user && user.status == 1 ? true : false);
  const backgroundClose = (e) => {
    if (e.target === e.currentTarget) {
      modalRef.current.close();
    }
  };

  const onStatusChange = async () => {
    const data = await fetch(`/api/admin/allUsers`, {
      method: "PUT",
      headers: {
        "Content-Type": "application/json",
        "x-access-token": sessionStorage.getItem("user"),
      },
      body: JSON.stringify({
        id: user.id,
        isDisable: status ? 0 : 1,
      }),
    }).then(async (res) => await res.json());
    console.log(data);
    window.location.reload();
    setStatus(!status);
  };

  return (
    <dialog
      className="backdrop  rounded-xl w-full md:w-1/2 h-fit "
      ref={modalRef}
      onClick={backgroundClose}
    >
      <div className="p-10 w-full">
        {user ? (
          <div className="flex  w-full flex-col space-y-4">
            <h3 className="font-bold text-xl">Member Id: {user.id}</h3>
            <table className=" text-sm md:text-lg ">
              <tbody className="divide-y divide-gray-200">
                <tr className="py-6 ">
                  <td colSpan={2} className="my-2">
                    <div className="flex flex-col md:flex-row items-center ">
                      <Image
                        src={
                          user.profile_image
                            ? user.profile_image
                            : "https://images.unsplash.com/photo-1569173112611-52a7cd38bea9"
                        }
                        alt={`profile image of ${user.name}`}
                        priority
                        width={1000}
                        height={1000}
                        className="w-32 h-32 object-fill rounded-xl md:mr-3 my-2 md:my-0"
                      />
                      <div className=" text-wrap">
                        <div className="flex">
                          <p className="font-bold mr-1">Name: </p>
                          {`${user.name}`}
                        </div>
                        <div className="flex  text-wrap">
                          <p className="font-bold mr-1 ">Email: </p>
                          {`${user.email}`}
                        </div>
                        <div className="flex">
                          <p className="font-bold mr-1">Mobile: </p>
                          {`${user.mobile}`}
                        </div>
                      </div>
                    </div>
                  </td>
                </tr>
                <tr className="py-6">
                  <td className="py-4 pr-4">DCP:</td>
                  <td className="py-4">
                    <a
                      href={`dcp/${user.dcp}`}
                      target="_blank"
                      rel="noopener noreferrer"
                      className="text-primaryDark  hover:underline"
                    >
                      {user.dcp}
                    </a>
                  </td>
                </tr>
                <tr className="py-6">
                  <td className="py-4 pr-4">Give Asks:</td>
                  <td className="py-4">{user.give_ask_count}</td>
                </tr>
                <tr className="py-6">
                  <td className="py-4 pr-4">Status:</td>
                  <td className="py-4">
                    <button
                      className="ml-2 px-2 py-1 rounded-md bg-primary text-white"
                      onClick={() => onStatusChange()}
                    >
                      {status ? "Active" : "Inactive"}
                    </button>
                  </td>
                </tr>
              </tbody>
            </table>
          </div>
        ) : (
          <div>
            <h2>User not found</h2>
          </div>
        )}
      </div>
    </dialog>
  );
}

export default UserDetails;
