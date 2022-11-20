import 'department_model.dart';

class AttributesOrderDetails {
  int? id;
  double? price;
  int? orderDetailsId;
  int? productId;
  int? productAttributeId;
  int? productAttributeValueId;
  String? createdAt;
  String? updatedAt;
  Attribute2? attribute;
  AttributeValue? attributeValue;

  AttributesOrderDetails(
      {this.id,
        this.price,
        this.orderDetailsId,
        this.productId,
        this.productAttributeId,
        this.productAttributeValueId,
        this.createdAt,
        this.updatedAt,
        this.attribute,
        this.attributeValue});

  AttributesOrderDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'].toDouble();
    orderDetailsId = json['order_details_id'];
    productId = json['product_id'];
    productAttributeId = json['product_attribute_id'];
    productAttributeValueId = json['product_attribute_value_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    attribute = json['attribute'] != null
        ? new Attribute2.fromJson(json['attribute'])
        : null;
    attributeValue = json['attribute_value'] != null
        ?  AttributeValue.fromJson(json["attribute_value"])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['price'] = this.price;
    data['order_details_id'] = this.orderDetailsId;
    data['product_id'] = this.productId;
    data['product_attribute_id'] = this.productAttributeId;
    data['product_attribute_value_id'] = this.productAttributeValueId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.attribute != null) {
      data['attribute'] = this.attribute!.toJson();
    }
    if (this.attributeValue != null) {
      data['attribute_value'] = this.attributeValue!.toJson();
    }
    return data;
  }
}

class Attribute2 {
  int? id;
  int? productId;
  Title? title;
  int? required;
  int? multiSelect;
  int? overridePrice;
  String? createdAt;
  String? updatedAt;

  Attribute2(
      {this.id,
        this.productId,
        this.title,
        this.required,
        this.multiSelect,
        this.overridePrice,
        this.createdAt,
        this.updatedAt});

  Attribute2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    required = json['required'];
    multiSelect = json['multi_select'];
    overridePrice = json['override_price'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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
    return data;
  }
}
class AttributeValue {
  AttributeValue({
    this.id,
    this.productAttributeId,
    this.attributeValue,
    this.price,
    this.createdAt,
    this.updatedAt,
  });

  int ?id;
  int ?productAttributeId;
  Title? attributeValue;
  double? price;
  String ?createdAt;
  String ?updatedAt;

  factory AttributeValue.fromJson(Map<String, dynamic> json) => AttributeValue(
    id: json["id"],
    productAttributeId: json["product_attribute_id"],
    attributeValue: Title.fromJson(json["attribute_value"]),
    price: json["price"].toDouble(),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "product_attribute_id": productAttributeId,
    "attribute_value": attributeValue!.toJson(),
    "price": price,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}

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

class AttributeValue2 {
  int? id;
  int? productAttributeId;
  Title? attributeValue;
  double? price;
  String? createdAt;
  String? updatedAt;

  AttributeValue2(
      {this.id,
        this.productAttributeId,
        this.attributeValue,
        this.price,
        this.createdAt,
        this.updatedAt});

  AttributeValue2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productAttributeId = json['product_attribute_id'];
    attributeValue = json['attribute_value'] != null
        ? new Title.fromJson(json['attribute_value'])
        : null;
    price = json['price'].toDouble().toDouble();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
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