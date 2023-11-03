import 'dart:convert';

import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AskGive {
  final dio = Dio();
  Future<List> getMembers({int id = 0}) async {
    try {
      var res =
          await dio.get("$baseUrl/Api/getMembers", queryParameters: {"id": id});

      var resBody = jsonDecode(res.data.toString());
      write(resBody.toString());
      if (resBody["success"] == true) {
        return resBody["members"];
      }
      return [];
    } catch (e) {
      write(e.toString());
      return [];
    }
  }

  Future<List> getAskGive({required String id}) async {
    try {
      var res = await dio
          .get("$baseUrl/Api/getGive_ask", queryParameters: {"id": id});

      var resBody = jsonDecode(res.data.toString());
      write(resBody.toString());
      if (resBody["success"] == true) {
        return resBody["Give_ask"];
      }
      return [];
    } catch (e) {
      write(e.toString());
      return [];
    }
  }

  Future<bool> addAskGive({required Map<String, dynamic> askGiveData}) async {
    try {
      var formData = FormData.fromMap(askGiveData);
      var res = await dio.post("$baseUrl/Api/give_ask", data: formData);

      var resBody = jsonDecode(res.data.toString());
      write(resBody.toString());
      if (resBody["success"] == true) {
        Fluttertoast.showToast(
          msg: "Added successfully",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: colorPrimary,
          textColor: white,
        );
        return true;
      }
      Fluttertoast.showToast(
        msg: resBody["status"],
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
}
