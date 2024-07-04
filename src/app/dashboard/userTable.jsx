import Image from "next/image";
import React from "react";
import { GET } from "../api/admin/allUsers/route";

async function UserTable() {
  const users = await GET().then(async (res) => await res.json());
  console.log(users);
  return (
    <div className="overflow-x-auto mx-10">
      <table className="table">
        {/* head */}
        <thead>
          <tr>
            <th>Sr No.</th>
            <th>Name</th>
            <th>Details</th>
            <th>GIVE AND ASK | DCP</th>
            <th>Action</th>
          </tr>
        </thead>
        <tbody>
          {Array(10).map((user, index) => (
            <tr key={index}>
              <td>{index + 1}</td>
              <td>{index + 1}</td>
              <td>
                <div className="flex items-center gap-3">
                  <div className="avatar">
                    <div className="mask mask-squircle h-12 w-12">
                      <Image
                        priority
                        width={1000}
                        height={1000}
                        src="https://img.daisyui.com/tailwind-css-component-profile-2@56w.png"
                        alt="Avatar Tailwind CSS Component"
                      />
                    </div>
                  </div>
                  <div>
                    <div className="font-bold">{user.name}</div>
                  </div>
                </div>
              </td>
              <td>
                Zemlak, Daniel and Leannon
                <br />
                <span className="badge badge-ghost badge-sm">
                  Desktop Support Technician
                </span>
              </td>
              <td>Primary</td>
              <th>
                <button className="btn btn-ghost btn-xs">details</button>
              </th>
            </tr>
          ))}
        </tbody>
        <tfoot></tfoot>
      </table>
    </div>
  );
}

export default UserTable;
