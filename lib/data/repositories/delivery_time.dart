import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';

abstract class DeliveryTimeRepository {

  Future getTime(String token);
}
class DeliveryTimeRepo implements DeliveryTimeRepository {

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
  Future getTime(String token) async{
    try
    {
      var response = await dio.get(ServerConstants.days,
          options: Options(
            headers: {
              ...apiHeaders,
              'Authorization': '$token',
            },
            validateStatus: (status) {
              return status! < 500;
            },
          ));
      if (ServerConstants.isValidResponse(response.statusCode!)) {
        return response.data['data'];
      } else {
        return null;
      }
    }
    catch (error){
      return throw error;
    }
  }

}
