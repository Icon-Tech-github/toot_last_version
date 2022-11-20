
import 'package:loz/data/ServerConstants.dart';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class AboutRepository {

  Future fetchAbout(String lang );

}

class AboutRepo implements AboutRepository {

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
  Future fetchAbout(String lang ) async{
    try
    {
      var response = await dio.get('${ServerConstants.about}/$lang',
          options: Options(
            headers: {
              ...apiHeaders,
            },
            validateStatus: (status) {
              return status! < 500;
            },
          ));
      if (ServerConstants.isValidResponse(response.statusCode!)) {
        return response.data;
      } else {
        return null;
      }
    }
    catch (error){
      return throw error;
    }
  }





}
