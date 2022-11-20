import '../../local_storage.dart';

class UserModel {
  UserModel({
     this.status,
     this.msg,
     this.data,
  });
  bool ?status;
  String? msg;
  Data? data;

  UserModel.fromJson(Map<String, dynamic> json){
    status = json['status'];
    msg = json['msg'];
    data = Data.fromJson(json['data']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['status'] = status;
    _data['msg'] = msg;
    _data['data'] = data!.toJson();
    return _data;
  }
}

class Data {
  Data({
     this.accessToken,
     this.tokenType,
     this.expiresIn,
     this.client,
  });
 String ?accessToken;
 String ?tokenType;
 int ?expiresIn;
 Client? client;

  Data.fromJson(Map<String, dynamic> json){
    accessToken = json['access_token'];
    if (json['access_token'] != null)
      LocalStorage.saveData(key: 'token', value: ("Bearer ${json['access_token']}"));
    tokenType = json['token_type'];
    expiresIn = json['expires_in'];
    if (json['client'] != null)  client = Client.fromJson(json['client']);
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['access_token'] = accessToken;
    _data['token_type'] = tokenType;
    _data['expires_in'] = expiresIn;
    _data['client'] = client!.toJson();
    return _data;
  }
}

class Client {
  Client({
     this.id,
     this.name,
     this.phone,
     this.isActive,
    this.image,
     this.balance,
    this.verifyCode,
     this.createdAt,
     this.updatedAt,
  });
 int? id;
 String ?name;
 String ?phone;
 int ?isActive;
 dynamic image;
 int ?balance;
 dynamic verifyCode;
 String? createdAt;
 String ?updatedAt;

  Client.fromJson(Map<String, dynamic> json){
    id = json['id'];
    if (json['id'] != null)
      LocalStorage.saveData(key: 'id', value: ("${json['id']}"));
    name = json['name'];
    if (json['name'] != null)
      LocalStorage.saveData(key: 'userName', value: ("${json['name']}"));
    phone = json['phone'];
    if (json['phone'] != null)
      LocalStorage.saveData(key: 'phone', value: ("${json['phone']}"));
    isActive = json['is_active'];
    image = null;
    balance = json['balance'];
    verifyCode = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['phone'] = phone;
    _data['is_active'] = isActive;
    _data['image'] = image;
    _data['balance'] = balance;
    _data['verify_code'] = verifyCode;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    return _data;
  }
}