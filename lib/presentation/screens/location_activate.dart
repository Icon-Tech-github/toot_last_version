import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:app_settings/app_settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/widgets/default_button.dart';

import '../../bloc/auth_bloc/auth_cubit.dart';
import '../../data/repositories/auth_repo.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import 'package:video_player/video_player.dart';

import '../widgets/helper.dart';
import 'Auth_screens/login.dart';
import 'bottom_nav.dart';

class LocationActivate extends StatefulWidget {
  const LocationActivate({Key? key}) : super(key: key);

  @override
  _LocationActivateState createState() => _LocationActivateState();
}

class _LocationActivateState extends State<LocationActivate> {
  late VideoPlayerController videoPlayerController;

  double? lat;
  double? lng;
  Position? currentLocation;
  bool ?isLoad ;

  getLocationStatus() async {
    var status = await Geolocator.isLocationServiceEnabled();
    if (status) {
      setState(() {
        // هفعل السيركل عشان الفيو وهى هتطفى تانى من تحت وهقول ان فى صيدليات بعد ماكان الموقع مش متفعل
        getUserLocation();
      });
    } else {
      setState(() {
        //_showDialog(context);
      });
    }
  }



  setActiveLocation() async {
    var platform = Theme.of(context).platform;

    if (platform == TargetPlatform.iOS) {
      AppSettings.openAppSettings();
    } else {
      final AndroidIntent intent = new AndroidIntent(
        action: 'android.settings.LOCATION_SOURCE_SETTINGS',
      );
      await intent.launch().then((value) => getUserLocation);
    }
  }

  getUserLocation() async {
    // Position position = await Geolocator.getCurrentPosition();
    currentLocation = await locateUser();
    setState(() {
      LocalStorage.saveData(key: "lat", value: currentLocation!.latitude);
      LocalStorage.saveData(key: "lng", value: currentLocation!.longitude);

      lat = currentLocation!.latitude;
      lng = currentLocation!.longitude;
    });
  }

  Future<Position> locateUser() async {
    await Geolocator.requestPermission();
    return Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    videoPlayerController = VideoPlayerController.asset('assets/images/toot.mp4')
      ..initialize().then((_) {
        videoPlayerController.play();
        videoPlayerController.setLooping(
            true); // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: (){
        exit(0);
        return Future.value(false);
      },
      child: Scaffold(
        body:
        Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height ,
                  width: size.width,
                  child: AspectRatio(
                    aspectRatio: videoPlayerController.value.aspectRatio,
                    child: VideoPlayer(
                      videoPlayerController,
                    ),
                  ),
                )
              ],
            ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        padding: EdgeInsets.only(top: 30),

                        width: size.width,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(.8),
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(20),
                              topLeft: Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                LocaleKeys.share_location.tr(),
                                // product!.title!.en!,
                                style: TextStyle(
                                  height: size.height * 0.002,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * .07,
                                  letterSpacing: 0.2,
                                  color: AppTheme.nearlyBlack,
                                ),
                              ),

                              Text(
                                LocaleKeys.share_location_txt.tr(),
                                // product!.title!.en!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: size.height * 0.002,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: size.width * .042,
                                  letterSpacing: 0.2,
                                  color: Colors.black,
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              DefaultButton(
                                title:  LocaleKeys.login.tr(),
                                isLoad:  isLoad??false,
                                radius: 15,
                                borderColor: AppTheme.secondary,
                                color: AppTheme.secondary,
                                function: ()async {
                                  push(
                                      context,
                                      BlocProvider(
                                          create: (BuildContext context) =>
                                              AuthCubit(AuthRepo()),
                                          child: Login()));
                                },
                                textColor:  AppTheme.white,
                                font: size.width * .045,
                                height: size.height * .07,
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              DefaultButton(
                                title:  LocaleKeys.no_share.tr(),
                                isLoad:  isLoad??false,
                                radius: 15,
                                borderColor: AppTheme.secondary,
                                color: Colors.transparent,
                                function: ()async {
                                  pushReplacement(context, BottomNavBar());
                                },
                                textColor: AppTheme.secondary,
                                font: size.width * .045,
                                height: size.height * .07,
                              ),


                              SizedBox(
                                height: 40,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
          ],
        ),
        )
    );
  }
}
