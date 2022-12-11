import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loz/data/models/address_model.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:meta/meta.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/repositories/order_method_repo.dart';

part 'address_gift_state.dart';

class AddressGiftCubit extends Cubit<AddressGiftState> {
  final OrderMethodRepo repo;
  List<AddressModel> allAddresses =[];
  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
  bool radioSelected = false;


  TextEditingController addressTitle = TextEditingController();
  TextEditingController addressDis = TextEditingController();



  AddressGiftCubit(this.repo) : super(AddressGiftInitial()){
    LocalStorage.removeData(key: "addressId");
    LocalStorage.removeData(key: "addressTitle");
    getAddresses();


  }


  getAddresses()async{
    emit(AddressesGiftLoading());
    var data = await repo.fetchAddressGift();
    final addresses = List<AddressModel>.from(
        data.map((address) => AddressModel.fromJson(address)));
    allAddresses = addresses;
    for(int i =0; i< addresses.length; i++){
      if(addresses[i].defaultAddress ==1){
        addresses[i].chosen=true;
        LocalStorage.saveData(key: "addressId", value: addresses[i].id);
      }}
    // if(LocalStorage.getData(key: "addressId") !=null){
    //   for(int i =0; i< addresses.length; i++){
    //     if(LocalStorage.getData(key: "addressId") == addresses[i].id)
    //     {
    //       addresses[i].chosen=true;
    //     }
    //   }}
    emit(AddressesGiftLoaded(address: addresses));
  }

  addAddress( context) async {
    // emit(AuthLoading());
    if (!formKey2.currentState!.validate()) {
      return;
    }
    LoadingScreen.show(context!);

    await repo
        .addAddressGift(
        title: addressTitle.text,
        notes: addressDis.text,
        long: lng.toString(),
        lat: lat.toString(),
        defaultAddress: radioSelected? 1 : 0
    )
        .then((data) async {
      if(data == null){
        emit(AddAddressGiftFailure(error: LocaleKeys.not_valid.tr(),));
      }else {
        // Random random = new Random();
        //
        // int randomNumber = random.nextInt(10000) + 1000;
        // allAddresses.add(AddressModel(
        //     id: randomNumber,
        //     lat: lat.toString(),
        //     long: lng.toString(),
        //     title: address.text
        // ));
        await getAddresses();
        Navigator.pop(context);
        Navigator.pop(context);
        //   emit(AddAddressLoaded());
      }
    });
  }


  chooseAddress(List<AddressModel> address, int i,context) {
    emit(AddressGiftInitial());
    if (allAddresses[i].chosen == null) allAddresses[i].chosen = false;
    for (var element in allAddresses) {
      element.chosen = false;
    }
    allAddresses[i].chosen = true;
    if (allAddresses[i].deliveryFee == 0) {
      showTopSnackBar(
          context,
          Card(
            child: CustomSnackBar.success(
              message: LocaleKeys.out_of_range.tr(),
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery
                      .of(context)
                      .size
                      .height * 0.02),
            ),
          ));
      LocalStorage.removeData(key: "addressId");
      LocalStorage.removeData(key: "addressTitle");
      emit(AddressesGiftLoaded(address:address ));
    } else{
      LocalStorage.saveData(key: "addressId", value: address[i].id!);
      LocalStorage.saveData(key: "addressTitle", value: address[i].title!);
      emit(AddressesGiftLoaded(address:address ));
    }

  }

  void makeDefault(int id,context){
    emit(AddressGiftInitial());
    Size size = MediaQuery.of(context).size;
    var data =    repo.makeDefault(id);

    if( data != null) {
      showTopSnackBar(
          context,
          Card(
            child: CustomSnackBar.success(
              message: LocaleKeys.successfully.tr(),
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: size.height * 0.04),
            ),
          ));
      for(int n =0; n< allAddresses.length; n++) {

        allAddresses[n].defaultAddress =0;
        allAddresses[n].chosen=false;


      }
      for(int n =0; n< allAddresses.length; n++) {
        if(allAddresses[n].id == id){
          allAddresses[n].defaultAddress =1;
          allAddresses[n].chosen=true;
          LocalStorage.saveData(key: "addressId", value: allAddresses[n].id);
          break;
        }
      }
      emit(AddressesGiftLoaded(address: allAddresses));

    }else{
      print("llllkkkkkkll");

    }
  }

  GoogleMapController? mapController;
  bool markerTapped = false;
  Marker? marker;
  double? lat;
  double? lng;
  Position? currentLocation;
  getLocationStatus() async {
    var status = await Geolocator.isLocationServiceEnabled();
    if (status) {
      // setState(() {
      // هفعل السيركل عشان الفيو وهى هتطفى تانى من تحت وهقول ان فى صيدليات بعد ماكان الموقع مش متفعل
      getUserLocation();
      //   });
    } else {
      // setState(() {
      //   //_showDialog(context);
      // });
    }
  }
  // setActiveLocation() async {
  //   var platform = Theme.of(context).platform;
  //
  //   if (platform == TargetPlatform.iOS) {
  //     AppSettings.openAppSettings();
  //   } else {
  //     final AndroidIntent intent = new AndroidIntent(
  //       action: 'android.settings.LOCATION_SOURCE_SETTINGS',
  //     );
  //     await intent.launch().then((value) => getUserLocation);
  //   }
  // }
  getUserLocation() async {
    // Position position = await Geolocator.getCurrentPosition();
    currentLocation = await locateUser();
    // setState(() {
    markerTapped = true;
    marker = createMarker(
      currentLocation!.latitude,
      currentLocation!.longitude,
    );
    lat = currentLocation!.latitude;
    lng = currentLocation!.longitude;
    print(lat);
    //   });
  }
  Future<Position> locateUser() async{
    await Geolocator.requestPermission();

    return Geolocator.getCurrentPosition();
  }
  Marker createMarker(double latitude, double longitude) {
    return Marker(
        draggable: true,
        markerId: MarkerId('Marker'),
        position: LatLng(latitude, longitude),
        onDragEnd: (newPosition){
          lat = newPosition.latitude;
          lng = newPosition.longitude;
          print(newPosition.latitude);
        }
    );
  }
}
