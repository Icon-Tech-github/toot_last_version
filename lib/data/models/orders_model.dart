

import 'package:loz/data/models/attributes_model.dart';

import 'attributes_order_details.dart';
import 'department_model.dart';

class Orders {
  dynamic? id;
  String? uuid;
  double? subtotal;
  double? discount;
  String? discountType;
  double? tax;
  double? deliveryFee;
  double? total;
  int? quantity;
  String? notes;
  int? orderStatusId;
  int? branchId;
  int? paymentMethodId;
  int? orderMethodId;
  String? createdAt;
  String? updatedAt;
  OrderStatus? orderStatus;
  PaymentMethod? paymentMethod;
  List<Details>? details;
  PaymentMethod? orderMethod;

  Orders(
      {this.id,
        this.uuid,
        this.subtotal,
        this.discount,
        this.discountType,
        this.tax,
        this.deliveryFee,
        this.total,
        this.quantity,
        this.notes,
        this.orderStatusId,
        this.branchId,
        this.paymentMethodId,
        this.orderMethodId,
        this.createdAt,
        this.updatedAt,
        this.orderStatus,
        this.paymentMethod,
        this.details,
        this.orderMethod});

  Orders.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id'].toString());
    uuid = json['uuid'];
    subtotal = json['subtotal'].toDouble();
    discount = json['discount'].toDouble();
    discountType = json['discount_type'].toString();
    tax = json['tax'].toDouble();
    deliveryFee = json['delivery_fee'].toDouble();
    total = json['total'].toDouble();
    quantity = json['quantity'];
    notes = json['notes'];
    orderStatusId = json['order_status_id'];
    branchId = json['branch_id'];
    paymentMethodId = json['payment_method_id'];
    orderMethodId = json['order_method_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    orderStatus = json['order_status'] != null
        ? new OrderStatus.fromJson(json['order_status'])
        : null;
    paymentMethod = json['payment_method'] != null
        ? new PaymentMethod.fromJson(json['payment_method'])
        : null;
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
    orderMethod = json['order_method'] != null
        ? new PaymentMethod.fromJson(json['order_method'])
        : null;
  }

}

class OrderStatus {
  int? id;
  Title? title;
  String? createdAt;

  OrderStatus({this.id, this.title, this.createdAt});

  OrderStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['created_at'] = this.createdAt;
    return data;
  }
}



class PaymentMethod {
  int? id;
  Title? title;
  int? isActive;
  String? image;
  String? createdAt;

  PaymentMethod(
      {this.id, this.title, this.isActive, this.image, this.createdAt});

  PaymentMethod.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    isActive = json['is_active'];
    image = json['image'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    data['is_active'] = this.isActive;
    data['image'] = this.image;
    data['created_at'] = this.createdAt;
    return data;
  }
}

class Details {
  int? id;
  double? total;
  double? price;
  int? quantity;
  String? note;
  int? orderId;
  int? productId;
  String? createdAt;
  String? updatedAt;
  Product? product;
  List<AttributesOrderDetails> ?attributes;
  List<AddonElement> ?addons;

  Details(
      {this.id,
        this.total,
        this.price,
        this.quantity,
        this.note,
        this.orderId,
        this.productId,
        this.createdAt,
        this.updatedAt,
        this.product,
        this.addons,
      this.attributes});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    total = json['total'].toDouble();
    price = json['price'].toDouble();
    quantity = json['quantity'];
    note = json['note'];
    orderId = json['order_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    product =
    json['product'] != null ? new Product.fromJson(json['product']) : null;
    if (json['attributes'] != null) {
      attributes = <AttributesOrderDetails>[];
      json['attributes'].forEach((v) {
        attributes!.add(new AttributesOrderDetails.fromJson(v));
      });
    }
    if (json['addons'] != null) {
      addons = <AddonElement>[];
      json['addons'].forEach((v) {
        addons!.add(new AddonElement.fromJson(v));
      });
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['total'] = this.total;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    data['note'] = this.note;
    data['order_id'] = this.orderId;
    data['product_id'] = this.productId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.product != null) {
      data['product'] = this.product!.toJson();
    }
    return data;
  }
}
class AddonElement {
  AddonElement({
    this.id,
    this.price,
    this.orderDetailsId,
    this.productId,
    this.addonId,
    this.addonValueId,
    this.createdAt,
    this.updatedAt,
    this.addon,
    this.addonValue,
  });

