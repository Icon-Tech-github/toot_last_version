// To parse this JSON data, do
//
//     final contactModel = contactModelFromJson(jsonString);

import 'dart:convert';

ContactModel contactModelFromJson(String str) => ContactModel.fromJson(json.decode(str));

String contactModelToJson(ContactModel data) => json.encode(data.toJson());

class ContactModel {
  ContactModel({
    this.status,
    this.msg,
    this.data,
  });

  bool? status;
  String? msg;
  ContactDataModel ?data;

  factory ContactModel.fromJson(Map<String, dynamic> json) => ContactModel(
    status: json["status"],
    msg: json["msg"],
    data: ContactDataModel.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class ContactDataModel {
  ContactDataModel({
    this.phone,
    this.whatsapp,
    this.instagram,
    this.twitter,
  });

  String? phone;
  String ?whatsapp;
  String ?instagram;
  String ?twitter;

  factory ContactDataModel.fromJson(Map<String, dynamic> json) => ContactDataModel(
    phone: json["phone"],
    whatsapp: json["whatsapp"],
    instagram: json["instagram"],
    twitter: json["twitter"],
  );

  Map<String, dynamic> toJson() => {
    "phone": phone,
    "whatsapp": whatsapp,
    "instagram": instagram,
    "twitter": twitter,
  };
}
