import 'package:dio/dio.dart' as dio;

// server endpoint
// Main Server
//const baseUrl = "http://5.189.156.172/BNI";

// localHost
const baseUrl = "http://192.168.0.153:3000/api/mobile";

class BaseRequest {
  dio.Dio? httpClient;
  Map<String, dynamic>? params;
  var data;
  List<Map<String, dynamic>>? files;
  String url;

  BaseRequest({
    this.params,
    required this.url,
    this.data,
    this.files,
    this.httpClient,
  });

  Uri getRequestUrl() {
    Uri uri = Uri.parse(
      baseUrl + url,
    );
    return params == null ? uri : uri.replace(queryParameters: params);
  }
}

class AppResponseModel<T> {
  String? title;
  String? token;
  T? data;
  String? message;

  AppResponseModel({this.title, this.data, this.message});

  AppResponseModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    token = json['token'];
    data = json['data'];
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['token'] = this.token;
    if (this.data != null) {
      data['data'] = this.data!;
    }
    data['message'] = this.message;
    return data;
  }
}
