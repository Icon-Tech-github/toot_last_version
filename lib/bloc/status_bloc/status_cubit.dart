import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loz/data/models/order_track_model.dart';
import 'package:loz/data/repositories/tracking_repo.dart';
import 'package:equatable/equatable.dart';
import 'package:loz/data/models/order_status.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'dart:ui' as ui;

import 'package:top_snackbar_flutter/top_snack_bar.dart';
part 'status_state.dart';





class StatusCubit extends Cubit<StatusState> {
  final TrackingOrderRepo trackingOrderRepo;

  StatusCubit(this.trackingOrderRepo, int id) : super(StatusInitial()) {
   // setCustomMarker();
    print( LocalStorage.getData(key: "order_method_id").toString()+"jkjj");
    trackOrder(id);
  }

  TrackData? trackData ;
 bool isFront = false;
  Future trackOrder(int id)async{
    emit(StatusLoading());
    setCustomMarker();
    trackingOrderRepo.trackOrder(LocalStorage.getData(key: 'token'), id).then((value) {
      trackData = TrackData.fromJson(value);
      emit(StatusLoaded(status: trackData!));
    });
  }

   frontBranch(int id,context){
     emit(StatusInitial());
var  value =  trackingOrderRepo.frontBranch(LocalStorage.getData(key: 'token'), id);
     if(value != null){
       isFront = true;
       trackData!.statusIds!.add(4);
       showTopSnackBar(
           context,
           Card(
             child: CustomSnackBar.success(
               message: LocaleKeys.front_msg.tr(),
               backgroundColor: Colors.white,
               textStyle: TextStyle(
                   color: Colors.black, fontSize: MediaQuery.of(context).size.height * 0.025),
             ),
           ));
       emit(StatusLoaded(status: trackData!));
     }
  }


  Marker marker = Marker(
    markerId: MarkerId("0"),
  );
  List<Marker> markers = <Marker>[];
  late BitmapDescriptor mapMarker;
  void setCustomMarker() async {
    print("jjjjjjjjjjjjjjjj");
    final Uint8List markerIcon =
    await getBytesFromAsset('assets/images/logo.jpeg', 200);
    mapMarker = BitmapDescriptor.fromBytes(markerIcon);
    marker = Marker(
        markerId: MarkerId("0"),
        icon: mapMarker,
        position: LatLng(29.34243993398241, 47.66755704490436));
    markers.add(marker);

  //  markers.add(Marker(markerId: MarkerId("1"), position: LatLng(29.34243993398241, 47.66755704490436), icon:BitmapDescriptor.fromBytes(  await getBytesFromAsset('assets/images/logo.jpeg', 150))));

  }

  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
}


