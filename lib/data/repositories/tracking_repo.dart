import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';

abstract class TrackingRepository {

  Future trackOrder(String token, int id);
  Future frontBranch(String token, int id);
  Future getStatus( int orderMethod);
}

class TrackingOrderRepo implements TrackingRepository {

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
  Future trackOrder(String token, int id) async{
    try
    {
      var response = await dio.get(ServerConstants.track+"/$id/track",
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
  Future frontBranch(String token, int id) async{
    try
    {
      var response = await dio.get(ServerConstants.track+"/$id/frontBranch",
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
        return response.data;
      } else {
        return null;
      }
    }
    catch (error){
      return throw error;
    }
  }
  @override
  Future getStatus( int orderMethod) async{
    try
    {
      var response = await dio.get(ServerConstants.availableOrderStatus+"/$orderMethod",
          options: Options(
            headers: {
              ...apiHeaders,
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
