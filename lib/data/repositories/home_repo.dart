import 'package:loz/data/ServerConstants.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../local_storage.dart';

abstract class HomeRepository {

  Future fetchAds();
  Future fetchDepartments(int page);
  Future fetchRecommendation();
  Future fetchDepartmentsWithoutPagination(int page) ;
  Future favToggle (int id);
}

class GetHomeRepository implements HomeRepository {

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
  Future fetchAds() async{

    var response = await dio.get(ServerConstants.slider,
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

  @override
  Future fetchDepartments(int page) async{

    var response = await dio.get("${ServerConstants.API}/categories/all?paginate=6&page=$page",
        options: Options(
          headers:{...apiHeaders,
          },
          validateStatus: (status) {
            return status! < 500;
          },
        ));
    if (ServerConstants.isValidResponse(response.statusCode!)) {

         return response.data['data']['data'];
    } else {
      return null;
    }
  }
  @override
  Future fetchDepartmentsWithoutPagination(int page) async{

    var response = await dio.get("${ServerConstants.API}/categories/all",
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
      return response.data['data'];
    }
  }
  @override
  Future fetchRecommendation() async{

    var response = await dio.get(ServerConstants.recommend,
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
      return null;
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
