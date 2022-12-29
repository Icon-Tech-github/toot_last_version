import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../ServerConstants.dart';

abstract class ContactRepository {
  Future contactUs({String ?phone, String ?email,String ?message});
  Future fetchContacts();
}

class ContactRepo implements ContactRepository {
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
  Future contactUs({String ?phone, String ?email,String ?message}) async {
    var _data = {
      "phone": "$phone",
      "email": "$email",
      "message":"$message"
    };

    var _response = await dio.post(ServerConstants.contactUs,
        data: _data,
        options: Options(
          headers: {...apiHeaders
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
  Future fetchContacts() async{
    try
    {
      var response = await dio.get('${ServerConstants.contactData}',
          options: Options(
            headers: {
              ...apiHeaders,
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
    catch (error){
      return throw error;
    }
  }

}