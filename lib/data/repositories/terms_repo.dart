
import 'package:loz/data/ServerConstants.dart';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class TermsRepository {

  Future fetchTerms(String lang );

}

class TermsRepo implements TermsRepository {

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
  Future fetchTerms(String lang ) async{
    try
    {
      var response = await dio.get('${ServerConstants.terms}/$lang',
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
