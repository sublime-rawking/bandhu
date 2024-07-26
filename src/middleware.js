import { NextResponse } from 'next/server'

/**
 * Middleware function to handle authentication and redirection based on token and pathname.
 * If the token is missing and the pathname is not "/", redirects to the root URL.
 * If the token is present and the pathname is "/", redirects to the dashboard URL.
 *
 * @param {Request} request - The incoming request object.
 * @return {Promise<NextResponse|undefined>} A promise that resolves with the NextResponse
 * indicating the redirection outcome. If no redirection is necessary, returns undefined.
 */
export async function middleware(request) {
  // Extract token and pathname from the request
  const token = request.cookies.get("token");
  const pathname = request.nextUrl.pathname;

  // If token is missing and pathname is not "/", redirect to root URL
  if (!token && pathname !== "/") {

    return NextResponse.redirect(new URL("/", request.url));
  }

  // If token is present and pathname is "/", redirect to dashboard URL
  if (token && pathname === "/") {
    if (token.value) {

      return NextResponse.redirect(new URL("/dashboard", request.url));
    }
    return NextResponse.redirect(new URL("/", request.url));
  }
}

// See "Matching Paths" below to learn more
export const config = {
  matcher: ["/dashboard", "/"],
}