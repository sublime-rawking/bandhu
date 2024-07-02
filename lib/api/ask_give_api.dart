import 'dart:convert';
import 'package:bandhu/theme/theme.dart';
import 'package:bandhu/utils/log.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constant/api_urls.dart';
import '../constant/strings.dart';
import '../model/api_response.dart';
import '../model/request_model.dart';
import '../provider/api_service.dart';

class AskGive {
  final dio = Dio();

  /// Get members based on search query.
  Future<List> getMembers({String search = ""}) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request =
          BaseRequest(url: ApiUrls.getAllUser, params: {"name": search});
      apiResponse = await ApiServices.instance.getRequestData(request);
      write(apiResponse.data.toString());
      if (apiResponse.isSuccess) {
        return apiResponse.data;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return [];
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
      return [];
    }
  }

  /// Get AskGive data for a specific month and week.
  Future<List> getAskGiveByMonth({String? id, required String month}) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request =
          BaseRequest(url: ApiUrls.calender, params: {
            if(id!=null && id.toString()!="null") "id": id,
            "date": month});
      apiResponse = await ApiServices.instance.getRequestData(request);
      write(apiResponse.data.toString());
      if (apiResponse.isSuccess) {
        return apiResponse.data;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return [];
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
      return [];
    }
  }

  /// Get AskGive data for a specific id and month.
  Future<List> getAskGive({ String? id, required String month}) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request = BaseRequest(
          url: ApiUrls.giveAndAsk, params: {
        if(id!=null && id.toString()!="null") "id": id,
        "date": month});
      apiResponse = await ApiServices.instance.getRequestData(request);
      write(apiResponse.data.toString());
      if (apiResponse.isSuccess) {
        return apiResponse.data;
      } else {
        Strings.instance.getToast(msg: apiResponse.message ?? "");
        return [];
      }
    } catch (e) {
      Strings.instance
          .getToast(msg: apiResponse.message ?? "Something went wrong");
      write(e.toString());
      return [];
    }
  }

  /// Add AskGive data.
  Future<bool> addAskGive({required Map<String, dynamic> askGiveData}) async {
    ApiResponse apiResponse = ApiResponse(apiStatus: ApiStatus.idle);
    try {
      BaseRequest request = BaseRequest(
        url: ApiUrls.giveAndAsk,
        data: askGiveData,
      );
      apiResponse = await ApiServices.instance.postRequestData(request);
      write(apiResponse.data.toString());
      if (apiResponse.isSuccess) {
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
