// To parse this JSON data, do
//
//     final branchModel = branchModelFromJson(jsonString);

import 'dart:convert';

import 'department_model.dart';

List<BranchModel> branchModelFromJson(String str) => List<BranchModel>.from(json.decode(str).map((x) => BranchModel.fromJson(x)));

String branchModelToJson(List<BranchModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BranchModel {
  BranchModel({
    this.id,
    this.title,
    this.phone,
    this.address,
    this.isActive,
    this.image,
    this.lat,
    this.long,
    this.morningTimeFrom,
    this.morningTimeTo,
    this.eveningTimeFrom,
    this.eveningTimeTo,
    this.busyAt,
    this.busyHours,
    this.popupCategoryId,
    this.popupProductId,
    this.popupPhoto,
    this.showPopup,
    this.createdAt,
    this.updatedAt,
    this.statusEn,
    this.distance,
    this.statusAr,
    this.statusNo,
    this.rate,
    this.popupCategoryTitle
  });

  int ? id;
  Title? title;
  Title ?popupCategoryTitle;
  String ?phone;
  String ?address;
  int ?isActive;
  String ?distance;
  dynamic image;
  dynamic lat;
  dynamic long;
  dynamic morningTimeFrom;
  dynamic morningTimeTo;
  dynamic eveningTimeFrom;
  dynamic eveningTimeTo;
  dynamic busyAt;
  dynamic busyHours;
  int? popupCategoryId;
  int ?popupProductId;
  dynamic popupPhoto;
  int ?showPopup;
  String ?createdAt;
  String ?updatedAt;
  String ?statusEn;
  String ?statusAr;
  int ?statusNo;
  int ?rate;

  factory BranchModel.fromJson(Map<String, dynamic> json) => BranchModel(
    id: json["id"],
    title: Title.fromJson(json["title"]),
    popupCategoryTitle: Title.fromJson(json['popup_category_title']),
    phone: json["phone"],
    address: json["address"],
    isActive: json["is_active"],
    image: json["image"],
    lat: json["lat"],
    long: json["long"],
    morningTimeFrom: json["morning_time_from"],
    morningTimeTo: json["morning_time_to"],
    eveningTimeFrom: json["evening_time_from"],
    eveningTimeTo: json["evening_time_to"],
    busyAt: json["busy_at"],
    distance:json['distance'] == null? json['distance'] : json['distance'].toStringAsFixed(1),
    busyHours: json["busy_hours"],
    popupCategoryId: json["popup_category_id"],
    popupProductId: json["popup_product_id"],
    popupPhoto: json["popup_photo"],
    showPopup: json["show_popup"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    statusEn: json["status_en"],
    statusAr: json["status_ar"],
    statusNo: json["status_no"],
    rate: json["rate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
    "phone": phone,
    "address": address,
    "is_active": isActive,
    "image": image,
    "lat": lat,
    "long": long,
    "popup_category_title":popupCategoryTitle,
    "morning_time_from": morningTimeFrom,
    "morning_time_to": morningTimeTo,
    "evening_time_from": eveningTimeFrom,
    "evening_time_to": eveningTimeTo,
    "busy_at": busyAt,
    "busy_hours": busyHours,
    "popup_category_id": popupCategoryId,
    "popup_product_id": popupProductId,
    "popup_photo": popupPhoto,
    "show_popup": showPopup,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "status_en": statusEn,
    "status_ar": statusAr,
    "status_no": statusNo,
    "rate": rate,
  };
}


