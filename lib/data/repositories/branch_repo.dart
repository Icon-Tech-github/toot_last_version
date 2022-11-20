import 'package:loz/data/ServerConstants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

abstract class BranchesRepository {


  Future fetchBranchData(String lat,String long);
}

class GetBranchesRepository implements BranchesRepository {

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



  @override
  Future fetchBranchData(String lat,String long) async{

    var response = await dio.get("${ServerConstants.branches}?lat=$lat&long=$long",
        options: Options(
          headers:{...apiHeaders,
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

 static Future fetchBranchDataStatic(String lat,String long) async{

    var response = await dioStatic.get("${ServerConstants.branches}?lat=$lat&long=$long",
        options: Options(
          headers:{...apiHeaders,
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

}
