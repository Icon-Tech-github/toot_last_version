import 'package:dio/dio.dart';
import 'package:loz/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';


abstract class SingleProductRepository {

  Future fetchProduct(int productId);
  Future favToggle (int id);
}

class SingleProductRepo implements SingleProductRepository {
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
  Future  fetchProduct(int productId) async {
    var response = await dio.get(ServerConstants.API+'/product/$productId/details',
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {
      return response.data['data'];
    } else {
      // print("object");
      return response.data['data'][0];
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
