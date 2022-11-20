// To parse this JSON data, do
//
//     final trackModel = trackModelFromJson(jsonString);

import 'dart:convert';

import 'package:loz/data/models/attributes_model.dart';

import 'department_model.dart';

TrackModel trackModelFromJson(String str) => TrackModel.fromJson(json.decode(str));

String trackModelToJson(TrackModel data) => json.encode(data.toJson());

class TrackModel {
  TrackModel({
    this.status,
    this.msg,
    this.data,
  });

  bool? status;
  String ?msg;
  TrackData ?data;

  factory TrackModel.fromJson(Map<String, dynamic> json) => TrackModel(
    status: json["status"],
    msg: json["msg"],
    data: TrackData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class TrackData {
  TrackData({
    this.orderId,
    this.statusIds,
    this.lastStatusTitle,
    this.durationTime,
    this.frontBranch
  });

  String? orderId;
  List<int>? statusIds;
  Title ?lastStatusTitle;
  int ? durationTime;
  bool? frontBranch;

  factory TrackData.fromJson(Map<String, dynamic> json) => TrackData(
    orderId: json["order_id"],
    durationTime: json['duration_time'],
    statusIds: List<int>.from(json["status_ids"].map((x) => x)),
    lastStatusTitle: Title.fromJson(json["last_Status_title"]),
    frontBranch: json['frontBranch'],
  );

  Map<String, dynamic> toJson() => {
    'duration_time': durationTime,
    "order_id": orderId,
    "frontBranch": frontBranch,
    "status_ids": List<dynamic>.from(statusIds!.map((x) => x)),
    "last_Status_title": lastStatusTitle,
  };
}
