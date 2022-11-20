import 'package:dio/dio.dart';
import 'package:loz/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';

abstract class RatingRepository {
  Future rateOrder({
    String? foodRate,
    String? restaurantRate,
    String ?comment,
    String ?orderId
  });
}

class RatingRepo implements RatingRepository {
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
  Future rateOrder({
    String? foodRate,
    String? restaurantRate,
    String ?comment,
    String ?orderId
  }) async {
    String token =LocalStorage.getData(key: "token");
    // Json Data
    var _data = {
      "branch_id": LocalStorage.getData(key: "branchId").toString(),
      "order_id": "$orderId",
      "branch_rate": "$restaurantRate",
      "order_rate": "$foodRate",
      "comment": "$comment",
    };
    // Http Request

    var _response = await dio.post(ServerConstants.rate,
        data: _data,
        options: Options(
          headers: {...apiHeaders,
            'Authorization': '$token',
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));

    print("${_response.data}");

    if (ServerConstants.isValidResponse(_response.statusCode!)) {
      return _response.data;
    } else {
      return null;
    }
  }


}
