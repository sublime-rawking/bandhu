import 'dart:convert';
import 'package:bandhu/constant/variables.dart';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AskGive {
  final dio = Dio();
  Future<List> getMembers({String search = ""}) async {
    try {
      var res = await dio
          .get("$baseUrl/Api/getMembers", queryParameters: {"name": search});

      var databody = jsonDecode(res.data.toString());
      write(databody.toString());
      if (databody["success"] == true) {
        return databody["members"];
      }
      return [];
    } catch (e) {
      write(e.toString());
      return [];
    }
  }

  Future<List> getAskGiveByMonth(
      {required String id, required String month, required int week}) async {
    try {
      write("$id $month");
      var res = await dio.get("$baseUrl/Api/giveaskdata",
          queryParameters: {"id": id, "date": month, "week": week});

      var databody = jsonDecode(res.data.toString());
      write(databody.toString());
      if (databody["success"] == true) {
        return databody["data"];
      }
      return [];
    } catch (e) {
      write(e.toString());
      return [];
    }
  }

  Future<List> getAskGive({required String id, required String month}) async {
    try {
      var res = await dio.get("$baseUrl/Api/getGive_ask",
          queryParameters: {"id": id, "date": month});

      var databody = jsonDecode(res.data.toString());
      write(databody.toString());
      if (databody["success"] == true) {
        return databody["Give_ask"];
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

      var databody = jsonDecode(res.data.toString());
      write(databody.toString());
      if (databody["success"] == true) {
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
        msg: databody["status"],
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
