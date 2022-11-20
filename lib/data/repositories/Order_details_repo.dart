import 'dart:convert';

import 'package:loz/data/ServerConstants.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/models/home_ad_model.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class OrderDetailsRepository {

  Future fetchOrder(String token,int id);

}

class OrderDetailsRepo implements OrderDetailsRepository {

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
  Future fetchOrder(String token,int id ) async{
    try
    {
      var response = await dio.get('${ServerConstants.orders}/$id',
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
