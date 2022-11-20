import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';

abstract class PointsRepository {

  Future getPoints(String token);
  Future convertPoints(String token);
 Future sendBalance(String token,String phone,String balance);
}

class PointsRepo implements PointsRepository {

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
  Future getPoints(String token) async{
    try
    {
      var response = await dio.get(ServerConstants.points,
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
  @override
  Future convertPoints(String token) async{
    try
    {
      var response = await dio.post(ServerConstants.covertPoints,
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
        return response.data['status'];
      } else {
        return null;
      }
    }
    catch (error){
      return throw error;
    }
  }
  @override
  Future sendBalance(String token,String phone,String balance) async{
    try
    {
      var _data = {
        "to_client": "$phone",
        "amount": "$balance",
      };
      var response = await dio.post(ServerConstants.sendBalance,
          data: _data,
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
        return "200";
      }  else if (response.statusCode == 406) {
        return "406";
      }else if (response.statusCode == 404) {
        return "404";
      }
      else {
        return null;
      }
    }
    catch (error){
      return throw error;
    }
  }
}
