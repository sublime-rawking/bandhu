import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import '../api/base_api.dart';
import '../model/api_response.dart';
import '../model/request_model.dart';

class ApiServices with BaseApiClass {
  static ApiServices? _instance;
  static ApiServices get instance => _instance ??= ApiServices._();

  dio.Dio dioClient = dio.Dio();

  ApiServices._();

  setToken(String token) {
    dioClient.options.headers["x-access-token"] = token;
  }

  clearClient() {
    dioClient = dio.Dio();
  }

  getRequestData(BaseRequest data) async {
    return await onRequest(
        url: data.getRequestUrl(),
        client: data.httpClient ?? dioClient,
        method: Method.get,
        successResponse: (response) {
          AppResponseModel appRes = AppResponseModel.fromJson(response.data);
          return ApiResponse(
            apiStatus: ApiStatus.success,
            data: appRes.data,
            message: appRes.message ?? "",
            title: appRes.title ?? "",
          );
        });
  }

  deleteRequestData(BaseRequest data) async {
    return await onRequest(
        url: data.getRequestUrl(),
        client: data.httpClient ?? dioClient,
        method: Method.delete,
        successResponse: (response) {
          AppResponseModel appRes = AppResponseModel.fromJson(response.data);
          return ApiResponse(
            apiStatus: ApiStatus.success,
            data: appRes.data,
            message: appRes.message ?? "",
            title: appRes.title ?? "",
          );
        });
  }

  postRequestData(BaseRequest data) async {
    return await onRequest(
        url: data.getRequestUrl(),
        client: data.httpClient ?? dioClient,
        method: Method.post,
        data: data.data,
        successResponse: (response) {
          AppResponseModel appRes = AppResponseModel.fromJson(response.data);
          return ApiResponse(
            apiStatus: ApiStatus.success,
            data: appRes.data,
            message: appRes.message ?? "",
            title: appRes.title ?? "",
          );
        });
  }

  postMultiFormRequestData(BaseRequest data) async {
    var formData = dio.FormData.fromMap(data.data ?? {});
    if (data.files != null && data.files!.isEmpty) {
      formData.files.addAll([
        MapEntry(
            data.files!.first.keys.first,
            await dio.MultipartFile.fromFile(
              data.files!.first.values.first,
              filename: data.files!.first.values.first.split("/").last,
              contentType: MediaType("mime", "jpg"),
            ))
      ]);
    }
    dioClient.options.headers["Content-Type"] = "multipart/form-data";
    return await onRequest(
        url: data.getRequestUrl(),
        client: data.httpClient ?? dioClient,
        method: Method.post,
        data: formData,
        successResponse: (response) {
          dioClient.options.headers["Content-Type"] = "application/json";
          AppResponseModel appRes;
          try {
            appRes = AppResponseModel.fromJson(response.data);
            return ApiResponse(
              apiStatus: ApiStatus.success,
              data: appRes.data,
              message: appRes.message ?? "",
              title: appRes.title ?? "",
            );
          } catch (e) {
            return ApiResponse(
              apiStatus: ApiStatus.success,
              data: response.data,
              message: "",
              title: "",
            );
          }
        });
  }
}
