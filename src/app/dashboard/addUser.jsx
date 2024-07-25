"use client";
import Image from "next/image";
import React, { useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { MdOutlinePlaylistRemove } from "react-icons/md";

/**
 * @function AddDetails
 * @description This component is used to add new user to the database.
 * @param {boolean} isOpen - This props is used to show or hide the modal.
 * @returns {JSX.Element} - The JSX element of the component.
 */
const AddDetails = ({ isOpen }) => {
  const route = useRouter();

  const modalRef = useRef();
  const profileImage = useRef(null);
  const [profileImageURL, setProfileImageURL] = useState("");
  const [error, setError] = useState("");
  const [loader, setLoader] = useState(false);

  /**
   * @function backgroundClose
   * @description This function is used to close the modal when the background is clicked.
   * @param {Event} e - The event of the click.
   */
  const backgroundClose = () => {
    // if (e.target === e.currentTarget) {
    //   modalRef.current.close();
    //   route.replace("/dashboard");
    // }
  };

  /**
   * @function handleSubmit
   * @description This function is used to handle the form submission.
   * @param {Event} e - The event of the form submission.
   */
  const handleSubmit = async (e) => {
    e.preventDefault();
    setLoader(true);
    const formData = new FormData();
    formData.append("profileImage", profileImage.current.files[0]);
    formData.append("name", e.target.name.value);
    formData.append("mobile", e.target.mobile.value);
    formData.append("email", e.target.email.value);
    formData.append("password", e.target.password.value);

    const response = await fetch("/api/admin/addUser", {
      method: "POST",
      body: formData,
    });
    const data = await response.json();
    if (data.success) {
      setLoader(false);
      modalRef.current.close();
      window.location.replace("/dashboard");
      return true;
    }
    setLoader(false);
    setError(data.message);
    return false;
  };

  useEffect(() => {
    if (isOpen) {
      modalRef.current.showModal();
    } else {
      modalRef.current.close();
    }
  }, [isOpen, profileImage]);
  return (
    <dialog
      className="backdrop  rounded-xl w-full md:w-1/2 h-fit "
      ref={modalRef}
      onClick={backgroundClose}
    >
      <div className="p-10 w-full">
        <div className="flex  w-full flex-col space-y-4">
          <h3 className="font-bold text-xl">Add Member</h3>
          <form className="flex flex-col space-y-4" onSubmit={handleSubmit}>
            <div className="flex flex-col space-y-2">
              <div className="flex flex-row justify-between">
                <label htmlFor="profile-image">Profile Image</label>
                {profileImageURL !== "" && (
                  <MdOutlinePlaylistRemove
                    className="w-7 h-7 text-red-600"
                    onClick={() => setProfileImageURL("")}
                  />
                )}
              </div>

              <Image
                src={
                  profileImageURL !== ""
                    ? URL.createObjectURL(profileImageURL)
                    : "https://images.unsplash.com/photo-1569173112611-52a7cd38bea9"
                }
                width={1000}
                height={1000}
                priority
                alt="profile"
                onClick={() => profileImage.current.click()}
                className="w-40 h-40 rounded-full mx-auto"
              />
              <input
                type="file"
                className="hidden"
                id="profile-image"
                ref={profileImage}
                onChange={(e) => setProfileImageURL(e.target.files[0])}
              />
            </div>
            <div className="flex flex-col space-y-4">
              <div className="flex flex-col space-y-2">
                <label htmlFor="name" className="text-gray-700">
                  Name
                </label>
                <input
                  type="text"
                  id="name"
                  pattern="^[a-zA-Z ]+$"
                  title="Enter a valid name"
                  required
                  className="border border-gray-300 rounded-lg py-2 px-4"
                />
              </div>
              <div className="flex flex-col space-y-2">
                <label htmlFor="email" className="text-gray-700">
                  Email
                </label>
                <input
                  type="email"
                  id="email"
                  required
                  pattern="^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$"
                  title="Enter a valid email address"
                  className="border border-gray-300 rounded-lg py-2 px-4"
                />
              </div>
              <div className="flex flex-col space-y-2">
                <label htmlFor="mobile" className="text-gray-700">
                  Mobile
                </label>
                <input
                  type="tel"
                  id="mobile"
                  required
                  pattern="[0-9]{1,10}"
                  title="Enter 10 digit valid mobile number"
                  className="border border-gray-300 rounded-lg py-2 px-4"
                  maxLength={10}
                />
              </div>
              <div className="flex flex-col space-y-2">
                <label htmlFor="password" className="text-gray-700">
                  Password
                </label>
                <input
                  type="password"
                  id="password"
                  className="border border-gray-300 rounded-lg py-2 px-4"
                />
              </div>
              {error && <p className="text-red-500">{error}</p>}
            </div>
            <div className="flex flex-col space-y-4 md:space-y-0 md:flex-row md:justify-evenly">
              <button
                type="submit"
                disabled={loader}
                className="bg-primary hover:bg-primaryDark text-white font-bold  px-4 rounded"
              >
                {loader ? (
                  <div className="loading loading-dots loading-md  mx-10 " />
                ) : (
                  "Add Member"
                )}
              </button>
              <button
                type="button"
                onClick={() => {
                  modalRef.current.close();
                  route.replace("/dashboard");
                }}
                className="outline-accent outline hover:bg-accentLight hover:text-white  text-text font-bold py-2 px-4 rounded"
              >
                Close
              </button>
            </div>
          </form>
        </div>
      </div>
    </dialog>
  );
};

export default AddDetails;
