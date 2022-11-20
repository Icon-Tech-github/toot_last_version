import 'package:dio/dio.dart';
import 'package:loz/data/models/attributes_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../local_storage.dart';
import '../ServerConstants.dart';

abstract class SearchRepository {

  Future getProductsSearch(String search ,int page);
  Future favToggle (int id);
}

class SearchRepo implements SearchRepository {

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

  String token = LocalStorage.getData(key: "token")??"";


  @override
  Future  getProductsSearch(String search ,int page) async {

    var response = await dio.get(ServerConstants.filter+'?search=$search&page=$page&paginate=6',
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data['data']['data'];
    } else {
      return response.data['data'];
    }
  }
  @override
  Future favToggle (int id) async{
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
