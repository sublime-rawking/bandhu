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
  Future getUserData({required WidgetRef ref}) async {
    try {
      var response = await dio.get("$baseUrl/Api/getMembersbyID",
          queryParameters: {"id": ref.read(userDataProvider).userid});
      var databody = jsonDecode(response.data);
      write(databody.toString());
      if (databody["success"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user", jsonEncode(databody["MembersbyID"]));
        ref.watch(userDataProvider.notifier).state =
            User.fromMap(databody["MembersbyID"]);
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
    }
  }

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
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user", jsonEncode(databody["login"]));
        ref.watch(userDataProvider.notifier).state =
            User.fromMap(databody["login"]);
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
    }
  }

  Future signIn(
      {required Map<String, dynamic> authData, required WidgetRef ref}) async {
    try {
      var res = await dio.get("$baseUrl/Api/login", queryParameters: authData);
      var databody = jsonDecode(res.data);

      if (databody["success"] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("user", jsonEncode(databody["login"]));
        ref.watch(userDataProvider.notifier).state =
            User.fromMap(databody["login"]);

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

  Future uploadPDF({required String filePath, required WidgetRef ref}) async {
    try {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/Api/updatepdf"),
      );
      request.files.add(await http.MultipartFile.fromPath(
        'DCP',
        filePath,
      ));
      request.fields.addAll({"id": ref.read(userDataProvider).userid});
      http.Response response =
          await http.Response.fromStream(await request.send());
      var databody = jsonDecode(response.body);
      write(databody.toString());
      return databody["success"];
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

  Future logOut({required BuildContext context, required WidgetRef ref}) async {
    try {
      await SharedPreferences.getInstance().then((prefs) {
        prefs.clear();
        ref.watch(screenIndexProvider.notifier).state = 0;
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (c) => const Main()), (route) => false);
      });
    } catch (ex) {
      write(ex.toString());
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
}
