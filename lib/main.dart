import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/data/repositories/branch_repo.dart';



import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/presentation/screens/bottom_nav.dart';
import 'package:loz/presentation/screens/location_activate.dart';
import 'package:loz/theme.dart';
import 'package:overlay_support/overlay_support.dart';
import 'dart:ui' as ui;
import 'bloc/home/departments_bloc/departments_cubit.dart';
import 'bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'data/repositories/notification_repo.dart';
import 'local_storage.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await LocalStorage.init();
  await Firebase.initializeApp();
  print( ui.window.locale.languageCode);
  if(LocalStorage.getData(key: "lang") == null)
  LocalStorage.saveData(key: "lang", value:  ui.window.locale.languageCode);

  BlocOverrides.runZoned(
        () => runApp(
            EasyLocalization(
                path: "assets/translations",
                supportedLocales: [
                  Locale("en"),
                  Locale("ar"),
                ],
                fallbackLocale: Locale('en'),
              //  assetLoader: CodegenLoader(),
               // startLocale: Locale("en"),
                saveLocale: true,
                child: MyApp())
        ),

  );
  // runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key,}) : super(key: key);
  //final AnimationController? animationController;
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>
    with TickerProviderStateMixin {
  AnimationController? animationController;

//  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: AppTheme.background,
  );

  @override
  void initState() {
    // tabIconsList.forEach((TabIconData tab) {
    //   tab.isSelected = false;
    // });
    // tabIconsList[0].isSelected = true;
    print(' يعقوب قمر الدين دبيازه ');

    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
   // tabBody = MyDiaryScreen(animationController: animationController);
    super.initState();
  }

  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return OverlaySupport.global(
      child: MaterialApp(
        localizationsDelegates: context.localizationDelegates,
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        theme: ThemeData(
          fontFamily: context.locale.toString() == 'ar'? 'aref':'aref'
        ),
      //   home:  LocalStorage.getData(
      //   key: 'token',
      // ) == null?
      //   BlocProvider(
      //       create: (BuildContext context) =>
      //           AuthCubit(AuthRepo()),
      //       child: Login()):
        home:LocalStorage.getData(
          key: 'token',
        ) == null? LocationActivate():BottomNavBar(),
 // home:     MultiBlocProvider(
 //          providers: [
 //            BlocProvider<HomeAdCubit>(
 //              create: (BuildContext context) => HomeAdCubit(GetHomeRepository()),
 //            ),
 //            BlocProvider<DepartmentsCubit>(
 //              create: (BuildContext context) => DepartmentsCubit(GetHomeRepository()),
 //            ),
 //          ],
 //
 //          child: BottomNavBar(),
 //        ),
        debugShowCheckedModeBanner: false,
      //   home: MultiBlocProvider(
      //     providers: [
      //       BlocProvider<HomeAdCubit>(
      //         create: (BuildContext context) => HomeAdCubit(GetHomeRepository()),
      //       ),
      //       BlocProvider<DepartmentsCubit>(
      //       create: (BuildContext context) => DepartmentsCubit(GetHomeRepository()),
      // ),
      //     ],
      //
      //     child: BottomNavBar(),
      //   ),

      ),
    );
  }
}


