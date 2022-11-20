import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loz/data/models/branch_model.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;

import '../../bloc/status_bloc/status_cubit.dart';
import '../../data/repositories/branch_repo.dart';
import '../../local_storage.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/steper_bar.dart';
import 'order_details.dart';

class MapScreen extends StatefulWidget {
  List<BranchModel> ?branches;
   MapScreen({Key? key,this.branches}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late BitmapDescriptor mapMarker;
  bool markerTapped = false;
  bool locationLoad =false;
  double? lat;
  double? lng;

  BranchModel? branchDetails;
  Position? currentLocation;
  Marker marker = Marker(
    markerId: MarkerId("0"),
  );
  Future<Uint8List> getBytesFromAsset(String path, int width) async {
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
        targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!
        .buffer
        .asUint8List();
  }
  getUserLocation(List<BranchModel> ?branches) async {
    // Position position = await Geolocator.getCurrentPosition();
    currentLocation = await locateUser();
    setState(() {
      LocalStorage.saveData(key: "lat", value: currentLocation!.latitude);
      LocalStorage.saveData(key: "lng", value: currentLocation!.longitude);

      lat = currentLocation!.latitude;
      lng = currentLocation!.longitude;
      print(lng);



    });
    print("llllllllllll");
     GetBranchesRepository ?branchesRepository;
    await GetBranchesRepository.fetchBranchDataStatic(lat.toString(),lng.toString()).then((data) {
      branches = List<BranchModel>.from(
          data.map((branch) => BranchModel.fromJson(branch)));

print(branches!.length.toString()+"uuuu");
    });
    setState(() {
      widget.branches = branches;
      locationLoad =true;
    });
    setCustomMarker(currentLocation!.latitude,currentLocation!.longitude,branches);
  }
  List<Marker> markerList = [];
  Future<Position> locateUser() async {
    await Geolocator.requestPermission();
    return Geolocator.getCurrentPosition();
  }
  String calculateClosedTime(String morningTimeFrom, String morningTimeTo , String eveningTimeFrom, String eveningTimeTo){
    DateTime now = DateTime.now();
    String date = now.toString().substring(0,10);
    DateTime startDateMorning = DateTime.parse("$date ${morningTimeFrom}.000");
    DateTime endDateMorning = DateTime.parse("$date ${morningTimeTo}.000");
    DateTime startDateEvening = DateTime.parse("$date ${eveningTimeFrom}.000");
    DateTime endDateEvening = DateTime.parse("$date ${eveningTimeTo}.000");
    print('now: $now');
    DateFormat   format = DateFormat("hh:mm a");
    if(now.isAfter(startDateMorning) && now.isBefore(endDateMorning)){
      print(morningTimeTo.toString()+'bbbbbbbbbbbbb');
      return format.format(endDateMorning);
    }else if(now.isAfter(startDateEvening) && now.isBefore(endDateEvening)){
      return format.format(endDateEvening);
    }
    else{
      return "";
    }
  }
  String calculateOpenTime(String morningTimeFrom, String morningTimeTo , String eveningTimeFrom, String eveningTimeTo){
    DateTime now = DateTime.now();
    String date = now.toString().substring(0,10);
    DateTime startDateMorning = DateTime.parse("$date ${morningTimeTo}.000");
    DateTime endDateMorning = DateTime.parse("$date ${morningTimeTo}.000");
    DateTime startDateEvening = DateTime.parse("$date ${eveningTimeFrom}.000");
    DateTime endDateEvening = DateTime.parse("$date ${eveningTimeTo}.000");
    print('now: $now');
    DateFormat   format = DateFormat("hh:mm a");
    if(now.isBefore(startDateMorning) ){
      return format.format(startDateMorning);
    }else if(now.isBefore(startDateEvening)){
      return format.format(startDateEvening );
    }
    else{
      return "";
    }
  }
  void setCustomMarker(double lat,double long,List<BranchModel> ?branches) async {
    print("jjjjjjjjjjjjjjjj");

    final Uint8List markerIcon =
    await getBytesFromAsset('assets/images/marker.png', 170);

    final Uint8List locationIcon =
    await getBytesFromAsset('assets/images/location.png', 170);
    mapMarker = BitmapDescriptor.fromBytes(markerIcon);

    for (int i = 0; i < branches!.length; i++) {
       {
        markerList.add(
          Marker(
              markerId: MarkerId(branches[i].id.toString()),
              position: LatLng(double.parse(branches[i].lat),
                  double.parse(branches[i].long)),
              infoWindow: InfoWindow(title: branches[i].title!.en),
              icon: BitmapDescriptor.fromBytes(markerIcon),
              onTap: () {
                setState(() {
                  markerTapped = true;
                  branchDetails = branches[i];
                 // location1 = allLocations[i];
                 // open = true;

                });
              }),
        );
      }
    }
    markerList.add(
        Marker(
            markerId:  MarkerId("0"),
            position: LatLng(lat , long),
            infoWindow: InfoWindow(title: "My Location"),
            icon: BitmapDescriptor.fromBytes(locationIcon),
        ));
    //  markers.add(marker);
    setState(() {
    //  29.34243993398241
    });
    //  markers.add(Marker(markerId: MarkerId("1"), position: LatLng(29.34243993398241, 47.66755704490436), icon:BitmapDescriptor.fromBytes(  await getBytesFromAsset('assets/images/logo.jpeg', 150))));

  }

  @override
  void initState() {
    // TODO: implement initState
    if(LocalStorage.getData(key: "lat") == null){
      getUserLocation(widget.branches);
    }else{
      locationLoad=true;
      setCustomMarker(double.parse(LocalStorage.getData(key: "lat").toString()),double.parse(LocalStorage.getData(key: "lng").toString()),widget.branches);

    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // SizedBox(
            //   height: size.height * .01,
            // ),
            // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
            //   child: Row(
            //     children: [
            //       Container(
            //         padding:
            //         const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
            //         child: IconButton(
            //           icon: const Icon(
            //             Icons.arrow_back_ios,
            //             size: 28,
            //             color: AppTheme.secondary,
            //           ),
            //           onPressed: () {
            //             Navigator.of(context).pop();
            //           },
            //         ),
            //       ),
            //       Text(
            //         LocaleKeys.order_tracking.tr(),
            //         style: TextStyle(
            //           fontSize: size.width * .05,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //
            //       // SizedBox(width: 60,),
            //     ],
            //   ),
            // ),
            Stack(
              alignment: Alignment.bottomCenter,
              //   alignment: Alignment.center,
              children: [
                locationLoad?
                SizedBox(
                  height: size.height * .94,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng( LocalStorage.getData(key: "lat")==null? lat! : double.parse(LocalStorage.getData(key: "lat").toString()) ,LocalStorage.getData(key: "lng") == null?lng!: double.parse(LocalStorage.getData(key: "lng").toString())),
                      zoom: 13.0,
                    ),
                    markers: Set<Marker>.of(markerList),
                    // markers: Set<Marker>.of(
                    //   <Marker>[context.read<StatusCubit>().marker!],
                    // ),
                    // onMapCreated: (GoogleMapController controller) {
                    //   context.read<OrderMethodCubit>().mapController = controller;
                    // },
                  ),
                ):
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'Your Location loading ...',
                      style: TextStyle(color: AppTheme.orange, fontSize: 16),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 70,right: 10,left: 10),
                  child: Visibility(
                    visible: markerTapped,
                      child: Container(
                        height: size.height * .4,
                        width: size.width,
                        decoration: BoxDecoration(
                          color: AppTheme.white,
                          borderRadius:  BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 18.0,right: 10,left: 20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  branchDetails?.image == null?
                                   ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(20),
                                      child: Image.asset("assets/images/logo.png",
                                          fit: BoxFit.fill,
                                          height:  size.height *.07,
                                          width: size.height *.07
                                        //    double.infinity,
                                      )):
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(7),
                                    child: Image.network(branchDetails!.image.toString(),
                                        fit: BoxFit.fill,
                                        height:  size.height *.07,
                                        width: size.height *.07
                                    ),
                                  ),
                                  SizedBox(width: size.width * .03,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(branchDetails?.title?.en.toString()??"",
                                              style: TextStyle(
                                                fontSize: size.width * .04,
                                                fontWeight: FontWeight.bold,
                                                height: size.height * .002,

                                              ),
                                            ),

                                      Row(
                                        children: [
                                          Text("${LocaleKeys.phone.tr()} : ",
                                            style: TextStyle(
                                                fontSize: size.width * .032,
                                                fontWeight: FontWeight.bold,
                                                height: size.height * .002,
                                                color: Colors.grey
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: (){
                                              launch("tel://${branchDetails?.phone}");

                                            },
                                            child: Text((branchDetails?.phone.toString()??""),
                                              style: TextStyle(
                                                decoration: TextDecoration.underline,
                                                fontSize: size.width * .032,
                                                fontWeight: FontWeight.bold,
                                                height: size.height * .002,
                                                color: Colors.grey
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),


                                    ],
                                  ),

                                ],
                              ),
                            ),
                            //  SizedBox(height: 5,),
                              Divider(),
                              SizedBox(height: 5,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.my_location, color: Colors.black,size: size.height * .04,),
                                  SizedBox(width: size.width * .02,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(LocaleKeys.branch_address.tr(),
                                        style: TextStyle(
                                            fontSize: size.width * .03,
                                            fontWeight: FontWeight.bold,
                                            height: size.height * .002,
                                            color: Colors.grey
                                        ),
                                      ),
                                      Text((branchDetails?.address.toString()??""),
                                        style: TextStyle(
                                            fontSize: size.width * .035,
                                            fontWeight: FontWeight.bold,
                                            height: size.height * .002,
                                            color: Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.location_on, color: Colors.black,size: size.height * .04,),
                                  SizedBox(width: size.width * .02,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(LocaleKeys.Distance.tr(),
                                        style: TextStyle(
                                            fontSize: size.width * .03,
                                            fontWeight: FontWeight.bold,
                                            height: size.height * .002,
                                            color: Colors.grey
                                        ),
                                      ),
                                      Text((branchDetails?.distance.toString()??"")+" ${LocaleKeys.km.tr()}",
                                        style: TextStyle(
                                            fontSize: size.width * .035,
                                            fontWeight: FontWeight.bold,
                                            height: size.height * .002,
                                            color: Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: 20,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(Icons.star, color: Colors.black,size: size.height * .04,),
                                  SizedBox(width: size.width * .02,),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(LocaleKeys.Branch_rate.tr(),
                                        style: TextStyle(
                                            fontSize: size.width * .03,
                                            fontWeight: FontWeight.bold,
                                            height: size.height * .002,
                                            color: Colors.grey
                                        ),
                                      ),
                                      Text((branchDetails?.rate.toString()??""),
                                        style: TextStyle(
                                            fontSize: size.width * .035,
                                            fontWeight: FontWeight.bold,
                                            height: size.height * .002,
                                            color: Colors.black
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: size.width * .03,),
                              Row(
                                children: [
                                  Container(
                                      width: size.width *.2,
                                      padding: EdgeInsets.symmetric(vertical: 2,horizontal: 6),
                                      decoration: BoxDecoration(
                                      //  color: AppTheme.secondary.withOpacity(.3),
                                          border: Border.all(width: 1,color: branchDetails?.statusNo ==1? AppTheme.secondary: Colors.red),
                                        borderRadius:  BorderRadius.circular(20),
                                      ),
                                      child: Center(child: Text(branchDetails?.statusNo ==1?"${LocaleKeys.Opened.tr()}":"${LocaleKeys.Closed.tr()}" ,
                                        style: TextStyle( fontSize: size.width * .03,color: Colors.black,fontWeight: FontWeight.bold),))),
                                  SizedBox(width: size.width * .02,),
                                  if(branchDetails?.morningTimeFrom != null)
                                  Text(branchDetails?.statusNo ==1?"${LocaleKeys.Closed.tr()} | ${calculateClosedTime(branchDetails?.morningTimeFrom, branchDetails?.morningTimeTo, branchDetails?.eveningTimeFrom, branchDetails?.eveningTimeTo)}":"${LocaleKeys.Opened.tr()} |  ${calculateOpenTime(branchDetails?.morningTimeFrom??"", branchDetails?.morningTimeTo??"", branchDetails?.eveningTimeFrom??"", branchDetails?.eveningTimeTo??"")}",
                                    style: TextStyle(
                                        fontSize: size.width * .035,
                                        fontWeight: FontWeight.bold,
                                        height: size.height * .002,
                                        color: Colors.grey
                                    ),
                                  ),
                                ],
                              ),

                            ],
                          ),
                        ),
                  )),
                )

              ],
            )
          ],
        ),
      ),
    );
  }
}
