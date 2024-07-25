import 'package:bandhu/constant/api_urls.dart';
import 'package:bandhu/main.dart';
import 'package:bandhu/model/api_response.dart';
import 'package:bandhu/model/request_model.dart';
import 'package:bandhu/model/user_model.dart';
import 'package:bandhu/provider/api_service.dart';
import 'package:bandhu/provider/auth_services.dart';
import 'package:bandhu/utils/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constant/strings.dart';
import '../constant/variables.dart';

class Auth {
  static Auth? _instance;

  Auth._();

  static Auth get instance => _instance ??= Auth._();

  Future signUp({
    required Map<String, String> userData,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request = BaseRequest(
          url: ApiUrls.authUrl,
          data: userData,
          files:( userData["profile_image"] != null && userData["profile_image"] != "")
              ? [
                  {"profile_image": userData["profile_image"]}
                ]
              : []);
      apiResponse =
          await ApiServices.instance.postMultiFormRequestData(request);
      if (apiResponse.isSuccess) {
        User user = User.fromJson(apiResponse.data);
        await AuthServices.instance.setToken(user, ref);
        return true;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return false;
      }
    } catch (e) {
      print(e);
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
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
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request = BaseRequest(url: ApiUrls.authUrl, params: authData);
      apiResponse = await ApiServices.instance.getRequestData(request);
      if (apiResponse.isSuccess) {
        User user = User.fromJson(apiResponse.data);
        await AuthServices.instance.setToken(user, ref);
        return true;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return false;
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
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
  Future uploadPDF(
      {required String filePath,
      required WidgetRef ref,
      sendProgress,
      context}) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request = BaseRequest(url: ApiUrls.updatePdf, files: [
        {"dcp": filePath}
      ]);
      apiResponse = await ApiServices.instance
          .postMultiFormRequestData(request, sendProgress: sendProgress);
      if (apiResponse.isSuccess) {
        await Auth.instance.getUserData(
          ref: ref,
        );
        return true;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return false;
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
      return false;
    }
  }

  /// Sends a password reset request for the given [email].
  ///
  /// Returns `true` if the request was successful, otherwise `false`.
  Future<bool> forgetPassword(
      {required String email, required WidgetRef ref}) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request =
          BaseRequest(url: ApiUrls.forgotPassword, data: {"email": email});
      apiResponse = await ApiServices.instance.postRequestData(request);
      if (apiResponse.isSuccess) {
        User user = User.fromJson(apiResponse.data);
        await AuthServices.instance.setToken(user, ref);
        return true;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return false;
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
      return false;
    }
  }

  /// This method verifies the OTP for a given email and password.
  /// It makes a POST request to the API endpoint "/Api/verificationotp" with the provided parameters.
  /// Returns a boolean indicating whether the verification was successful or not.
  Future verifyOTP(
      {required String email,
      required String otp,
      required String password,
      required WidgetRef ref}) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request = BaseRequest(
          url: ApiUrls.verifyOtp,
          data: {"email": email, "otp": otp, "password": password});
      apiResponse = await ApiServices.instance.postRequestData(request);
      if (apiResponse.isSuccess) {
        User user = User.fromJson(apiResponse.data);
        await AuthServices.instance.setToken(user, ref);
        return true;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return false;
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
      return false;
    }
  }

  Future updateUser({
    required Map<String, dynamic> userData,
    required WidgetRef ref,
    required BuildContext context,
  }) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request =
          BaseRequest(url: ApiUrls.user, data: userData, files: [
        {"profile_image": userData["Profile"]}
      ]);
      apiResponse =
          await ApiServices.instance.putMultiFormRequestData(request);
      if (apiResponse.isSuccess) {
        User user = User.fromJson(apiResponse.data);
        await AuthServices.instance.setToken(user, ref);
        return true;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return false;
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
    }
  }

  /// Logs out the user and clears the shared preferences.
  ///
  /// Parameters:
  /// - `context`: The build context.
  /// - `ref`: The widget reference.
  Future logOut({required BuildContext context, required WidgetRef ref}) async {
    try {
      bool isSucces = await AuthServices.instance.removeToken(ref);
      print(isSucces);
      if (isSucces) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (c) => const Main()),
            (route) =>
                false); //} Navigate to the Main screen and remove all previous screens
      }
    } catch (e) {
      write(e.toString()); // Log the error
      Strings.instance.getToast(msg: "Something went wrong");
    }
  }

  getUserData({required WidgetRef ref}) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request = BaseRequest(
        url: ApiUrls.user,
      );
      apiResponse = await ApiServices.instance.getRequestData(request);
      if (apiResponse.isSuccess) {
        User user = User.fromJson(apiResponse.data);
        user.token =
            ApiServices.instance.dioClient.options.headers["x-access-token"];
        ref.watch(AuthServices.instance.userDataProvider.notifier).state = user;
        return true;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return false;
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
      return false;
    }
  }
}
