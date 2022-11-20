


// class Title {
//   String? en;
//   String? ar;
//
//   Title({this.en, this.ar});
//
//   Title.fromJson(Map<String, dynamic> json) {
//     en = json['en'];
//     ar = json['ar'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['en'] = this.en;
//     data['ar'] = this.ar;
//     return data;
//   }
// }

import 'attributes_order_details.dart';
import 'department_model.dart';

class Attributes {
  int? id;
  int? productId;
  Title? title;
  int? required;
  int? multiSelect;
  int? overridePrice; ////handle if the attribute is size
  String? createdAt;
  String? updatedAt;
  List<Values>? values;
  String? chosenValue;


  Attributes(
      {this.id,
        this.productId,
        this.title,
        this.required,
        this.multiSelect,
        this.overridePrice,
        this.createdAt,
        this.updatedAt,
        this.values,
      this.chosenValue});

  Attributes.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    required = json['required'];
    multiSelect = json['multi_select'];
    overridePrice = json['override_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['values'] != null) {
      values = <Values>[];
      json['values'].forEach((v) {
        values!.add(new Values.fromJson(v));
      });
    }
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_id'] = this.productId;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['required'] = this.required;
    data['multi_select'] = this.multiSelect;
    data['override_price'] = this.overridePrice;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.values != null) {
      data['values'] = this.values!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Values {
  int? id;
  int? productAttributeId;
  Title? attributeValue;
  double? price;
  String? createdAt;
  String? updatedAt;
  bool? chosen;

  Values(
      {this.id,
        this.productAttributeId,
        this.attributeValue,
        this.price,
        this.createdAt,
        this.updatedAt,
      this.chosen});

  Values.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productAttributeId = json['product_attribute_id'];
    attributeValue = json['attribute_value'] != null
        ? new Title.fromJson(json['attribute_value'])
        : null;
    price = double.parse(json['price'].toString() );
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    chosen = json['chosen']??false;
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['product_attribute_id'] = this.productAttributeId;
    if (this.attributeValue != null) {
      data['attribute_value'] = this.attributeValue!.toJson();
    }
    data['price'] = this.price;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }

}