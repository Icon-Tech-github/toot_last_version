import 'package:dio/dio.dart';

import 'package:loz/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';

abstract class FavoriteRepository {

  Future getFav(int page);
  Future favToggle (int id);
}

class FavoriteRepo implements FavoriteRepository {

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
  Future  getFav(int page) async {
    String token = LocalStorage.getData(key: "token");
    var response = await dio.get(ServerConstants.favorite+"?page=$page&paginate=6",
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
  Future favToggle (int id) async{
    String token = LocalStorage.getData(key: "token");
    var _data = {
      "product_id":id
    };
    var response = await dio.post(ServerConstants.favToggle,
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
}
