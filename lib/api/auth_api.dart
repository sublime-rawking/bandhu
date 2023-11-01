import 'dart:convert';
import 'package:bandhu/constant/variables.dart';
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
  Future signUp(
      {required Map<String, String> userData, required WidgetRef ref}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/auth/signup"),
      );
      request.fields.addAll(userData);

      if (userData["image"].toString() != "") {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          userData["image"].toString(),
        ));
      }
      // var res = await request.send();
      http.Response response =
          await http.Response.fromStream(await request.send());

      var databody = jsonDecode(response.body);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      write(databody.toString());
      if (databody["success"] == true) {
        final responesData = databody["data"];
        prefs.setString("token", jsonEncode(responesData["token"]));
        prefs.setString("user", jsonEncode(responesData["user"]));
        ref.watch(userDataProvider.notifier).state =
            User.fromMap(responesData["user"]);

        return true;
      } else {
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

  Future signIn({required Map authData, required WidgetRef ref}) async {
    try {
      var res = await dio.post("$baseUrl/auth/signin", data: authData);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (res.data["success"] == true) {
        write(res.data["data"].toString());
        final responesData = res.data["data"];
        prefs.setString("token", jsonEncode(responesData["token"]));
        prefs.setString("user", jsonEncode(responesData["user"]));
        ref.watch(userDataProvider.notifier).state =
            User.fromMap(responesData["user"]);

        return true;
      } else {
        Fluttertoast.showToast(
          msg: res.data["message"],
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
}
