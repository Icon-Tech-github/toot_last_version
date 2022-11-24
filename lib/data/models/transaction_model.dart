// To parse this JSON data, do
//
//     final transactionModel = transactionModelFromJson(jsonString);

import 'dart:convert';

TransactionModel transactionModelFromJson(String str) => TransactionModel.fromJson(json.decode(str));

String transactionModelToJson(TransactionModel data) => json.encode(data.toJson());

class TransactionModel {
  TransactionModel({
    this.status,
    this.msg,
    this.data,
  });

  bool? status;
  String? msg;
  Data ?data;

  factory TransactionModel.fromJson(Map<String, dynamic> json) => TransactionModel(
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
    this.data,
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
  List<TransactionDataModel>? data;
  String ?firstPageUrl;
  int ?from;
  int ?lastPage;
  String ?lastPageUrl;
  List<Link> ?links;
  dynamic nextPageUrl;
  String ?path;
  int? perPage;
  dynamic prevPageUrl;
  int ?to;
  int ?total;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    currentPage: json["current_page"],
    data: List<TransactionDataModel>.from(json["data"].map((x) => TransactionDataModel.fromJson(x))),
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
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
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

class TransactionDataModel {
  TransactionDataModel({
    this.id,
    this.fromClient,
    this.toClient,
    this.amount,
    this.fromClientBalanceBefore,
    this.fromClientBalanceAfter,
    this.toClientBalanceBefore,
    this.toClientBalanceAfter,
    this.createdAt,
    this.updatedAt,
    this.sender,
    this.reciever,
  });

  int? id;
  int ?fromClient;
  int ?toClient;
  double ?amount;
  double ?fromClientBalanceBefore;
  double ?fromClientBalanceAfter;
  double ?toClientBalanceBefore;
  double ?toClientBalanceAfter;
  String? createdAt;
  String ?updatedAt;
  Reciever ?sender;
  Reciever ?reciever;

  factory TransactionDataModel.fromJson(Map<String, dynamic> json) => TransactionDataModel(
    id: json["id"],
    fromClient: json["from_client"] == null ? null : json["from_client"],
    toClient: json["to_client"],
    amount: json["amount"].toDouble(),
    fromClientBalanceBefore:json["from_client_balance_before"]!=null?
  json["from_client_balance_before"].toDouble():0.0,
    fromClientBalanceAfter: json["from_client_balance_after"]!=null?
  json["from_client_balance_after"].toDouble():0.0,


    toClientBalanceBefore:json["to_client_balance_before"]!=null?
    json["to_client_balance_before"].toDouble():0.0,
    toClientBalanceAfter: json["to_client_balance_after"]!=null?
    json["to_client_balance_after"].toDouble():0.0,
    createdAt:json["created_at"].toString(),
    updatedAt:json["updated_at"],
    sender: json["sender"] == null ? null : Reciever.fromJson(json["sender"]),
    reciever: Reciever.fromJson(json["reciever"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "from_client": fromClient == null ? null : fromClient,
    "to_client": toClient,
    "amount": amount,
    "from_client_balance_before": fromClientBalanceBefore == null ? null : fromClientBalanceBefore,
    "from_client_balance_after": fromClientBalanceAfter == null ? null : fromClientBalanceAfter,
    "to_client_balance_before": toClientBalanceBefore,
    "to_client_balance_after": toClientBalanceAfter,
    "created_at": createdAt,
    "updated_at": updatedAt,
    "sender": sender == null ? null : sender!.toJson(),
    "reciever": reciever!.toJson(),
  };
}

class Reciever {
  Reciever({
    this.id,
    this.name,
    this.phone,
  });

  int ? id;
  String ?name;
  String ?phone;

  factory Reciever.fromJson(Map<String, dynamic> json) => Reciever(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
  };
}

class Link {
  Link({
    this.url,
    this.label,
    this.active,
  });

  String? url;
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
