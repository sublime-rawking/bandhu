"use client";
import { logo } from "@/assets";
import { LoginService } from "@/services/AuthServices";
import Image from "next/image";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { FaArrowRight } from "react-icons/fa";
import { FaEye, FaEyeSlash } from "react-icons/fa";




/**
 * Home component is the main page of the application, it contains the login form
 * and handles the login functionality.
 *
 * @returns {JSX.Element} The Home component
 */
export default function Home() {
  // State variables to manage the form inputs and error message
  const [showPassword, setShowPassword] = useState(false);
  const [error, setError] = useState("");
  const route = useRouter();

  /**
   * Handles the form submission, makes a login request to the server and
   * redirects the user to the dashboard if the login is successful.
   *
   * @param {Event} e - The form submission event
   * @returns {Promise<void>} - A Promise that resolves when the function completes
   */
  const onFormSubmit = async (e) => {
    e.preventDefault();
    console.log("submitted");
    const res = await LoginService({ email: e.target.username.value, password: e.target.password.value });
    console.log(res);
    if (res.status === 200) {
      route.push("/dashboard");
      return
    }
    console.log(res.message);
    setError(res.message)
  }

  return (
    <main className="flex flex-col justify-center align-middle
     min-h-screen items-center">
      <form
        onSubmit={onFormSubmit}
        className="md:w-container p-10 flex flex-col space-y-12 sm:shadow-lg md:w-1/2 lg:w-1/3 xl:w-1/4 rounded-lg"
      >
        <header className="mb-8 text-center space-y-1 w-full">
          <h1 className="font-semibold text-3xl bg-gradient-to-r from-[#c45050] to-primary bg-clip-text text-transparent">
            RefferGenix
          </h1>
          <Image src={logo} priority alt="logo" width={1000} height={1000} className="w-52 h-w-52 shadow-lg rounded-md mx-auto" />
        </header>
        {/* INPUTS FIELDS */}
        <section id="form-input-fields" className="flex flex-col space-y-6">
          <div className="w-full">
            <input
              type="text"
              className="w-full px-4 py-2 rounded-xl border border-gray-400 bg-gray-100 text-base text-gray-700 font-semibold"
              placeholder="Username"
              aria-label="Username"
              name="username"
              required
            />
          </div>
          <div className="w-full relative space-y-2">
            <input
              type={showPassword ? "text" : "password"}
              className="inline-block w-full px-4 py-2 rounded-xl border border-gray-400 bg-gray-100 text-base text-gray-700 font-semibold"
              placeholder="********"
              required
              name="password"
            />
            <button
              type="button"
              style={{ boxShadow: "none" }}
              className="text-base absolute right-0 top-0 px-4 py-1 rounded-full text-gray-600"
              onClick={() => setShowPassword((prev) => !prev)}
            >
              {showPassword ? <FaEyeSlash /> :
                <FaEye />}
            </button>
          </div>
          {error && <p className="text-red-500 text-sm">{error}</p>}
        </section>
        <footer className=" ml-auto flex justify-end">
          <button
            type="submit"
            className="bg-primary transition-all duration-1000 ease-out hover:bg-accentLight   flex flex-row group w-fit rounded-full px-4 py-2 text-white"
          >
            <span className="mr-2 transition-all duration-1000  group-hover:block  md:hidden">
              Submit
            </span>
            <FaArrowRight className="w-6 h-6" />
          </button>
        </footer>
      </form>
    </main>
  );
}
