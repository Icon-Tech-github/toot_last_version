// To parse this JSON data, do
//
//     final pointsModel = pointsModelFromJson(jsonString);

import 'dart:convert';

PointsModel pointsModelFromJson(String str) => PointsModel.fromJson(json.decode(str));

String pointsModelToJson(PointsModel data) => json.encode(data.toJson());

class PointsModel {
  PointsModel({
    this.status,
    this.msg,
    this.data,
  });

  bool? status;
  String? msg;
  PointsData ?data;

  factory PointsModel.fromJson(Map<String, dynamic> json) => PointsModel(
    status: json["status"],
    msg: json["msg"],
    data: PointsData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class PointsData {
  PointsData({
    this.limit,
    this.balance,
    this.pointsSum,
    this.points,
  });

  String ?limit;
  double ?balance;
  int ?pointsSum;
  List<Point> ?points;

  factory PointsData.fromJson(Map<String, dynamic> json) => PointsData(
    limit: json["limit"],
    balance:double.parse(json["balance"].toString()),
    pointsSum: int.parse(json["points_sum"].toString()),
    points: List<Point>.from(json["points"].map((x) => Point.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "limit": limit,
    "balance": balance,
    "points_sum": pointsSum,
    "points": List<dynamic>.from(points!.map((x) => x.toJson())),
  };
}

class Point {
  Point({
    this.id,
    this.clientId,
    this.orderId,
    this.points,
    this.isConverted,
    this.createdAt,
  });

  int ?id;
  int ?clientId;
  int ?orderId;
  int ?points;
  int ?isConverted;
  String ?createdAt;

  factory Point.fromJson(Map<String, dynamic> json) => Point(
    id: json["id"],
    clientId: json["client_id"],
    orderId: json["order_id"],
    points: json["points"],
    isConverted: json["is_converted"],
    createdAt: json["created_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "order_id": orderId,
    "points": points,
    "is_converted": isConverted,
    "created_at": createdAt,
  };
}
