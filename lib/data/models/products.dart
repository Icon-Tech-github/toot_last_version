// To parse this JSON data, do
//
//     final productDataModel = productDataModelFromJson(jsonString);

import 'dart:convert';

import '../../local_storage.dart';
import 'attributes_model.dart';
import 'department_model.dart';

ProductDataModel productDataModelFromJson(String str) => ProductDataModel.fromJson(json.decode(str));

String productDataModelToJson(ProductDataModel data) => json.encode(data.toJson());

class ProductDataModel {
  ProductDataModel({
    this.status,
    this.msg,
    this.data,
  });

  bool ?status;
  String ?msg;
  Data ?data;

  factory ProductDataModel.fromJson(Map<String, dynamic> json) => ProductDataModel(
    status: json["status"],
    msg: json["msg"],
    data: Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "msg": msg,
    "data": data!.toJson(),
  };
}

class Data {
  Data({
    this.currentPage,
    required this.data,
    this.firstPageUrl,
    this.from,
    this.lastPage,
    this.lastPageUrl,
    this.links,
    this.nextPageUrl,
    this.path,
    this.perPage,
    this.prevPageUrl,
    this.to,
    this.total,
  });

  int? currentPage;
  List<ProductModel> data;
  String ?firstPageUrl;
  int ?from;
  int ?lastPage;
  String ?lastPageUrl;
  List<Link> ?links;
  String ?nextPageUrl;
  String ?path;
  String ?perPage;
  dynamic prevPageUrl;
  int? to;
  int ?total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<ProductModel>.from(json["data"].map((x) => ProductModel.fromJson(x))),
    firstPageUrl: json["first_page_url"],
    from: json["from"],
    lastPage: json["last_page"],
    lastPageUrl: json["last_page_url"],
    links: List<Link>.from(json["links"].map((x) => Link.fromJson(x))),
    nextPageUrl: json["next_page_url"],
    path: json["path"],
    perPage: json["per_page"],
    prevPageUrl: json["prev_page_url"],
    to: json["to"],
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "current_page": currentPage,
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
    "first_page_url": firstPageUrl,
    "from": from,
    "last_page": lastPage,
    "last_page_url": lastPageUrl,
    "links": List<dynamic>.from(links!.map((x) => x.toJson())),
    "next_page_url": nextPageUrl,
    "path": path,
    "per_page": perPage,
    "prev_page_url": prevPageUrl,
    "to": to,
    "total": total,
  };
}

class ProductModel {
  ProductModel({
    this.id,
    this.title,
    this.description,
    this.price,
    this.newPrice,
    this.isActive,
    this.isSlider,
    this.categoryId,
    this.createdAt,
    this.updatedAt,
    this.inFavourite,
    this.images,
    this.count,
    this.calories,
    this.total,
    this.attributes,
    this.notes,
    this.denyCoupon,
    this.tax,
    this.sensitive,
    this.fastDelivery,
    this.addons,
    this.unit,
    this.category
  });

  int? id;

  Title ?title;
  Title? description;
  Title ? sensitive;
  Category? category;
  Category ?unit;
  dynamic? price;
  dynamic ?newPrice;
  int? isActive;
  String ? calories;
  double? tax;
  double ? fastDelivery;
  int ? denyCoupon;
  int? isSlider;
  int ?categoryId;
  String? createdAt;
  String ?updatedAt;
  int ?inFavourite;
  SliderImage ?images;
  int? count;
  double ? total;
  List<Attributes>? attributes;
  List<Addon> ?addons;
  String? notes;
  int ? multiSelect;

