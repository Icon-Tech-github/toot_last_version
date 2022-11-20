import 'package:dio/dio.dart';
import 'package:loz/data/models/user_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';
import 'api_exeptions.dart';

abstract class AuthRepository {
  Future changeLang(String ?token);
  Future verifyForgetPassword({
    String? phone,
    String ?otp,
  });
  Future newPassword({
    String? phone,
    String ?password,
  });
  Future forgetPassword({
    String? phone,
  });
  Future logout(String ?token);
  Future login({String phone, String password});
  Future signUp({ String name,
    String phone,
    String password,});
  Future<UserModel?> verify({
    String? phone,
    String ?otp,
  });
  Future statics(String ?token);
}

class AuthRepo implements AuthRepository {
  var dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));

  //
  static Map<String, String> apiHeaders = {
    "Content-Type": "application/json",
    "X-Requested-With": "XMLHttpRequest",
    "Content-Language": "en",
  };
@override
  Future login({String ?phone, String ?password,String ? fcmToken,String ?lang}) async {
    var _data = {
      "phone": "$phone",
      "password": "$password",
      "fcm_token":"$fcmToken",
      "lang":"$lang"
    };
    print('login start');
    // Http Request
    var _response = await dio.post(ServerConstants.login,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
    final  user = UserModel.fromJson(_response.data);
      return user;
    } else if (_response.statusCode == 307) {
      return "307";
    }else if (_response.statusCode == 401) {
      return "401";
    }else if (_response.statusCode == 422) {
      return "422";
    }
    else{
      return null;
    }
  }
  @override
  Future signUp({
    String? name,
    String? phone,
    String ?password,

  }) async {
    // Json Data
    var _data = {
      "phone": "$phone",
      "password": "$password",
      "name": "$name",

    };
    print('sign up start');
    // Http Request

    var _response = await dio.post(ServerConstants.SIGNUP,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
    var  user = UserModel.fromJson(_response.data);
      return user;
    } else if (_response.statusCode == 422) {
      return "422";
    }
    else {
    return null;
    }
  }
  @override
  Future<UserModel?> verify({
    String? phone,
    String ?otp,
    String ? fcmToken,
    String ?lang
  }) async {
    // Json Data
    var _data = {
      "phone": "$phone",
      "otp": "$otp",
      "fcm_token":"$fcmToken",
      "lang":'$lang'
    };

    var _response = await dio.post(ServerConstants.verify,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      var  user = UserModel.fromJson(_response.data);
      return user;
    } else {
      return null;
    }
  }

  @override
  Future forgetPassword({
    String? phone,
  }) async {
    // Json Data
    var _data = {
      "phone": "$phone",
    };

    var _response = await dio.post(ServerConstants.forgetPassword,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
    //  var  user = UserModel.fromJson(_response.data);
      return _response.data;
    } else {
      return null;
    }
  }

  @override
  Future verifyForgetPassword({
    String? phone,
    String ?otp,
  }) async {
    // Json Data
    var _data = {
      "phone": "$phone",
      "otp": "$otp",
    };

    var _response = await dio.post(ServerConstants.verifyForgetPass,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      //  var  user = UserModel.fromJson(_response.data);
      return _response.data;
    } else {
      return null;
    }
  }

  @override
  Future newPassword({
    String? phone,
    String ?password,
  }) async {
    // Json Data
    var _data = {
      "phone": "$phone",
      "password": "$password",
    };

    var _response = await dio.post(ServerConstants.newPassword,
        data: _data,
        options: Options(
          headers: {...apiHeaders
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      //  var  user = UserModel.fromJson(_response.data);
      print(_response.data['status']);
      return _response.data['status'];
    } else {
      return null;
    }
  }

  @override
  Future logout(String ?token) async {
    var _response = await dio.post(ServerConstants.logout,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data;
    } else {
      return null;
    }
  }
  @override
  Future statics(String ?token) async {
    var _response = await dio.post(ServerConstants.statics,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data['data'];
    } else {
      return null;
    }
  }
  @override
  Future deleteAcount(String ?token) async {
    var _response = await dio.post(ServerConstants.deActivate,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data;
    } else {
      return null;
    }
  }

  @override
  Future changeLang(String ?token) async {
    var _response = await dio.post(ServerConstants.lang,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data;
    } else {
      return null;
    }
  }
}