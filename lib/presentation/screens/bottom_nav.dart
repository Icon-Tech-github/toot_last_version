
import 'dart:async';
import 'dart:io';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/shims/dart_ui_real.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:loz/bloc/notify_bloc/home_notify_cubit.dart';

import 'package:loz/bloc/orders_bloc/orders_bloc_cubit.dart';
import 'package:loz/bloc/single_product_bloc/single_product_cubit.dart';
import 'package:loz/data/models/branch_model.dart';

import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/data/repositories/orders_repo.dart';

import 'package:loz/local_storage.dart';
import 'package:loz/presentation/screens/cart.dart';
import 'package:loz/presentation/screens/fav.dart';
import 'package:loz/presentation/screens/map.dart';
import 'package:loz/presentation/screens/more.dart';
import 'package:loz/presentation/screens/rating.dart';
import 'package:loz/presentation/screens/track_order.dart';

import 'package:loz/translations/locale_keys.g.dart';
import 'package:overlay_support/overlay_support.dart';


import '../../bloc/notification_bloc/notification_cubit.dart';
import '../../bloc/rate_bloc/rate_cubit.dart';
import '../../bloc/status_bloc/status_cubit.dart';
import '../../data/repositories/notification_repo.dart';
import '../../data/repositories/rating_repo.dart';
import '../../data/repositories/tracking_repo.dart';
import '../../theme.dart';
import '../widgets/helper.dart';
import 'home.dart';

import 'notifications.dart';
import 'order_tracking.dart';
import 'orders.dart';


class BottomNavBar extends StatefulWidget {
  int? index;
  bool? fromSplash = false;
  BottomNavBar({this.index,this.fromSplash});
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with TickerProviderStateMixin , WidgetsBindingObserver
{

  int? currentTab =2;
  bool isLogin = false;
  AnimationController? animationController;
  int ? cartCount =0;


  Widget tabBody = Container(
    color: AppTheme.background,
  );




  final List<IconData> iconList = [
    FontAwesomeIcons.home,
    FontAwesomeIcons.solidHeart,
    // Icons.bookmark_border,
    FontAwesomeIcons.userCog,
  ];



  bool d = false;

  DateTime? currentBackPressTime;
  static  int count =0;


  @override
  void initState() {
  //  checkForInitialMessage();
    getCartCount();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 600), vsync: this);
    count++;
    if(widget.index==null)
      currentTab = 2;
    else
      currentTab = widget.index;

    WidgetsBinding.instance.addObserver(this);
   fcmNotification();
    super.initState();
  }
  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

