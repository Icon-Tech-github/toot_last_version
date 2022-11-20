class ConfirmOrderModel{
  int? id;
  int? paymentMethod;
  int? orderMethod;
  String? coupon;
  List<Details>? details;

  ConfirmOrderModel({this.details,this.coupon,this.orderMethod,this.paymentMethod});

  ConfirmOrderModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    paymentMethod = json['payment_method_id'];
    orderMethod = json['order_method_id'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(Details.fromJson(v));
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['payment_method_id'] = this.paymentMethod;
    data['order_method_id'] = this.orderMethod;
    if (this.details != null) {
      data['details'] = this.details!.map((v) => v.toJson()).toList();
    }
    data['coupon'] = this.coupon;
    return data;
  }

}


class Details{

  int? id;
  int? productId;
  int? quantity;
  String ?notes;
  List<String>? attributes;
  List <String>? addons;



  Details({this.quantity,this.notes,this.attributes,this.id,this.productId,this.addons});

  Details.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['product_id'];
  quantity = json['quantity'];
notes = json['note'];
    if (json['addons'] != null) {
      json['addons'].forEach((v) {
        addons!.add(v.toString());
      });
    }
    if (json['attributes'] != null) {
      json['attributes'].forEach((v) {
        attributes!.add(v.toString());
      });
    }
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['product_id'] = this.id;
    data['quantity'] = this.quantity;
    data['note'] = this.notes;
    data['addon_value_id']=this.addons;
    data['attribute_value_id']=this.attributes;
    return data;
  }
}