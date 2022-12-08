class AddressModel{
  int ?id;
  int? clientId;
  String ?title;
  String ?lat;
  String ?long;
  String ?notes;
  bool ? chosen;
  int ? defaultAddress;
  bool ? freeToday;
  double ?deliveryFee;


  AddressModel({  this.id,
    this.clientId,
    this.title,
    this.defaultAddress,
    this.lat,
    this.long,
    this.notes,
    this.freeToday,
    this.deliveryFee,
  this.chosen = false});

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    id: json["id"],
    clientId: json["client_id"],
    defaultAddress: json["default"],
    title: json["title"],
    lat: json["lat"].toString(),
    long: json["long"].toString(),
    notes: json["notes"],
      freeToday: json['freeToday'],
      deliveryFee: double.parse(json['delivery_fee'].toString()),
    chosen: json['chosen']

  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "default":defaultAddress,
    "chosen": chosen,
    "title": title,
    "lat": lat,
    "long": long,
    "clientId": clientId,
  };
}