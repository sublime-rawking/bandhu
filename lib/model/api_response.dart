import 'base_error_handler.dart';

class ApiResponse<T> {
  ApiStatus apiStatus;
  T? data;
  String? message;
  String? token;
  String? title;

  ApiResponse(
      {required this.apiStatus,
      this.message,
      this.data,
      this.token,
      this.title});
}

enum ApiStatus {
  idle,
  loading,
  error,
  networkError,
  success,
  unknownError,
  unAuthorize,
}

extension ApiResponseStatus on ApiResponse {
  bool get isLoading {
    switch (this.apiStatus) {
      case ApiStatus.loading:
        return true;
      default:
        return false;
    }
  }

  bool get isSuccess {
    switch (this.apiStatus) {
      case ApiStatus.success:
        return true;
      default:
        return false;
    }
  }

  bool get isError {
    switch (this.apiStatus) {
      case ApiStatus.error:
        return true;
      case ApiStatus.networkError:
        return true;
      case ApiStatus.unknownError:
        return true;
      default:
        return false;
    }
  }

  AppBaseStatus get snackBarStatus {
    switch (this.apiStatus) {
      case ApiStatus.error:
        return AppBaseStatus.error;
      case ApiStatus.success:
        return AppBaseStatus.success;
      default:
        return AppBaseStatus.error;
    }
  }
}
