
import 'package:bandhu/constant/strings.dart';

import 'api_response.dart';

class BaseResponseHandler {
  AppBaseStatus? status;
  String? title;
  ApiResponse? apiResponse;
  String? message;

  BaseResponseHandler({
    required this.status,
    required this.message,
    this.apiResponse,
    required this.title,
  });

  static BaseResponseHandler createBaseError(
      ApiResponse apiResponse, snackTitle) {
    if (apiResponse.apiStatus == ApiStatus.error) {
      return BaseResponseHandler(
        status: AppBaseStatus.error,
        apiResponse: apiResponse,
        message: apiResponse.message ?? "",
        title: snackTitle,
      );
    } else if (apiResponse.apiStatus == ApiStatus.networkError) {
      //   print("sd");
      return BaseResponseHandler(
        status: AppBaseStatus.error,
        apiResponse: apiResponse,
        message: Strings.instance.errorNetwork,
        title: snackTitle,
      );
    } else {
      return BaseResponseHandler(
        status: AppBaseStatus.error,
        apiResponse: apiResponse,
        message: Strings.instance.errorUnknownError,
        title: snackTitle,
      );
    }
  }

  static BaseResponseHandler emptyField = BaseResponseHandler(
    status: AppBaseStatus.error,
    message: Strings.instance.errorEmptyFieldsMsg,
    title: Strings.instance.errorEmptyFields,
  );

  static BaseResponseHandler invalidOTp = BaseResponseHandler(
    status: AppBaseStatus.error,
    message: Strings.instance.errorEmptyFieldsMsg,
    title: Strings.instance.errorInvalidFields,
  );

  static BaseResponseHandler smallPassword = BaseResponseHandler(
    status: AppBaseStatus.error,
    message: Strings.instance.errorEmptyFieldsMsg,
    title: Strings.instance.errorSmallPassword,
  );

  static BaseResponseHandler passNotMatchField = BaseResponseHandler(
    status: AppBaseStatus.error,
    message: Strings.instance.passFieldsMsg,
    title: Strings.instance.errorInvalidFields,
  );

  static BaseResponseHandler phoneNOInvalid = BaseResponseHandler(
    status: AppBaseStatus.error,
    message: "Not a valid Phone",
    title: Strings.instance.errorInvalidFields,
  );

  static BaseResponseHandler unKnownError = BaseResponseHandler(
    status: AppBaseStatus.error,
    message: Strings.instance.errorUnknownErrorMsg,
    title: Strings.instance.errorUnknownError,
  );
}

enum AppBaseStatus {
  loading,
  error,
  success,
}

extension BaseStatusExtension on AppBaseStatus {
  bool get isSuccess {
    switch (this) {
      case AppBaseStatus.success:
        return true;
      case AppBaseStatus.loading:
        return false;
      case AppBaseStatus.error:
        return false;
      default:
        return false;
    }
  }
}
