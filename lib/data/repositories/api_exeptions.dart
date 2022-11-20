




import '../ServerConstants.dart';

class ApiException implements Exception {
  // Variables
  final int code;
  String? message;

  // Fixed Code Messages
  static const String authorizationFailedMsg = "اسم المستخدم و كلمة السر خاطئة";
  static const String invalidDataMsg =
      "البيانات المدخلة خاطئة برجاء اعادة المحاولة";
  static const String noInternetConnectionMsg =
      "برجاء التحقق من اتصالك بالانترنت و معاودة الاتصال";
  static const String unknownErr = "حدث خطأ ما. برجاء المحاولة مجددا";

  ApiException({required this.code, required this.message});

  ApiException.fromApi(this.code, response) {
    if (this.code == 500 && !ServerConstants.IS_DEBUG) {
      // if Production we shouldn't show Server Crashes.!
      this.message = unknownErr;
    } else if (this.code == 400 && !ServerConstants.IS_DEBUG) {
      // if Production we shouldn't show Server Crashes.!
      print('400');
      this.message = 'The password must be at least 6 characters.';
    } else if (response is Map<String, dynamic>) {
      final _modelState = response['msg'].toString();
      if (_modelState != null && _modelState is Map<String, dynamic>) {
        // this.message = (_modelState.values.first as List).first;
      } else {
        this.message = response['data']['validation_errors']['phone'][0] ??
            "".toString() + response['message'] ??
            ''.toString()
        // ??
        // response['error_description'] ??
        // response['error']
            ;
        print(this.message);
      }
    } else {
      this.message = unknownErr;
    }
  }

  @override
  String toString() {
    String _text = "";

    if (!ServerConstants.IS_DEBUG) _text += "($code) ";
    _text += "${message ?? unknownErr}";
    return _text;
  }
}
