// To parse this JSON data, do
//
//     final couponModel = couponModelFromJson(jsonString);

import 'dart:convert';

CouponModel couponModelFromJson(String str) => CouponModel.fromJson(json.decode(str));

String couponModelToJson(CouponModel data) => json.encode(data.toJson());

class CouponModel {
  CouponModel({
    this.status,
    this.msg,
    this.data,
  });

  bool ?status;
  String? msg;
  Data ?data;

  factory CouponModel.fromJson(Map<String, dynamic> json) => CouponModel(
    status: json["status"],
    msg: json["msg"],
    data:json["data"]!= null? Data.fromJson(json["data"]): null,
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.id,
    this.code,
    this.isActive,
    this.numOfUses,
    this.counter,
    this.type,
    this.value,
    this.limit,
    this.dateFrom,
    this.dateTo,
    this.timeFrom,
    this.timeTo,
    this.createdAt,
    this.updatedAt,
  });

  int ?id;
  String ?code;
  int ?isActive;
  int ?numOfUses;
  int ?counter;
  int ?type;
  dynamic ?value;
  dynamic ?limit;
  dynamic dateFrom;
  dynamic dateTo;
  dynamic timeFrom;
  dynamic timeTo;
  String ?createdAt;
  String ?updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    code: json["code"],
    isActive: json["is_active"],
    numOfUses: json["num_of_uses"],
    counter: json["counter"],
    type: json["type"],
    value: double.parse(json["value"].toString()),
    limit:  double.parse(json["limit"].toString()),
    dateFrom: json["date_from"],
    dateTo: json["date_to"],
    timeFrom: json["time_from"],
    timeTo: json["time_to"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "is_active": isActive,
    "num_of_uses": numOfUses,
    "counter": counter,
    "type": type,
    "value": value,
    "limit": limit,
    "date_from": dateFrom,
    "date_to": dateTo,
    "time_from": timeFrom,
    "time_to": timeTo,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
