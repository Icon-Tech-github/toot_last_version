import 'dart:developer';

import 'package:loz/data/ServerConstants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class OrdersRepository {

  Future fetchOrders(String token,int page);

}

class OrdersRepo implements OrdersRepository {

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
  Future fetchOrders(String token,int page) async{
    try
    {
      var response = await dio.get(ServerConstants.orders+'?page=$page&paginate=5',
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
        return response.data['data']['data'];
      } else {
        return null;
      }
    }
    catch (error){
      return throw error;
    }
  }





}
