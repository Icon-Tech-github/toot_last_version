import 'package:loz/data/models/attributes_model.dart';
import 'package:loz/data/models/products.dart';

import 'department_model.dart';

class FavoriteModel {
  FavoriteModel({
    this.id,
    this.clientId,
    this.productId,
    this.product,
  });

  int ?id;
  int ?clientId;
  int ?productId;
  Product ?product;

  factory FavoriteModel.fromJson(Map<String, dynamic> json) => FavoriteModel(
    id: json["id"],
    clientId: json["client_id"],
    productId: json["product_id"],
    product: Product.fromJson(json["product"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "client_id": clientId,
    "product_id": productId,
    "product": product!.toJson(),
  };
}

class Product {
  Product({
    this.id,
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
    this.inFavourite,
    this.unit,
    this.images,
  });

  int ?id;
  Title? title;
  Title? description;
  double? price;
  double ?newPrice;
  int ?isActive;
  int? isSlider;
  String ?sliderImage;
  int ?categoryId;
  String? createdAt;
  String ?updatedAt;
  int? inFavourite;
  SliderImage? images;
  Category ?unit;


  factory Product.fromJson(Map<String, dynamic> json) => Product(
    id: json["id"],
    title: Title.fromJson(json["title"]),
    description: Title.fromJson(json["description"]),
    price: json["price"].toDouble(),
    newPrice: json["new_price"].toDouble(),
    isActive: json["is_active"],
    isSlider: json["is_slider"],
    sliderImage: json["slider_image"],
    unit :json['unit'] != null ? Category.fromJson(json["unit"]):null,

    categoryId: json["category_id"],
    createdAt: json["created_at"],
    updatedAt: json["updated_at"],
    inFavourite: json["in_favourite"],
    images: SliderImage.fromJson(json["last_image"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title!.toJson(),
    "description": description!.toJson(),
    "price": price,
    "new_price": newPrice,
    "is_active": isActive,
    "is_slider": isSlider,
    "slider_image": sliderImage,
    "category_id": categoryId,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "in_favourite": inFavourite,
    "images": images.toString(),
  };
}
