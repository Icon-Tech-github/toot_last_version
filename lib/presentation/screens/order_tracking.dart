import 'dart:typed_data';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/order_details_bloc/order_details_cubit.dart';
import 'package:loz/bloc/status_bloc/status_cubit.dart';
import 'package:loz/data/repositories/Order_details_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/presentation/widgets/steper_bar.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'dart:ui' as ui;
import '../../theme.dart';
import 'order_details.dart';

class OrderTrackingScreen extends StatefulWidget {
  final int orderMethodId;
  const OrderTrackingScreen({Key? key,required this.orderMethodId}) : super(key: key);
  @override
  _OrderTrackingState createState() => _OrderTrackingState();
}

class _OrderTrackingState extends State<OrderTrackingScreen> {
  late BitmapDescriptor mapMarker;
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
  void setCustomMarker() async {
    print("jjjjjjjjjjjjjjjj");
    final Uint8List markerIcon =
    await getBytesFromAsset('assets/images/locationn3.png', 200);
    mapMarker = BitmapDescriptor.fromBytes(markerIcon);
    marker = Marker(
        markerId: MarkerId("0"),
        icon: mapMarker,
        position: LatLng(double.parse(LocalStorage.getData(key: "branchLat")??"29.34243993398241") , double.parse(LocalStorage.getData(key: "branchLong")??"47.66755704490436")));
    //  markers.add(marker);
setState(() {

});
    //  markers.add(Marker(markerId: MarkerId("1"), position: LatLng(29.34243993398241, 47.66755704490436), icon:BitmapDescriptor.fromBytes(  await getBytesFromAsset('assets/images/logo.jpeg', 150))));

  }

  @override
  void initState() {
    // TODO: implement initState
    setCustomMarker();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;


    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: size.height * .01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 28,
                        color: AppTheme.secondary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Text(
                    LocaleKeys.order_tracking.tr(),
                    style: TextStyle(
                      fontSize: size.width * .05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  // SizedBox(width: 60,),
                ],
              ),
            ),
            Stack(
              //   alignment: Alignment.center,
              children: [
                SizedBox(
                  height: size.height * .86,
                  child: GoogleMap(
                    mapType: MapType.normal,
                    myLocationEnabled: true,
                    zoomControlsEnabled: false,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(double.parse(LocalStorage.getData(key: "branchLat")??"29.34243993398241") , double.parse(LocalStorage.getData(key: "branchLong")??"47.66755704490436")),
                      zoom: 10.0,
                    ),
                    markers: Set<Marker>.of(  <Marker>[marker]),
                    // markers: Set<Marker>.of(
                    //   <Marker>[context.read<StatusCubit>().marker!],
                    // ),
                    // onMapCreated: (GoogleMapController controller) {
                    //   context.read<OrderMethodCubit>().mapController = controller;
                    // },
                  ),
                ),
                BlocBuilder<StatusCubit, StatusState>(
                    builder: (context, state) {
                  if (state is StatusLoading) {
                    return Center(
                      child: Container(
                        height: size.height * 0.4,
                        width: size.width * 0.5,
                        alignment: Alignment.bottomCenter,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulse,
                          colors: const [
                            AppTheme.nearlyDarkBlue,
                            AppTheme.secondary,
                            AppTheme.nearlyBlue,
                          ],
                          strokeWidth: 3,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.white,
                        ),
                      ),
                    );
                  }
                  if (state is StatusLoaded) {
                    return SizedBox(
                      height: size.height * .86 ,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.height * .014,
                                vertical: size.height * .033),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.height * .02),
                              height: size.height * .11,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: (Colors.grey).withOpacity(0.6),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(7),
                              ),
                              child: StepsNavBar(
                                //  index: state.status.length,
                                status: state.status.statusIds!,
                              ),
                            ),
                          ),