bool isClosed= false;
  bool isFromBackground= false;
  late AppLifecycleState _lastState;
  //@override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //
  //   if (state == AppLifecycleState.resumed && _lastState == AppLifecycleState.paused) {
  //     setState(() {
  //
  //     });
  //     //now you know that your app went to the background and is back to the foreground
  //   }
  //   _lastState = state;
  //   switch (state) {
  //     case AppLifecycleState.resumed:
  //       print("app in resumed");
  //       break;
  //     case AppLifecycleState.inactive:
  //       print("app in inactive");
  //       break;
  //     case AppLifecycleState.paused:
  //       print("app in paused");
  //       break;
  //     case AppLifecycleState.detached:
  //       print("app in detached");
  //       break;
  //   }
  // }
  void getCartCount() {
    List<String> cart = LocalStorage.getList(key: 'cart') ?? [];
    cartCount = cart.length;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  fcmNotification() async {




    NotificationSettings settings =
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

//   FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
      print("33333");

      RemoteNotification notification = message.notification!;
     AndroidNotification android = message.notification!.android!;

      if (notification != null && android != null) {
        LocalStorage.getData(key: 'lang') == 'en'?
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
           message.data['title_en'],
        message.data['description_en'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                message.data['title_en'],
                message.data['description_en'],
                icon: 'resource://mipmap/launcher_icon',
              ),
            )):
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            message.data['title_ar'],
            message.data['description_ar'],
            NotificationDetails(
              android: AndroidNotificationDetails(
                message.data['title_ar'],
                message.data['description_ar'],
                icon: '@mipmap/launcher_icon',
              ),
            ));
        print(message.data['description_en'].toString()+"kjjjjjjjjjjj");
        if (message.data['order_id'] == null) {

          showSimpleNotification(
              InkWell(
                onTap: () {
                  push(
                    context,
                    BlocProvider<NotificationCubit>(
                        create: (BuildContext
                        context) =>
                            NotificationCubit(
                                NotificationRepo()),
                        child:
                        NotifyScreen()),
                  );
                },
                child: Container(
                  height: 65,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        children: [
                          Text(
                      LocalStorage.getData(key: 'lang') ==
                          'en'? message.data['title_en']: message.data['title_ar'],
                            style: TextStyle(
                                color:AppTheme.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                          // SizedBox(
                          //   height: 5,
                          // ),
                          // Text(
                          //   message.notification!.body!,
                          //   style: TextStyle(
                          //       color: HomePage.colorGreen,
                          //       fontSize: 14,
                          //       fontWeight: FontWeight.bold),
                           // ),
                        ],
                      )),
                ),
              ),
              duration: Duration(seconds: 3),
              background:AppTheme.white,
              elevation: 3
          );
          await NotificationRepo.getUnreadCount().then((data) {
            NotificationRepo.unReadCount = int.parse(data.toString());
            LocalStorage.saveData(key: "unReadCount", value:  int.parse(data.toString()));
            print(NotificationRepo.unReadCount.toString() +"ssssssssss");
          });
        } else if (message.data['order_id'] != null && message.data['type'].toString() == "1") {
          showSimpleNotification(
              InkWell(
                onTap: () {
                  push(context,
                      BlocProvider(
                          create: (BuildContext context) => StatusCubit(TrackingOrderRepo(),int.parse(message.data['order_id'].toString()),int.parse(message.data['order_method_id'].toString())),
                          child: TrackOrderScreen(orderMethodId: int.parse(message.data['order_method_id'].toString()))));
                },
                child: Container(
                  height: 70,
                  child: Padding(
                      padding: const EdgeInsets.only(top: 5.0),
                      child: Column(
                        children: [
                          Text(
                            LocalStorage.getData(key: 'lang') ==
                                'en'? message.data['title_en']: message.data['title_ar'],
                            style: TextStyle(
                                color:AppTheme.orange,
                                fontSize: 16,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            LocalStorage.getData(key: 'lang') ==
                                'en'? message.data['description_en']: message.data['description_ar'],
                            style: TextStyle(
                                color: AppTheme.orange,
                                fontSize: 14,
                                height: 1,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      )),
                ),
              ),
              duration: Duration(seconds: 3),
              background:AppTheme.white,
              elevation: 3
          );

        } else if (message.data['order_id'] != null && message.data['type'].toString() == "2") {
                    push(
                      context,
                      BlocProvider<RateCubit>(
                          create: (BuildContext
                          context) =>
                              RateCubit(
                                  RatingRepo()),
                          child:
                          RatingScreen(orderId:int.parse(message.data['order_id'],))),
                    );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('33333ss');
      if (message.data['order_id'] == null) {
        push(
          context,
          BlocProvider<NotificationCubit>(
              create: (BuildContext
              context) =>
                  NotificationCubit(
                      NotificationRepo()),
              child:
              NotifyScreen()),
        );
      }else if (message.data['order_id'] != null && message.data['type'].toString() == "1") {
        push(context,
            BlocProvider(
                create: (BuildContext context) => StatusCubit(TrackingOrderRepo(),int.parse(message.data['order_id'].toString(),),int.parse(message.data['order_method_id'].toString())),
                child: TrackOrderScreen(orderMethodId:int.parse( message.data['order_method_id'].toString()),)));
      } else if (message.data['order_id'] != null && message.data['type'].toString() == "2") {
        push(
          context,
          BlocProvider<RateCubit>(
              create: (BuildContext
              context) =>
                  RateCubit(
                      RatingRepo()),
              child:
              RatingScreen(orderId:int.parse(message.data['order_id'],))),
        );
      }
    });

  }

  Future<bool> onWillPop() {
    if(currentTab!=2) {
      setState(() {
        currentTab = 2;
      });
      return Future.value(false);
    } else
    {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime!) > Duration(seconds: 2)) {
        currentBackPressTime = now;
        Fluttertoast.showToast(msg: 'Double Tap To Exit');
        return Future.value(false);
      } else
        exit(0);
    }
  }
  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      BlocProvider<AuthCubit>(
          create: (BuildContext context) => AuthCubit(AuthRepo()),
          child: MoreScreen()),
    BlocProvider<OrdersBlocCubit>(
    create: (BuildContext context) => OrdersBlocCubit(OrdersRepo()),
    child: OrderScreen()),
      HomeScreen(animationController: animationController,fromSplash: widget.fromSplash,),
      CartScreen(fromHome: true,),
      FavoriteScreen(animationController: animationController)
    // MapScreen(branches: widget.branches,)
     //FavoriteScreen(animationController: animationController,),


    ];
    var size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        body: _screens[currentTab!],
        bottomNavigationBar: FlashyTabBar(
          selectedIndex: currentTab!,
          height: 66,
          showElevation: true,
          // color: AppTheme.white,
          // backgroundColor: AppTheme.nearlyWhite,
          backgroundColor: Colors.white,
          animationCurve: Curves.easeInOut,
          animationDuration: Duration(milliseconds: 600),
          onItemSelected: (index) {
            setState(() {
              currentTab = index;
              if(index == 2){
                widget.fromSplash =false;
              }
            });
            //  print(provider.currentIndex.toString()+'dkfbdifudbfiub');
          },
          items: [

            FlashyTabBarItem(
              icon: Icon(Icons.menu),
              title: Text(LocaleKeys.more.tr()),

              activeColor: AppTheme.secondary,
              inactiveColor: Colors.grey
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.bookmark),
              title: Text(LocaleKeys.orders.tr()),
                activeColor: AppTheme.secondary,
                inactiveColor: Colors.grey
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.home),
              title: Text(LocaleKeys.home.tr()),
                activeColor: AppTheme.secondary,
                inactiveColor: Colors.grey
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.shopping_cart),
              title: Text(LocaleKeys.cart.tr()),
                activeColor: AppTheme.secondary,
                inactiveColor: Colors.grey
            ),
            FlashyTabBarItem(
              icon: Icon(Icons.favorite),
              title: Text(LocaleKeys.favourite.tr()),
                activeColor: AppTheme.secondary,
                inactiveColor: Colors.grey
            ),
          ],

        ),

      ),
    );
  }
}