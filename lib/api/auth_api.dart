import 'dart:convert';
import 'dart:developer';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/screens/authscreen/login.dart';
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
  Future signUp(
      {required Map<String, String> userData, required WidgetRef ref}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/Api/signup"),
      );
      request.fields.addAll(userData);

      if (userData["Profile"].toString() != "") {
        request.files.add(await http.MultipartFile.fromPath(
          'Profile',
          userData["Profile"].toString(),
        ));
      }
      // var res = await request.send();
      http.Response response =
          await http.Response.fromStream(await request.send());
      var databody = jsonDecode(response.body);

      if (databody["success"] == true) {
        return true;
      } else {
        Fluttertoast.showToast(
          msg: databody["status"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimary,
          textColor: Colors.white,
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
        textColor: Colors.white,
      );
    }
  }

  Future signIn(
      {required Map<String, dynamic> authData, required WidgetRef ref}) async {
    try {
      var res = await dio.get("$baseUrl/Api/login", queryParameters: authData);
      var resData = jsonDecode(res.data);
      log(resData.toString());
      log(resData["success"].toString());
      if (resData["success"] == true) {
        return true;
      } else {
        Fluttertoast.showToast(
          msg: resData["status"],
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimary,
          textColor: Colors.white,
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
        textColor: Colors.white,
      );
      return false;
    }
  }

  Future logOut({required BuildContext context}) async {
    try {
      await SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (c) => const LoginScreen()),
            (route) => false);
      });
    } catch (ex) {
      write(ex.toString());
      Fluttertoast.showToast(
        msg: "Something went wrong",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: colorPrimary,
        textColor: Colors.white,
      );
    }
  }
}
