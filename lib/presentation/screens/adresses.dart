import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:loz/bloc/address_bloc/address_cubit.dart';
import 'package:loz/bloc/time_bloc/time_cubit.dart';
import 'package:loz/data/repositories/delivery_time.dart';
import 'package:loz/presentation/screens/delivery_time.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../local_storage.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/helper.dart';
import '../widgets/loading.dart';
import 'confirm_order.dart';
import 'package:lottie/lottie.dart'as lottie;

class AddressScreen extends StatefulWidget {
  const AddressScreen({Key? key}) : super(key: key);

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
         // backgroundColor: AppTheme.background,
          body: Container(
            height: size.height,

            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightSec,
                  AppTheme.secondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.centerLeft,
              ),
            ),
            child: SafeArea(
              child: SingleChildScrollView(
                child: SizedBox(
                  // height: size.height,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: size.height * .01,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 9),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back_ios,
                                      size: size.width * .08,
                                      color: AppTheme.white,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                                Text(
                                  LocaleKeys.addresses2.tr(),
                                  style: TextStyle(
                                    fontSize: size.width * .07,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white
                                  ),
                                ),
                                // SizedBox(width: 60,),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: size.height * .01,
                          ),
                          BlocBuilder<AddressCubit, AddressState>(
                              builder: (context, state) {
                            if (state is AddressesLoading) {
                              return Center(
                                child: Container(
                                  height: size.height * 0.3,
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
                            if (state is AddressesLoaded) {

                              return        state.address.length ==0?
                                  Column(

                                    children: [
                                      SizedBox(height: size.height * .15,),
                                      Center(
                                        child:  lottie.Lottie.asset('assets/images/home.json',height: size.height * .2 ),
                                      ),
                                    ],
                                  ):

                              ListView.builder(
                                  itemCount: state.address.length,
                                  shrinkWrap: true,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap:(){
                                        context.read<AddressCubit>().chooseAddress(
                                            context.read<AddressCubit>()
                                                .allAddresses,
                                            index,context);
                                        setState(() {});
                                        //  Navigator.pop(context);
                                      },
                                      child: Container(
                                        height: size.height * .15,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 10),
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15, vertical: 10),
                                        decoration: BoxDecoration(
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey.withOpacity(0.3),
                                                offset: const Offset(1.1, 2.0),
                                                blurRadius: 5.0),
                                          ],
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 10),
                                              //  width: size.width *.6,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: AppTheme.secondary,
                                                  border: Border.all(
                                                      color: AppTheme.lightSec,
                                                      width: 7)
                                                  //borderRadius: BorderRadius.circular(20),
                                                  ),
                                              child: Icon(
                                                Icons.location_on,
                                                color: Colors.white,
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * .02,
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: size.width * .18 ,
                                                  child: Text(
                                                    state.address[index].title.toString(),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontSize: size.height * 0.022,
                                                        height: size.height * 0.002,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * .01,
                                                ),
                                                SizedBox(
                                                  width: size.width * .4,
                                                  child: Text(
                                                    state.address[index].notes.toString(),
                                                    maxLines: 1,
                                                    overflow: TextOverflow.ellipsis,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: size.height * 0.018,
                                                      height: size.height * 0.002,
                                                      //  fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: size.height * .02,
                                                ),
                                                if(state.address[index].defaultAddress == 1)
                                                  Container(
                                                      padding: EdgeInsets.symmetric(vertical: 5,horizontal: 7),
                                                      decoration: BoxDecoration(
                                                        color: Colors.grey.withOpacity(.2),
                                                        //  border: Border.all(width: 4,color: Colors.white),
                                                        borderRadius:  BorderRadius.circular(5),
                                                      ),
                                                      child: Center(child: Text( LocaleKeys.default_word.tr() ,
                                                        style: TextStyle( fontSize: size.width * .03,color: Colors.green, height:  size.height*0.002,fontWeight: FontWeight.bold),)))
                                              ],
                                            ),
                                            SizedBox(
                                              width: size.width * .01,
                                            ),
                                            Container(
                                              //   width: 23,
                                              height: 25,
                                              decoration: BoxDecoration(
                                                  shape: BoxShape
                                                      .circle,
                                                  color: state.address[index].chosen ??
                                                      false
                                                      ? AppTheme
                                                      .secondary
                                                      : Colors
                                                      .white,
                                                  border: Border.all(
                                                      color: state.address[index].chosen ??
                                                          false
                                                          ? AppTheme
                                                          .secondary
                                                          : Colors
                                                          .grey,
                                                      width:
                                                      2)),
                                              child:
                                              const Center(
                                                child: Icon(
                                                  Icons.check,
                                                  color: Colors
                                                      .white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: size.width * .01,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                                              child: VerticalDivider(thickness: 1.5,),
                                            ),
                                            GestureDetector(
                                              onTap: ()async{
                                                context.read<AddressCubit>().radioSelected=state.address[index].defaultAddress ==0?false:true;
                                                context.read<AddressCubit>().markerTapped =
                                                false;
                                                if (context.read<AddressCubit>()
                                                    .markerTapped ==
                                                    false)
                                                  LoadingScreen.show(
                                                      context);
                                                // method.currentLocation =

                                                  setState(() {
                                                    print(state.address[index].lat
                                                        );

                                                    context.read<AddressCubit>().markerTapped =
                                                    true;
                                                    context.read<AddressCubit>().marker = context.read<AddressCubit>()
                                                        .createMarker(
                                                      double.parse(state.address[index].lat.toString()),
                                                        double.parse(state.address[index].long.toString())
                                                    );
                                                    context.read<AddressCubit>().lat =
                                                        double.parse(state.address[index].lat.toString());
                                                    context.read<AddressCubit>().lng =
                                                        double.parse(state.address[index].long.toString());
                                                  });

                                                if (context.read<AddressCubit>()
                                                    .markerTapped ==
                                                    false)
                                                  LoadingScreen.show(
                                                      context);
                                                else {
                                                  Navigator.pop(
                                                      context);
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                      Colors
                                                          .transparent,
                                                      context: context,
                                                      builder: (modal) {
                                                        return BlocProvider
                                                            .value(
                                                          value: BlocProvider.of<
                                                              AddressCubit>(
                                                              context),
                                                          child:
                                                          StatefulBuilder(
                                                            builder:
                                                                (BuildContext context, setState) =>
                                                                GestureDetector(
                                                                  onTap: (){
                                                                    FocusScope.of(context).requestFocus(FocusNode());

                                                                  },
                                                                  child: Container(
                                                                    height: size.height *
                                                                        0.88,
                                                                    decoration: const BoxDecoration(
                                                                        color:
                                                                        Colors.white,
                                                                        borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                                                    child:
                                                                    Form(
                                                                      key: context.read<AddressCubit>()
                                                                          .editForm,
                                                                      child:
                                                                      Column(
                                                                        mainAxisAlignment:
                                                                        MainAxisAlignment.start,
                                                                        crossAxisAlignment:
                                                                        CrossAxisAlignment.start,
                                                                        children: [
                                                                          SizedBox(
                                                                            height: 30,
                                                                          ),
                                                                          Padding(
                                                                            padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                                            child: Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  LocaleKeys.edit_address.tr(),
                                                                                  style: TextStyle(fontSize: size.height * 0.02),
                                                                                ),
                                                                                Align(
                                                                                  alignment: Alignment.bottomRight,
                                                                                  child: InkWell(
                                                                                    onTap: () {
                                                                                      FocusScope.of(context).requestFocus(FocusNode());
                                                                                      context.read<AddressCubit>().editAddress(context, state.address[index].id!);
                                                                                    },
                                                                                    child: Padding(
                                                                                      padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                                                                                      child: CircleAvatar(
                                                                                        backgroundColor: AppTheme.orange,
                                                                                        radius: size.height * .03,
                                                                                        // Image radius
                                                                                        child: Icon(
                                                                                          Icons.done,
                                                                                          size: size.height * .04,
                                                                                          color: Colors.white,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )
                                                                              ],
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: size.height * .03,
                                                                          ),
                                                                          Center(
                                                                            child: SizedBox(
                                                                              width: size.width * .8,
                                                                              height: size.height * .1,
                                                                              child: TextFormField(
                                                                                initialValue: state.address[index].title??"",
                                                                                maxLength: 20,

                                                                                //   controller: context.read<AddressCubit>().addressTitle,
                                                                                cursorColor: AppTheme.orange,
                                                                                decoration: InputDecoration(
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(25.0),
                                                                                    borderSide: BorderSide(
                                                                                      color: AppTheme.orange,
                                                                                    ),
                                                                                  ),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(25.0),
                                                                                    borderSide: BorderSide(
                                                                                      color: AppTheme.orange,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                  ),
                                                                                  label: Text(
                                                                                    LocaleKeys.title.tr(),
                                                                                    style: TextStyle(color: AppTheme.orange, fontSize: size.height * 0.017),
                                                                                  ),
                                                                                  //     border:
                                                                                  //     OutlineInputBorder(
                                                                                  //   borderSide: BorderSide(color:  AppTheme
                                                                                  //       .orange, width: 5.0),
                                                                                  // ),
                                                                                ),
                                                                                onSaved: (value){
                                                                                  context.read<AddressCubit>().editAddressTitle=value!;
                                                                                },
                                                                                validator: (value) {
                                                                                  if (value == null || value.isEmpty) {
                                                                                    return LocaleKeys.Required.tr();
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                onEditingComplete: () {
                                                                                  FocusScope.of(context).requestFocus(FocusNode());

                                                                                  //  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: size.height * .03,
                                                                          ),
                                                                          Center(
                                                                            child: SizedBox(
                                                                              width: size.width * .8,
                                                                              height: size.height * .12,
                                                                              child: TextFormField(
                                                                                initialValue: state.address[index].notes,
                                                                               // controller: context.read<AddressCubit>().addressDis,
                                                                                cursorColor: AppTheme.orange,
                                                                                maxLines: 4,
                                                                                decoration: InputDecoration(
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(25.0),
                                                                                    borderSide: BorderSide(
                                                                                      color: AppTheme.orange,
                                                                                    ),
                                                                                  ),
                                                                                  enabledBorder: OutlineInputBorder(
                                                                                    borderRadius: BorderRadius.circular(25.0),
                                                                                    borderSide: BorderSide(
                                                                                      color: AppTheme.orange,
                                                                                      width: 2.0,
                                                                                    ),
                                                                                  ),
                                                                                  label: Text(
                                                                                    LocaleKeys.address_des.tr(),
                                                                                    style: TextStyle(color: AppTheme.orange, fontSize: size.height * 0.017),
                                                                                  ),
                                                                                  //     border:
                                                                                  //     OutlineInputBorder(
                                                                                  //   borderSide: BorderSide(color:  AppTheme
                                                                                  //       .orange, width: 5.0),
                                                                                  // ),
                                                                                ),
                                                                                onSaved: (value){
                                                                                  context.read<AddressCubit>().editAddressDis=value!;
                                                                                },
                                                                                validator: (value) {
                                                                                  if (value == null || value.isEmpty) {
                                                                                    return LocaleKeys.Required.tr();
                                                                                  }
                                                                                  return null;
                                                                                },
                                                                                onEditingComplete: () {
                                                                                  FocusScope.of(context).requestFocus(FocusNode());

                                                                                  //  Navigator.pop(context);
                                                                                },
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          SizedBox(
                                                                            height: size.height * .01,
                                                                          ),
                                                                          SizedBox(
                                                                            //    height: size.height * .1,
                                                                            child: CheckboxListTile(
                                                                              activeColor: AppTheme.secondary,
                                                                              title: GestureDetector(
                                                                                  onTap: () {},
                                                                                  child: Text(
                                                                                    LocaleKeys.default_address.tr(),
                                                                                    style: TextStyle(fontSize: size.height * .02,height: size.height * .002),
                                                                                  )),
                                                                              value: context.read<AddressCubit>().radioSelected,
                                                                              onChanged: (newValue) {
                                                                                setState(() {
                                                                                  context.read<AddressCubit>().radioSelected = newValue!;
                                                                                  print( context.read<AddressCubit>().radioSelected);
                                                                                });
                                                                              },
                                                                              controlAffinity: ListTileControlAffinity
                                                                                  .leading, //  <-- leading Checkbox
                                                                            ),
                                                                          ),
                                                                          if (context.read<AddressCubit>().markerTapped == false)
                                                                            Center(
                                                                              child: Padding(
                                                                                padding: const EdgeInsets.only(top: 8.0),
                                                                                child: Text(
                                                                                  'Your Location loading ...',
                                                                                  style: TextStyle(color: AppTheme.orange, fontSize: 16),
                                                                                ),
                                                                              ),
                                                                            )
                                                                          else
                                                                            Container(
                                                                              height: size.height * .33,
                                                                              padding: const EdgeInsets.only(top: 16.0, right: 28.0, left: 28.0),
                                                                              child: ClipRRect(
                                                                                borderRadius: BorderRadius.circular(20.0),
                                                                                child: GoogleMap(
                                                                                  mapType: MapType.normal,
                                                                                  myLocationEnabled: true,
                                                                                  zoomControlsEnabled: false,
                                                                                  gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                                                                                  onTap: (location) {
                                                                                    FocusScope.of(context).requestFocus(new FocusNode());
                                                                                    setState(() {
                                                                                      context.read<AddressCubit>().marker = context.read<AddressCubit>().createMarker(location.latitude, location.longitude);
                                                                                      context.read<AddressCubit>().lat = location.latitude;
                                                                                      context.read<AddressCubit>().lng = location.longitude;
                                                                                      print(location.latitude);
                                                                                    });
                                                                                  },
                                                                                  initialCameraPosition: CameraPosition(
                                                                                    target: LatLng(double.parse(state.address[index].lat.toString()), double.parse(state.address[index].long.toString())),
                                                                                    zoom: 14.0,
                                                                                  ),
                                                                                  markers: Set<Marker>.of(
                                                                                    <Marker>[
                                                                                      context.read<AddressCubit>().marker!
                                                                                    ],
                                                                                  ),
                                                                                  onMapCreated: (GoogleMapController controller) {
                                                                                    context.read<AddressCubit>().mapController = controller;
                                                                                  },
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          SizedBox(
                                                                            height: size.height * .06,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                          ),
                                                        );
                                                      })
                                                      .then((value) => {
                                                    setState(
                                                            () {})
                                                  });
                                                }
                                              },
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Image.asset("assets/images/writing.png",height:  size.height * .03,color: AppTheme.secondary,),
                                                ))
                                           // Icon(Icons.edit,color: AppTheme.secondary,size: size.height * .03)
                                          ],
                                        ),
                                      ),
                                    );
                                  });
                            }
                            return SizedBox();
                          }),
                          SizedBox(
                            height: size.height * .3,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 0,
          child: Container(
            height: size.height * .27,
            width: size.width,
            decoration: BoxDecoration(
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    offset: const Offset(1.1, 2.0),
                    blurRadius: 5.0),
              ],
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: size.height * .05,
                ),
                DefaultButton(
                  function: () async{
                    context.read<AddressCubit>().markerTapped =
                    false;
                    if (context.read<AddressCubit>()
                        .markerTapped ==
                        false)
                      LoadingScreen.show(
                          context);
                    // method.currentLocation =
                    await context.read<AddressCubit>()
                        .locateUser()
                        .then((value) {
                      setState(() {
                        print(
                            value.latitude);
                        context.read<AddressCubit>().currentLocation =
                            value;
                        context.read<AddressCubit>().markerTapped =
                        true;
                        context.read<AddressCubit>().marker = context.read<AddressCubit>()
                            .createMarker(
                          value.latitude,
                          value.longitude,
                        );
                        context.read<AddressCubit>().lat =
                            value.latitude;
                        context.read<AddressCubit>().lng =
                            value.longitude;
                      });
                    });
                    if (context.read<AddressCubit>()
                        .markerTapped ==
                        false)
                      LoadingScreen.show(
                          context);
                    else {
                      Navigator.pop(
                          context);
                      showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor:
                          Colors
                              .transparent,
                          context: context,
                          builder: (modal) {
                            return BlocProvider
                                .value(
                              value: BlocProvider.of<
                                  AddressCubit>(
                                  context),
                              child:
                              StatefulBuilder(
                                builder:
                                    (BuildContext context, setState) =>
                                    GestureDetector(
                                      onTap: (){
                                        FocusScope.of(context).requestFocus(FocusNode());

                                      },
                                      child: Container(
                                        height: size.height *
                                            0.88,
                                        decoration: const BoxDecoration(
                                            color:
                                            Colors.white,
                                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20))),
                                        child:
                                        Form(
                                          key: context.read<AddressCubit>()
                                              .formKey2,
                                          child:
                                          Column(
                                            mainAxisAlignment:
                                            MainAxisAlignment.start,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(
                                                height: 30,
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Text(
                                                      LocaleKeys.add_address.tr(),
                                                      style: TextStyle(fontSize: size.height * 0.02),
                                                    ),
                                                    Align(
                                                      alignment: Alignment.bottomRight,
                                                      child: InkWell(
                                                        onTap: () {
                                                          FocusScope.of(context).requestFocus(FocusNode());
                                                          context.read<AddressCubit>().addAddress(context);
                                                        },
                                                        child: Padding(
                                                          padding: const EdgeInsets.only(right: 20.0, bottom: 10),
                                                          child: CircleAvatar(
                                                            backgroundColor: AppTheme.orange,
                                                            radius: size.height * .03,
                                                            // Image radius
                                                            child: Icon(
                                                              Icons.done,
                                                              size: size.height * .04,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.height * .03,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: size.width * .8,
                                                  height: size.height * .1,
                                                  child: TextFormField(
                                                    maxLength: 20,
                                                    controller: context.read<AddressCubit>().addressTitle,
                                                    cursorColor: AppTheme.orange,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(25.0),
                                                        borderSide: BorderSide(
                                                          color: AppTheme.orange,
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(25.0),
                                                        borderSide: BorderSide(
                                                          color: AppTheme.orange,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      label: Text(
                                                        LocaleKeys.title.tr(),
                                                        style: TextStyle(color: AppTheme.orange, fontSize: size.height * 0.017),
                                                      ),
                                                      //     border:
                                                      //     OutlineInputBorder(
                                                      //   borderSide: BorderSide(color:  AppTheme
                                                      //       .orange, width: 5.0),
                                                      // ),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return LocaleKeys.Required.tr();
                                                      }
                                                      return null;
                                                    },
                                                    onEditingComplete: () {
                                                      FocusScope.of(context).requestFocus(FocusNode());

                                                      //  Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.height * .03,
                                              ),
                                              Center(
                                                child: SizedBox(
                                                  width: size.width * .8,
                                                  height: size.height * .12,
                                                  child: TextFormField(
                                                    controller: context.read<AddressCubit>().addressDis,
                                                    cursorColor: AppTheme.orange,
                                                    maxLines: 4,
                                                    decoration: InputDecoration(
                                                      focusedBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(25.0),
                                                        borderSide: BorderSide(
                                                          color: AppTheme.orange,
                                                        ),
                                                      ),
                                                      enabledBorder: OutlineInputBorder(
                                                        borderRadius: BorderRadius.circular(25.0),
                                                        borderSide: BorderSide(
                                                          color: AppTheme.orange,
                                                          width: 2.0,
                                                        ),
                                                      ),
                                                      label: Text(
                                                        LocaleKeys.address_des.tr(),
                                                        style: TextStyle(color: AppTheme.orange, fontSize: size.height * 0.017),
                                                      ),
                                                      //     border:
                                                      //     OutlineInputBorder(
                                                      //   borderSide: BorderSide(color:  AppTheme
                                                      //       .orange, width: 5.0),
                                                      // ),
                                                    ),
                                                    validator: (value) {
                                                      if (value == null || value.isEmpty) {
                                                        return LocaleKeys.Required.tr();
                                                      }
                                                      return null;
                                                    },
                                                    onEditingComplete: () {
                                                      FocusScope.of(context).requestFocus(FocusNode());

                                                      //  Navigator.pop(context);
                                                    },
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                height: size.height * .01,
                                              ),
                                              SizedBox(
                                            //    height: size.height * .1,
                                                child: CheckboxListTile(
                                                  activeColor: AppTheme.secondary,
                                                  title: GestureDetector(
                                                      onTap: () {},
                                                      child: Text(
                                                        LocaleKeys.default_address.tr(),
                                                        style: TextStyle(fontSize: size.height * .02,height: size.height * .002),
                                                      )),
                                                  value: context.read<AddressCubit>().radioSelected,
                                                  onChanged: (newValue) {
                                                    setState(() {
                                                      context.read<AddressCubit>().radioSelected = newValue!;
                                                      print( context.read<AddressCubit>().radioSelected);
                                                    });
                                                  },
                                                  controlAffinity: ListTileControlAffinity
                                                      .leading, //  <-- leading Checkbox
                                                ),
                                              ),
                                              if (context.read<AddressCubit>().markerTapped == false)
                                                Center(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8.0),
                                                    child: Text(
                                                      'Your Location loading ...',
                                                      style: TextStyle(color: AppTheme.orange, fontSize: 16),
                                                    ),
                                                  ),
                                                )
                                              else
                                                Container(
                                                  height: size.height * .33,
                                                  padding: const EdgeInsets.only(top: 16.0, right: 28.0, left: 28.0),
                                                  child: ClipRRect(
                                                    borderRadius: BorderRadius.circular(20.0),
                                                    child: GoogleMap(
                                                      mapType: MapType.normal,
                                                      myLocationEnabled: true,
                                                      zoomControlsEnabled: false,
                                                      gestureRecognizers: Set()..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                                                      onTap: (location) {
                                                        FocusScope.of(context).requestFocus(new FocusNode());
                                                        setState(() {
                                                          context.read<AddressCubit>().marker = context.read<AddressCubit>().createMarker(location.latitude, location.longitude);
                                                          context.read<AddressCubit>().lat = location.latitude;
                                                          context.read<AddressCubit>().lng = location.longitude;
                                                          print(location.latitude);
                                                        });
                                                      },
                                                      initialCameraPosition: CameraPosition(
                                                        target: LatLng(context.read<AddressCubit>().currentLocation?.latitude ?? LocalStorage.getData(key: 'lat'), context.read<AddressCubit>().currentLocation?.longitude ?? LocalStorage.getData(key: 'long')),
                                                        zoom: 14.0,
                                                      ),
                                                      markers: Set<Marker>.of(
                                                        <Marker>[
                                                          context.read<AddressCubit>().marker!
                                                        ],
                                                      ),
                                                      onMapCreated: (GoogleMapController controller) {
                                                        context.read<AddressCubit>().mapController = controller;
                                                      },
                                                    ),
                                                  ),
                                                ),
                                              SizedBox(
                                                height: size.height * .06,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                              ),
                            );
                          })
                          .then((value) => {
                        setState(
                                () {})
                      });
                    }
                  },
                  title: LocaleKeys.add_address.tr(),
                  color: Colors.white,
                  borderColor: AppTheme.secondary,
                  radius: 10,
                  textColor: AppTheme.secondary,
                  font: size.width * .05,
                ),
                SizedBox(
                  height: size.height * .05,
                ),
                DefaultButton(
                  function: () {
                  if(LocalStorage.getData(key: "addressId") == null){
                    showTopSnackBar(
                        context,
                        Card(
                          child: CustomSnackBar.success(
                            message: LocaleKeys.Please_add_address.tr(),
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.02),
                          ),
                        ));
                  }else{
                    int? index ;
                    for (int i = 0;
                    i < context.read<AddressCubit>().allAddresses.length;
                    i++) {
                      if (context
                          .read<AddressCubit>()
                          .allAddresses[i]
                          .id ==
                          LocalStorage.getData(key: "addressId") ) {

                        index = i;
                      }
                    }
                    LocalStorage.saveData(key: "deliveryFee", value:LocalStorage.getData(key: "order_method_id") == 3?
                    context
                        .read<AddressCubit>()
                        .allAddresses[index!]
                        .freeToday == true?
                    0:
                    context
                        .read<AddressCubit>()
                        .allAddresses[index]
                        .deliveryFee:0);
                    push(
                      context,
                      BlocProvider<TimeBlocCubit>(
                          create: (BuildContext context) =>
                              TimeBlocCubit(DeliveryTimeRepo()),
                          child: DeliveryTimeScreen(
                            delivery_fee: LocalStorage.getData(key: "order_method_id") == 3?
                            context
                                .read<AddressCubit>()
                                .allAddresses[index!]
                                .freeToday == true?
                            0:
                            context
                                .read<AddressCubit>()
                                .allAddresses[index]
                                .deliveryFee:0,
                            freeToday:  context
                                .read<AddressCubit>()
                                .allAddresses[index!]
                                .freeToday == true?
                            true:false,

                          )),
                    );
                    // push(
                    //     context,
                    //     ConfirmOrderScreen(
                    //   //    discount: descount,
                    //       delivery_fee: LocalStorage.getData(key: "order_method_id") == 3?
                    //       context
                    //           .read<AddressCubit>()
                    //           .allAddresses[index!]
                    //           .freeToday == true?
                    //           0:
                    //       context
                    //           .read<AddressCubit>()
                    //           .allAddresses[index]
                    //           .deliveryFee:0,
                    //       freeToday:  context
                    //           .read<AddressCubit>()
                    //           .allAddresses[index!]
                    //           .freeToday == true?
                    //       true:false,
                    //     ));
                  }
                  },
                  title: LocaleKeys.next.tr(),
                  color: AppTheme.secondary,
                  radius: 10,
                  textColor: AppTheme.white,
                  font: size.width * .05,
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
