

// To parse this JSON data, do
//
//     final homeSiliderModel = homeSiliderModelFromJson(jsonString);

import 'dart:convert';

HomeSliderModel homeSliderModelFromJson(String str) => HomeSliderModel.fromJson(json.decode(str));

String homeSliderModelToJson(HomeSliderModel data) => json.encode(data.toJson());

class HomeSliderModel {
 HomeSliderModel({
  this.status,
  this.msg,
  this.data,
 });

 bool? status;
 String? msg;
 List<HomeAdModel>? data;

 factory HomeSliderModel.fromJson(Map<String, dynamic> json) => HomeSliderModel(
  status: json["status"],
  msg: json["msg"],
  data: List<HomeAdModel>.from(json["data"].map((x) => HomeAdModel.fromJson(x))),
 );

 Map<String, dynamic> toJson() => {
  "status": status,
  "msg": msg,
  "data": List<dynamic>.from(data!.map((x) => x.toJson())),
 };
}

class HomeAdModel {
 HomeAdModel({
  this.id,
  this.inFavourite,
  this.image,
 });

 int? id;
 int ?inFavourite;
 String ?image;

 factory HomeAdModel.fromJson(Map<String, dynamic> json) => HomeAdModel(
  id: json["id"],
  inFavourite: json["in_favourite"],
  image:json['slider_image'],
 );

 Map<String, dynamic> toJson() => {
  "id": id,
  "in_favourite": inFavourite,
  "slider_image": image,
 };
}


