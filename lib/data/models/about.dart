
import 'dart:convert';

AboutModel aboutModelFromJson(String str) => AboutModel.fromJson(json.decode(str));

String aboutModelToJson(AboutModel data) => json.encode(data.toJson());

class AboutModel {
  AboutModel({
    this.data,
  });

  String ?data;

  factory AboutModel.fromJson(Map<String, dynamic> json) => AboutModel(
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
  };
}