Spacer(),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              margin: EdgeInsets.only(bottom: 20),
                              padding: EdgeInsets.only(bottom: 20),

                              height:  ( widget.orderMethodId == 2 )?size.height * .35:size.height * .24,
                              width: size.width,
                              decoration: BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: (Colors.grey).withOpacity(0.6),
                                      offset: const Offset(1.1, 4.0),
                                      blurRadius: 8.0),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(7),
                                    topRight: Radius.circular(7)),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: size.height * .03,
                                  ),
                                  Center(
                                    child: Text(
                                      state.status.lastStatusTitle!.en.toString(),
                                      style: TextStyle(
                                        height: size.width * .003,
                                        fontSize: size.width * .05,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: size.height * .03,
                                  ),
                                  Text(
                                    "${ LocaleKeys.your_order_will_be_done_in.tr()} ${state.status.durationTime} ${ LocaleKeys.min.tr()}",
                                    style: TextStyle(
                                      fontSize: size.width * .04,
                                      color: Colors.grey,
                                      height: size.width * .002,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  if( widget.orderMethodId == 2)
                                  SizedBox(
                                    height: size.height * .03,
                                  ),
                                if( widget.orderMethodId == 2)
                                  InkWell(
                                    onTap: () {
                                      print(  context
                                          .read<StatusCubit>().isFront);
                                      if(  state.status.statusIds!.last ==3){
                                      context
                                          .read<StatusCubit>()
                                          .frontBranch(int.parse(state
                                          .status.orderId
                                          .toString()),context);}
                                    },
                                    child: Container(
                                      height: size.height * .07,
                                      width:  size.width * .7,
                                      decoration: BoxDecoration(
                                        color:  state.status.statusIds!.last !=3?Colors.grey.withOpacity(.6) : AppTheme.orange,
                                        // borderRadius: BorderRadius.only(
                                        //     bottomRight: Radius.circular(7),
                                        //     bottomLeft: Radius.circular(7)),
                                      ),
                                      child: Center(
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [

                                            Text(
                                              LocaleKeys.front_branch.tr(),
                                              style: TextStyle(
                                                fontSize: size.width * .044,
                                                color: Colors.white,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                            InkWell(
                                              onTap:(){
                                                _showDialog(context);
                                              },
                                              child: Container(
                                                width: 25,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    color: AppTheme
                                                        .orange,
                                                    border: Border.all(
                                                        color: AppTheme
                                                            .orange,
                                                        width: 2)),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.info,
                                                    color: Colors
                                                        .white,
                                                    size: 20,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  if( widget.orderMethodId == 2 )
                                  SizedBox(
                                    height: size.height * .02,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: size.width * .45,
                                            child: InkWell(
                                              onTap: () {
                                                context
                                                    .read<StatusCubit>()
                                                    .trackOrder(int.parse(state
                                                        .status.orderId
                                                        .toString()));
                                              },
                                              child: Container(
                                                height: size.height * .07,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: AppTheme.secondary,
                                                  // borderRadius: BorderRadius.only(
                                                  //     bottomRight: Radius.circular(7),
                                                  //     bottomLeft: Radius.circular(7)),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    LocaleKeys.update.tr(),
                                                    style: TextStyle(
                                                      fontSize: size.width * .044,
                                                      color: Colors.white,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: size.width * .45,
                                            child: InkWell(
                                              onTap: () {
                                                push(
                                                  context,
                                                  BlocProvider<OrderDetailsCubit>(
                                                      create: (BuildContext
                                                              context) =>
                                                          OrderDetailsCubit(
                                                              OrderDetailsRepo(),
                                                              int.parse(state
                                                                  .status.orderId
                                                                  .toString())),
                                                      child:
                                                          OrderDetailsScreen()),
                                                );
                                              },
                                              child: Container(
                                                height: size.height * .07,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                    color: AppTheme.white,
                                                    border: Border.all(
                                                        color: AppTheme.secondary,
                                                        width: 2)
                                                    // borderRadius: BorderRadius.only(
                                                    //     bottomRight: Radius.circular(7),
                                                    //     bottomLeft: Radius.circular(7)),
                                                    ),
                                                child: Center(
                                                  child: Text(
                                                    LocaleKeys.order_details.tr(),
                                                    style: TextStyle(
                                                      fontSize: size.width * .044,
                                                      color: AppTheme.secondary,
                                                    ),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }
                  return SizedBox();
                })
              ],
            )
          ],
        ),
      ),
    );
  }
  Future _showDialog(context) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var we = MediaQuery.of(context).size.width;
        var he = MediaQuery.of(context).size.height;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: he*.02,),
                  Text( LocaleKeys.car_delivery.tr(),
                    style: TextStyle(
                      color: AppTheme.orange,
                      fontSize: we * .04,
                      height: he *.002,
                      fontWeight:
                      FontWeight.bold,
                    ),),
                  Text( LocaleKeys.car_i.tr(),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: we * .035,
                      fontWeight:
                      FontWeight.bold,
                    ),),
                  SizedBox(height: he*.02,),

                ],
              );
            },
          ),
        );
      },
    );
  }
}
