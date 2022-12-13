import 'package:dio/dio.dart';
import 'package:loz/local_storage.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';

abstract class OrderMethodRepository {

  Future fetchOrderMethod();
  Future fetchPaymentMethod();
  Future fetchCars();
  Future fetchAddress();
  makeDefault (int id);
  fetchAddressGift();
  Future addCar({
    String? color,
    String? model,
    String ?number,
  });
  Future addAddress({
    String? title,
    String? long,
    String ?lat,
  });
  Future addAddressGift({
    String? title,
    String? long,
    String ?lat,
  });
  Future editAddress({
    int?id,
    String? title,
    String ? notes,
    String? long,
    String ?lat,
    int ?defaultAddress,
  });
}

class OrderMethodRepo implements OrderMethodRepository {
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
  Future fetchOrderMethod()async {
    var response = await dio.get(ServerConstants.orderMethods,
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
  Future fetchPaymentMethod() async{
    String token =LocalStorage.getData(key: "token");

    var response = await dio.get(ServerConstants.paymentMethods,
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
  Future fetchCars()async {
    String token =LocalStorage.getData(key: "token");

    var response = await dio.get(ServerConstants.cars,
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
  Future fetchAddress() async{
    String token =LocalStorage.getData(key: "token");

    var response = await dio.get(ServerConstants.addresses,
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
  Future fetchAddressGift() async{
    String token =LocalStorage.getData(key: "token");

    var response = await dio.get(ServerConstants.addressesGift,
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
  Future addCar({
    String? color,
    String? model,
    String ?number,
  }) async {
    String token =LocalStorage.getData(key: "token");
    // Json Data
    var _data = {
      "car_model": "$model",
      "plate_number": "$number",
      "car_color": "$color",
    };
    // Http Request

    var _response = await dio.post(ServerConstants.addCar,
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

  @override
  Future addAddress({
    String? title,
    String ? notes,
    String? long,
    String ?lat,
    int ?defaultAddress,
  }) async {
    String token =LocalStorage.getData(key: "token");
    // Json Data
    var _data = {
      "long": "$long",
      "lat": "$lat",
      "title": "$title",
      "notes":"$notes",
      "default":"$defaultAddress"
    };
    // Http Request

    var _response = await dio.post(ServerConstants.addAddress,
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
  @override
  Future editAddress({
    int?id,
    String? title,
    String ? notes,
    String? long,
    String ?lat,
    int ?defaultAddress,
  }) async {
    String token =LocalStorage.getData(key: "token");
    // Json Data
    var _data = {
      "long": "$long",
      "lat": "$lat",
      "title": "$title",
      "notes":"$notes",
      "default":"$defaultAddress"
    };
    // Http Request

    var _response = await dio.post(ServerConstants.editAddress+"/$id",
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
  @override
  Future addAddressGift({
    String? title,
    String ? notes,
    String? long,
    String ?lat,
    int ?defaultAddress,
  }) async {
    String token =LocalStorage.getData(key: "token");
    // Json Data
    var _data = {
      "long": "$long",
      "lat": "$lat",
      "title": "$title",
      "notes":"$notes",
      "default":"$defaultAddress"
    };
    // Http Request

    var _response = await dio.post(ServerConstants.addAddressGift,
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

  @override
  Future makeDefault (int id) async{
    String token = LocalStorage.getData(key: "token");
    var response = await dio.post(ServerConstants.makeDefault+"/$id",
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
