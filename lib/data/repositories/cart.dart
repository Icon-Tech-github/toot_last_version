import 'package:dio/dio.dart';
import 'package:loz/data/models/coupon_model.dart';
import 'package:loz/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';
import 'api_exeptions.dart';

abstract class CartRepository {

  Future addCoupon (String couponNum);
  Future usePoints ();
}

class CartRepos implements CartRepository {



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
  Future addCoupon (String couponNum) async{
    String token = LocalStorage.getData(key: "token");
    var response = await dio.get(ServerConstants.checkCoupon+'/${couponNum}/1',
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    return response.data;

  }
  @override
  Future usePoints () async{
    String token = LocalStorage.getData(key: "token");
    var response = await dio.get(ServerConstants.useBalance,
        options: Options(
          headers:{...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));


    return response.data;

  }
}
