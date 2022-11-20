import 'package:dio/dio.dart';
import 'package:loz/data/models/user_model.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';
import 'api_exeptions.dart';

abstract class ConfirmRepository {
  Future confirm({Map? map,String ,token});
}

class ConfirmRepo implements ConfirmRepository {
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
  Future confirm({Map? map,String ,token}) async {
    var _data = map!;
    // Http Request
    var _response = await dio.post(ServerConstants.confirm,
        data: _data,
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