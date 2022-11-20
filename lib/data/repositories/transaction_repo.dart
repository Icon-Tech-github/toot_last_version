import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../local_storage.dart';
import '../ServerConstants.dart';

abstract class TransactionRepository {

  Future  getTransactions(int page);
}

class TransactionRepo implements TransactionRepository {

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
  Future  getTransactions(int page) async {

    var response = await dio.get(ServerConstants.transactions+'?page=$page',
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

}
