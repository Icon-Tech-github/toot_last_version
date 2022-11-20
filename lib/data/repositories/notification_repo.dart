import 'package:dio/dio.dart';

import 'package:loz/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';

abstract class NotificationRepository {

  Future getNotification(int page);
  Future reed (List<int> id);

}

class NotificationRepo implements NotificationRepository {

  var dio = Dio()
    ..interceptors.add(PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ));
  static var  dioStatic = Dio()
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

  static int ?unReadCount;


  @override
  Future  getNotification(int page) async {
    String token = LocalStorage.getData(key: "token");
    var response = await dio.get(ServerConstants.notification+"?page=$page&paginate=5",
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      print(response.data['data']['data']);
      return response.data['data']['data'];
    } else {
      return null;
    }
  }
  @override
  Future reed (List<int> id) async{
    String token = LocalStorage.getData(key: "token");
    var _data = {
      "notifications_ids":id
    };
    var response = await dio.post(ServerConstants.read,
        data: _data,
        options: Options(
          headers:{...apiHeaders,
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
  @override
  static Future  getUnreadCount() async {
    String token = LocalStorage.getData(key: "token");
    var response = await dioStatic.get(ServerConstants.unReadCount,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      print(response.data['data']);
      return response.data['data'];
    } else {
      return null;
    }
  }
}
