

  import 'attributes_model.dart';
import 'department_model.dart';

class OrderMethodModel {
  int? id;
  Title? title;
  String? image;
  bool ? chosen;


  OrderMethodModel(
  {this.id,
  this.title,
this.image,
  this.chosen = false});

  OrderMethodModel.fromJson(Map<String, dynamic> json) {
  id = json['id'];
  title= Title.fromJson(json["title"]);
  image = json['image'];
  chosen = json['chosen']??false;

  }

  Map<String, dynamic> toJson() {
  final Map<String, dynamic> data = new Map<String, dynamic>();
  data['id'] = this.id;
  data['title'] = this.title;
  data['image'] = this.image;
  data['chosen'] = this.chosen;


  return data;
  }
  }