  ProductModel.fromJson(Map<String, dynamic> json) {
    denyCoupon =json['deny_coupon'];
    tax = json['tax'] !=null? double.parse(json['tax'].toString()):json['tax'];
    fastDelivery = json['fast_delivery'] !=null? double.parse(json['fast_delivery'].toString()):json['fast_delivery'];
    if (json['fast_delivery'] != null)
      LocalStorage.saveData(key: 'fast_delivery', value: ("${json['fast_delivery']}"));
    id = json['id'];
    title = json['title'] != null ? new Title.fromJson(json['title']) : null;
    category = json['category'] != null ? new Category.fromJson(json['category']) : null;

    sensitive = json['sensitive'] != null ? new Title.fromJson(json['sensitive']) : null;
    description = json['description'] != null
        ? new Title.fromJson(json['description'])
        : null;
    price = double.parse(json['price'].toString());
    total = json['total'];
    newPrice =  double.parse(json['new_price'].toString());
    isActive = json['is_active'];
    isSlider = json['is_slider'];
    notes = json['notes'];
    categoryId = json['category_id'];
    calories = json['calories'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    multiSelect = json['multiSelect'];
    unit =json['unit'] != null ? Category.fromJson(json["unit"]):null;
    if (json['addons'] != null) {
      addons = <Addon>[];
      json['addons'].forEach((v) {
        addons!.add(new Addon.fromJson(v));
      });
    }
    inFavourite = json['in_favourite'];
    count = json['count']??1;
    if (json['attributes'] != null) {
      attributes = <Attributes>[];
      json['attributes'].forEach((v) {
        attributes!.add(new Attributes.fromJson(v));
      });
    }
    images= SliderImage.fromJson(json["last_image"]);
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
    data['notes'] = this.notes;
    data['total'] = this.total;
    data['free_delivery'] =this.fastDelivery;
    data['deny_coupon'] = this.denyCoupon;
    data['new_price'] = this.newPrice;
    data['calories'] = this.calories;
    data['is_active'] = this.isActive;
    data['is_slider'] = this.isSlider;
    data['category_id'] = this.categoryId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['in_favourite'] = this.inFavourite;
    data['tax'] = this.tax;
    data['count'] = this.count;
    if (this.addons != null) {
      data["addons"] = List<dynamic>.from(addons!.map((x) => x.toJson()));
    }
    if (this.attributes != null) {
      data['attributes'] = this.attributes!.map((v) => v.toJson()).toList();
    }
   data[ "last_image"]= images!.toJson();
    ;
    return data;
  }
}
class Category {
  Category({
    this.id,
    this.title,
  });

  int? id;
  Title? title;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: Title.fromJson(json["title"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
  };
}

class Addon {
  Addon({
    this.id,
    this.title,
    this.multiSelect,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.pivot,
    this.values,

  });

  int ?id;
  Title ?title;
  int? multiSelect;
  int? isActive;

  String ?createdAt;
  String ?updatedAt;
  Pivot ?pivot;
  List<AddonValue>? values;

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
    id: json["id"],
    title: Title.fromJson(json["title"]),
    multiSelect: json["multi_select"],
    isActive: json["is_active"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],

    values: List<AddonValue>.from(json["values"].map((x) => AddonValue.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
    "multi_select": multiSelect,
    "is_active": isActive,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "values": List<dynamic>.from(values!.map((x) => x.toJson())),
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
    this.chosen,
    this.image
  });

  int ?id;
  int ?addonId;
  Title? title;
  String ? image;
  double ?price;
  String? createdAt;
  String ?updatedAt;
  bool? chosen;

  factory AddonValue.fromJson(Map<String, dynamic> json) => AddonValue(
    id: json["id"],
    addonId: json["addon_id"],
    title: Title.fromJson(json["title"]),
    price: double.parse(json["price"].toString()),
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    image: json['image'],
      chosen : json['chosen']??false,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "addon_id": addonId,
    "title": title!.toJson(),
    "price": price,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "chosen": chosen,
  };
}
class Pivot {
  Pivot({
    this.productId,
    this.addonId,
  });

  int? productId;
  int ?addonId;

  factory Pivot.fromJson(Map<String, dynamic> json) => Pivot(
    productId: json["product_id"],
    addonId: json["addon_id"],
  );

  Map<String, dynamic> toJson() => {
    "product_id": productId,
    "addon_id": addonId,
  };
}
class Description {
  Description({
    this.en,
    this.ar,
  });

  String ?en;
  String ?ar;

  factory Description.fromJson(Map<String, dynamic> json) => Description(
    en: json["en"],
    ar: json["ar"],
  );

  Map<String, dynamic> toJson() => {
    "en": en,
    "ar": ar,
  };
}
class SliderImage {
  SliderImage({
    this.id,
    this.image,
  });

  int ?id;
  String ?image;

  factory SliderImage.fromJson(Map<String, dynamic> json) => SliderImage(
    id: json["id"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "image": image,
  };
}




class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String ?url;
  String ?label;
  bool ?active;

  factory Link.fromJson(Map<String, dynamic> json) => Link(
    url: json["url"] == null ? null : json["url"],
    label: json["label"],
    active: json["active"],
  );

  Map<String, dynamic> toJson() => {
    "url": url == null ? null : url,
    "label": label,
    "active": active,
  };
}