  int? id;
  int? price;
  int ?orderDetailsId;
  int? productId;
  int ?addonId;
  int ?addonValueId;
  String ?createdAt;
  String? updatedAt;
  AddonAddon? addon;
  AddonValue ?addonValue;

  factory AddonElement.fromJson(Map<String, dynamic> json) => AddonElement(
    id: json["id"],
    price: json["price"],
    orderDetailsId: json["order_details_id"],
    productId: json["product_id"],
    addonId: json["addon_id"],
    addonValueId: json["addon_value_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    addon: AddonAddon.fromJson(json["addon"]),
    addonValue: AddonValue.fromJson(json["addon_value"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "price": price,
    "order_details_id": orderDetailsId,
    "product_id": productId,
    "addon_id": addonId,
    "addon_value_id": addonValueId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "addon": addon!.toJson(),
    "addon_value": addonValue!.toJson(),
  };
}
class AddonValue {
  AddonValue({
    this.id,
    this.addonId,
    this.title,
    this.price,
    this.createdAt,
    this.updatedAt,
    this.image,
  });

  int? id;
  int ?addonId;
  Title? title;
  int ?price;
  String? createdAt;
  String ?updatedAt;
  dynamic image;

  factory AddonValue.fromJson(Map<String, dynamic> json) => AddonValue(
    id: json["id"],
    addonId: json["addon_id"],
    title: Title.fromJson(json["title"]),
    price: json["price"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "addon_id": addonId,
    "title": title!.toJson(),
    "price": price,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "image": image,
  };
}

class AddonAddon {
  AddonAddon({
    this.id,
    this.title,
    this.multiSelect,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  Title? title;
  int ?multiSelect;
  int ?isActive;
  String ?createdAt;
  String ?updatedAt;

  factory AddonAddon.fromJson(Map<String, dynamic> json) => AddonAddon(
    id: json["id"],
    title: Title.fromJson(json["title"]),
    multiSelect: json["multi_select"],
    isActive: json["is_active"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
    "multi_select": multiSelect,
    "is_active": isActive,
    "created_at": createdAt,
    "updated_at": updatedAt,
  };
}
class Product {
  int? id;
  Title? title;
  Title? description;
  double? price;
  double? newPrice;
  int? isActive;
  int? isSlider;
  String? sliderImage;
  int? categoryId;
  String? createdAt;
  String? updatedAt;
  int? inFavourite;
  ProductImage? images;

  Product(
      {this.id,
        this.title,
        this.description,
        this.price,
        this.newPrice,
        this.isActive,
        this.isSlider,
        this.sliderImage,
        this.categoryId,
        this.createdAt,
        this.updatedAt,
        this.inFavourite,this.images});

  Product.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    description = json['description'] != null
        ? new Title.fromJson(json['description'])
        : null;
    price = json['price'].toDouble();
    newPrice = json['new_price'].toDouble();
    isActive = json['is_active'];
    isSlider = json['is_slider'];
    sliderImage = json['slider_image'];
    categoryId = json['category_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    inFavourite = json['in_favourite'];
    images =json['last_image'] != null ?ProductImage.fromJson(json['last_image']):null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    if (this.title != null) {
      data['title'] = this.title!.toJson();
    }
    if (this.description != null) {
      data['description'] = this.description!.toJson();
    }
    data['price'] = this.price;
    data['new_price'] = this.newPrice;
    data['is_active'] = this.isActive;
    data['is_slider'] = this.isSlider;
    data['slider_image'] = this.sliderImage;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['in_favourite'] = this.inFavourite;
    return data;
  }


}

class ProductImage{
  int? id;
  String ?image;
  ProductImage({this.id,this.image});

  ProductImage.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    image = json['image'];

  }

}