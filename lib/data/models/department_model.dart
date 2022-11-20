// To parse this JSON data, do
//
//     final departmentModel = departmentModelFromJson(jsonString);

import 'dart:convert';

import 'package:loz/local_storage.dart';

DepartmentModel departmentModelFromJson(String str) => DepartmentModel.fromJson(json.decode(str));

String departmentModelToJson(DepartmentModel data) => json.encode(data.toJson());

class DepartmentModel {
  DepartmentModel({
    this.status,
    this.msg,
    this.data,
  });

  bool ?status;
  String? msg;
  List<CategoryModel> ?data;

  factory DepartmentModel.fromJson(Map<String, dynamic> json) => DepartmentModel(
    status: json["status"],
    msg: json["msg"],
    data: List<CategoryModel>.from(json["data"].map((x) => CategoryModel.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class CategoryModel {
  CategoryModel({
    this.id,
    this.title,
    this.isActive,
    this.image,
    this.order,
    this.createdAt,
    this.updatedAt,
  });

  int ?id;
  Title? title;
  int ?isActive;
  dynamic image;
  int? order;
  String? createdAt;
  String ?updatedAt;

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
    id: json["id"],
    title: Title.fromJson(json["title"]),
    isActive: json["is_active"],
    image: json["image"],
    order: json["order"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
    "is_active": isActive,
    "image": image,
    "order": order,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

class Title {
  Title({
    this.en,
    this.ar,
  });

  String ?en;
  String? ar;

  factory Title.fromJson(Map<String, dynamic> json) => Title(
    en: LocalStorage.getData(key: "lang") == 'en' || LocalStorage.getData(key: "lang") == null? json["en"]: json["ar"],
    ar: json["ar"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "ar": ar,
  };
}
