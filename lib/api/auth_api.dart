// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/main.dart';
import 'package:bandhu/model/user_model.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth {
  final dio = Dio();

  /// Fetches user data from the API.
  ///
  /// Returns `true` if the data is fetched successfully, `false` otherwise.
  /// Throws an exception and displays an error message if something goes wrong.
  Future<bool> getUserData({
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      // Make API request to get user data
      var response = await dio.get(
        "$baseUrl/Api/getMembersbyID",
        queryParameters: {"id": ref.read(userDataProvider).userid},
      );

      var databody = jsonDecode(response.data);

      if (databody["MembersbyID"]["status"].toString() == "2") {
        // Log out the user if their account is disabled
        logOut(context: context, ref: ref);

        Fluttertoast.showToast(
          msg: "User Disabled by Administrator",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimary,
          textColor: white,
        );

        return false;
      }

      if (databody["success"] == true) {
        // Save user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user", jsonEncode(databody["MembersbyID"]));

        // Update user data in the app state
        ref.watch(userDataProvider.notifier).state =
            User.fromMap(databody["MembersbyID"]);
        write(databody["MembersbyID"].toString());
        return true;
      } else {
        Fluttertoast.showToast(
          msg: databody["status"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimary,
          textColor: white,
        );

        return false;
      }
    } catch (e) {
      write(e.toString());
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return false;
    }
  }

  /// Sign up function that sends a POST request to the specified API endpoint
  /// with the provided user data.
  ///
  /// Parameters:
  /// - userData: A map containing the user data.
  /// - ref: The widget reference.
  /// - context: The build context.
  ///
  /// Returns:
  /// - A boolean indicating whether the sign up was successful or not.
  Future signUp({
    required Map<String, String> userData,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      // Create a multipart request for the sign up endpoint
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/Api/signup"),
      );

      // Add all the user data fields to the request
      request.fields.addAll(userData);

      // If a profile picture is provided, add it to the request
      if (userData["Profile"].toString() != "") {
        request.files.add(await http.MultipartFile.fromPath(
          'Profile',
          userData["Profile"].toString(),
        ));
      }

      // Send the request and get the response
      http.Response response =
          await http.Response.fromStream(await request.send());

      // Decode the response body
      var databody = jsonDecode(response.body);

      // Write the response body to the console
      write(databody.toString());

      // If the sign up was successful, save the user data to shared preferences
      if (databody["success"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user", jsonEncode(databody["data"]));

        // Update the user data in the widget reference
        ref.watch(userDataProvider.notifier).state =
            User.fromMap(databody["data"]);

        // Get additional user data
        await getUserData(ref: ref, context: context);

        return true;
      } else {
        // Show an error toast message if sign up failed
        Fluttertoast.showToast(
          msg: databody["message"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimary,
          textColor: white,
        );
        return false;
      }
    } catch (e) {
      // Show a generic error toast message if an exception occurred
      write(e.toString());
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
    }
  }

  /// Signs in the user with the provided authentication data.
  /// Returns `true` if the sign-in is successful, `false` otherwise.
  /// Throws an exception if an error occurs.
  Future<bool> signIn({
    required Map<String, dynamic> authData,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      // Make a GET request to the login endpoint with the authentication data
      var res = await dio.get("$baseUrl/Api/login", queryParameters: authData);
      var databody = jsonDecode(res.data);
      write(databody.toString());

      if (databody["success"] == true) {
        if (databody["login"]["status"].toString() == "2") {
          // Log out the user if their status is 2 (disabled)
          logOut(context: context, ref: ref);

          // Show a toast message to inform the user
          Fluttertoast.showToast(
            msg: "User Disabled by Administrator",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: colorPrimary,
            textColor: white,
          );
          return false;
        }

        // Save the user data to SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user", jsonEncode(databody["login"]));

        // Update the user data in the app state
        ref.watch(userDataProvider.notifier).state =
            User.fromMap(databody["login"]);

        return true;
      } else {
        // Show a toast message with the error status
        Fluttertoast.showToast(
          msg: databody["status"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimary,
          textColor: white,
        );
        return false;
      }
    } catch (e) {
      // Handle any exceptions that occur and show a generic error message
      write(e.toString());
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return false;
    }
  }

  /// Uploads a PDF file to the server.
  ///
  /// Parameters:
  /// - `filePath`: The path of the PDF file to upload.
  /// - `ref`: The reference to the `WidgetRef` object.
  ///
  /// Returns:
  /// - A `Future` that completes with a boolean indicating the success of the upload.
  Future uploadPDF({required String filePath, required WidgetRef ref}) async {
    try {
      // Create a multipart request with the POST method
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/Api/updatepdf"),
      );

      // Add the PDF file to the request
      request.files.add(await http.MultipartFile.fromPath(
        'DCP',
        filePath,
      ));

      // Add the user ID to the request fields
      request.fields.addAll({"id": ref.read(userDataProvider).userid});

      // Send the request and get the response
      http.Response response =
          await http.Response.fromStream(await request.send());

      // Decode the response body
      var databody = jsonDecode(response.body);

      // Write the response body to the console
      write(databody.toString());

      // Return the value of the "success" field from the response body
      return databody["success"];
    } catch (e) {
      // Write the error message to the console
      write(e.toString());

      // Show a toast message indicating that something went wrong
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );

      // Return false to indicate failure
      return false;
    }
  }

  /// Sends a password reset request for the given [email].
  ///
  /// Returns `true` if the request was successful, otherwise `false`.
  Future<bool> forgetPassword({required String email}) async {
    try {
      // Create form data with the email
      var formData = FormData.fromMap({"email_id": email});

      // Send a POST request to the forgot_password API endpoint
      var res = await dio.post("$baseUrl/Api/forgot_password", data: formData);

      // Parse the response body as JSON
      var databody = jsonDecode(res.data);

      // Write the response body to a log
      write(databody.toString());
      Fluttertoast.showToast(
        msg: databody["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      // Return the value of the "success" field from the response body
      return databody["success"];
    } catch (e) {
      // Write the error to a log
      write(e.toString());

      // Show a toast message indicating an error occurred
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );

      // Return false to indicate the request failed
      return false;
    }
  }

  /// This method verifies the OTP for a given email and password.
  /// It makes a POST request to the API endpoint "/Api/verificationotp" with the provided parameters.
  /// Returns a boolean indicating whether the verification was successful or not.
  Future verifyOTP(
      {required String email,
      required String otp,
      required String password}) async {
    try {
      var formData =
          FormData.fromMap({"email": email, "otp": otp, "password": password});
      var res = await dio.post("$baseUrl/Api/verificationotp", data: formData);
      var databody = jsonDecode(res.data);
      write(databody.toString());
      return databody;
    } catch (e) {
      write(e.toString());
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return false;
    }
  }

  Future updateUser({
    required Map<String, String> userData,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/Api/updateuser"),
      );

      // Add all the user data fields to the request
      request.fields.addAll(userData);
      // If a profile picture is provided, add it to the request
      if (userData["Profile"] != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'Profile',
          userData["Profile"].toString(),
        ));
      }

      // Send the request and get the response
      http.Response response =
          await http.Response.fromStream(await request.send());

      // Write the response body to the console

      // If the sign up was successful, save the user data to shared preferences
      if (response.statusCode == 200 && response.body.isEmpty) {
        // Get additional user data
        await getUserData(ref: ref, context: context);

        return true;
      }
      // Show an error toast message if sign up failed
      Fluttertoast.showToast(
        msg: jsonDecode(response.body)["message"],
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return false;
    } catch (e) {
      write(e.toString());
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      );
      return false;
    }
  }

  /// Logs out the user and clears the shared preferences.
  ///
  /// Parameters:
  /// - `context`: The build context.
  /// - `ref`: The widget reference.
  Future logOut({required BuildContext context, required WidgetRef ref}) async {
    try {
      await SharedPreferences.getInstance().then((prefs) {
        prefs.clear(); // Clear the shared preferences
        ref.watch(screenIndexProvider.notifier).state =
            0; // Reset the screen index
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (c) => const Main()),
            (route) =>
                false); // Navigate to the Main screen and remove all previous screens
      });
    } catch (e) {
      write(e.toString()); // Log the error
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: white,
      ); // Show a toast message
    }
  }
}
