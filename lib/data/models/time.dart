// To parse this JSON data, do
//
//     final timeModel = timeModelFromJson(jsonString);

import 'dart:convert';

TimeModel timeModelFromJson(String str) => TimeModel.fromJson(json.decode(str));

String timeModelToJson(TimeModel data) => json.encode(data.toJson());

class TimeModel {
  TimeModel({
    this.status,
    this.msg,
    this.data,
  });

  bool ?status;
  String? msg;
  List<TimeData>? data;

  factory TimeModel.fromJson(Map<String, dynamic> json) => TimeModel(
    status: json["status"],
    msg: json["msg"],
    data: List<TimeData>.from(json["data"].map((x) => TimeData.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class TimeData {
  TimeData({
    this.id,
    this.title,
    this.display,
    this.active,
    this.date,
    this.daysTimes,
    this.chosen
  });

  int? id;
  String ?title;
  String ?display;
  int ?active;
  String? date;
  List<DaysTime>? daysTimes;
  bool? chosen;

  factory TimeData.fromJson(Map<String, dynamic> json) => TimeData(
    id: json["id"],
    title: json["title"],
    display: json["display"],
    active: json["active"],
    date:json["date"],
    chosen: json["chosen"]??false,
    daysTimes: List<DaysTime>.from(json["days_times"].map((x) => DaysTime.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "display": display,
    "active": active,
    "date": date,
    "chosen":chosen,
    "days_times": List<dynamic>.from(daysTimes!.map((x) => x.toJson())),
  };
}

class DaysTime {
  DaysTime({
    this.id,
    this.dayId,
    this.fromTime,
    this.toTime,
    this.createdAt,
    this.chosen

  });

  int? id;
  int ?dayId;
  String ?fromTime;
  String ?toTime;
  DateTime ?createdAt;
  bool? chosen;


  factory DaysTime.fromJson(Map<String, dynamic> json) => DaysTime(
    id: json["id"],
    dayId: json["day_id"],
    fromTime: json["from_time"],
    toTime: json["to_time"],
    chosen: json["chosen"]??false,

    createdAt: DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "day_id": dayId,
    "from_time": fromTime,
    "to_time": toTime,
    "chosen":chosen,

    "created_at": createdAt!.toIso8601String(),
  };
}
