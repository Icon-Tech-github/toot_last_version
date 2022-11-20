import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loz/data/models/address_model.dart';
import 'package:loz/data/models/cars_model.dart';
import 'package:loz/data/models/order_method_model.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:meta/meta.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/repositories/order_method_repo.dart';

part 'cars_state.dart';

class CarsCubit extends Cubit<CarsState> {
  final OrderMethodRepo repo;

  List<CarsModel> allCars =[];
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();


  TextEditingController carModel = TextEditingController();
  TextEditingController carNumber = TextEditingController();
  TextEditingController carColor = TextEditingController();



  CarsCubit(this.repo) : super(CarsInitial()){

    getCars();
  }




  getCars()async{
    emit(CarsLoading());
    var data = await repo.fetchCars();
    final cars = List<CarsModel>.from(
        data.map((car) => CarsModel.fromJson(car)));
    allCars = cars;
    if(LocalStorage.getData(key: "carId") !=null){
      for(int i =0; i< cars.length; i++){
        if(LocalStorage.getData(key: "carId") == cars[i].id)
        {
          cars[i].chosen=true;
        }
      }}
    emit(CarsLoaded(cars: cars));
  }
  addCar(context
      ) async {
    print(carColor.text);
    if (!formKey.currentState!.validate()) {
      return;
    }
    LoadingScreen.show(context);
    await repo
        .addCar(
        color: carColor.text,
        model: carModel.text,
        number: carNumber.text
    )
        .then((data) async {
      if(data == null){
        emit(AddCarFailure(error: "not valid"));
      }else {
        // Random random = new Random();
        //
        // int randomNumber = random.nextInt(10000) + 1000;
        // allCars.add(CarsModel(
        //   id: randomNumber,
        //   carColor: carColor.text,
        //   carModel: carModel.text,
        //   plateNumber : carNumber.text,
        // ));
        await getCars();
        Navigator.pop(context);
        Navigator.pop(context);

       // emit(AddCarsLoaded());
      }
    });
  }




  chooseCar(List<CarsModel> address, int i){
    emit(CarsInitial());
    if (allCars[i].chosen == null) allCars[i].chosen = false;
    for (var element in allCars) {
      element.chosen = false;
    }
    allCars[i].chosen = true;
    LocalStorage.saveData(key: "carId", value: address[i].id!);
    LocalStorage.saveData(key: "carTitle", value: address[i].carModel!);
    emit(CarsLoaded(cars:allCars ));

  }

}
