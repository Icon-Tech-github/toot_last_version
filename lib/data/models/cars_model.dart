class CarsModel{
  int? id;
  int ?clientId;
  String ?carModel;
  String ?plateNumber;
  String ?carColor;
  bool ? chosen;

  CarsModel({
    this.id,
    this.clientId,
    this.carModel,
    this.plateNumber,
    this.carColor,
    this.chosen = false,

});

  factory CarsModel.fromJson(Map<String, dynamic> json) => CarsModel(
    id: json["id"],
    clientId: json["client_id"],
    carModel: json["car_model"],
    plateNumber: json["plate_number"],
    carColor: json["car_color"],
    chosen: json['chosen']??false,
  );
  Map<String, dynamic> toJson() => {
    "id": id,
    "chosen": chosen,
    "carModel": carModel,
    "plateNumber": plateNumber,
    "carColor": carColor,
    "clientId": clientId,
  };

}