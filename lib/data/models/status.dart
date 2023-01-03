// To parse this JSON data, do
//
// final statusModel = statusModelFromJson(jsonString);

import 'dart:convert';

import 'department_model.dart';

StatusModel statusModelFromJson(String str) => StatusModel.fromJson(json.decode(str));

String statusModelToJson(StatusModel data) => json.encode(data.toJson());

class StatusModel {
  StatusModel({
    this.status,
    this.msg,
    this.data,
  });

  bool ?status;
  String? msg;
  List<StatusDataModel>? data;

  factory StatusModel.fromJson(Map<String, dynamic> json) => StatusModel(
    status: json["status"],
    msg: json["msg"],
    data: List<StatusDataModel>.from(json["data"].map((x) => StatusDataModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class StatusDataModel {
  StatusDataModel({
    this.id,
    this.title,
  });

  int ?id;
  Title? title;

  factory StatusDataModel.fromJson(Map<String, dynamic> json) => StatusDataModel(
    id: json["id"],
    title: Title.fromJson(json["title"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
  };
}


