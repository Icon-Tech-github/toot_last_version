import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/notification_bloc/notification_cubit.dart';
import 'package:loz/data/models/notification.dart';
import 'package:loz/presentation/screens/notification_details.dart';
import 'package:loz/presentation/widgets/helper.dart';

import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../local_storage.dart';

class NotifyScreen extends StatefulWidget {
  const NotifyScreen({Key? key}) : super(key: key);

  @override
  _NotifyScreenState createState() => _NotifyScreenState();
}

class _NotifyScreenState extends State<NotifyScreen> {
  String? token = '';

  void getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString('access_token');
    setState(() {});
  }

  bool? status = true;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppTheme.background,
        body:
            // favProvider.isLoud == true?

            // SmartRefresher(
            //   controller: notifyProvider.controller,
            //   onLoading: () {
            //     print(
            //         "-------------------------object--------------------------------");
            //     notifyProvider.onRefresh();
            //
            //   },
            //   enablePullUp: true,
            //   enablePullDown: false,
            SafeArea(
          child: BlocBuilder<NotificationCubit, NotificationState>(
              builder: (context, state) {
            if (state is NotificationLoading && state.isFirstFetch) {
              return Center(
                child: SafeArea(
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * .02,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 9),
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 5, horizontal: 9),
                              child: Text(
                                LocaleKeys.notifications.tr(),
                                style: TextStyle(
                                  fontSize: size.width * .07,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // SizedBox(width: 60,),
                          ],
                        ),
                      ),
                      Container(
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
                    ],
                  ),
                ),
              );
            }
            List<NotificationData> notifications = [];
            bool isLoading = false;

            if (state is NotificationLoading) {
              notifications = state.OldNotifications;
              isLoading = true;
            } else if (state is NotificationLoaded) {
              notifications = state.notifications;
            }

            NotificationCubit notificationState =
                context.read<NotificationCubit>();

            return SmartRefresher(
              header: WaterDropHeader(),
              controller: notificationState.controller,
              onLoading: () {
                notificationState.onLoad();
              },
              enablePullUp: true,
              enablePullDown: false,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * .02,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 9),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 9),
                            child: Text(
                              LocaleKeys.notifications.tr(),
                              style: TextStyle(
                                fontSize: size.width * .07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // SizedBox(width: 60,),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        List<int> ids =[];
                        List<int> index =[];
                        LocalStorage.saveData(key: "unReadCount",value: "0");
                        for(int i=0;i< notificationState.allNotifications.length ;i++){
                          if(notificationState.allNotifications[i].readAt == null){
                            ids.add(notificationState.allNotifications[i].id!);
                            index.add(i);
                          }
                        }
                        notificationState.reed(ids, index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 28.0),
                        child: Text(
                          LocaleKeys.mark_read.tr(),
                          style: TextStyle(
                            color: AppTheme.secondary,
                            decoration: TextDecoration.underline,
                            fontSize: size.width * .04,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        itemCount: notificationState.allNotifications.length,
                        itemBuilder: (ctx, index) => GestureDetector(
                              onTap: () {
                                if(notificationState.allNotifications[index].readAt == null){
                                  notificationState.reed([
                                    notificationState.allNotifications[index].id!
                                  ], [index]);
                                  LocalStorage.saveData(key: "unReadCount",value: (int.parse(LocalStorage.getData(key: "unReadCount").toString()) -1).toString());
                                }

                                push(
                                    context,
                                    NotificationDetails(
                                        notification: notificationState
                                            .allNotifications[index]));
                              },
                              child: Container(
                                height: size.height *.291,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 5),
                                child: Card(
                                  color: notificationState
                                              .allNotifications[index].readAt ==
                                          null
                                      ? AppTheme.secondary.withOpacity(.4)
                                      : Colors.white,
                                  elevation: .2,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: SizedBox(
                                    width: double.infinity,
                                    // height: 120,
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(20

                                              ),
                                              child: notificationState
                                                          .allNotifications[
                                                              index]
                                                          .image !=
                                                      null
                                                  ? Image.network(
                                                      notificationState
                                                          .allNotifications[
                                                              index]
                                                          .image
                                                          .toString(),
                                                      fit: BoxFit.fill,
                                                      height:  size.height *.28,
                                                      width:
                                                          double.infinity,
                                                    )
                                                  : Image.asset(
                                                      "assets/images/toot.png",
                                                      fit: BoxFit.fill,
                                                      height:  size.height *.28,
                                                      width:
                                                          double.infinity,
                                                    )),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: size.height *.28,
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                const Color(0xFF000000)
                                                    .withOpacity(0.0),
                                                const Color(0xFF000000)
                                                    .withOpacity(.7),
                                              ],
                                            ),
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight:
                                                  Radius.circular(11.0),
                                              topLeft:
                                                  Radius.circular(11.0),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: 0,
                                          child: Container(

                                            width: size.width,
                                            color:notificationState
                                                .allNotifications[index].readAt ==
                                                null
                                                ? AppTheme.secondary.withOpacity(.4)
                                                : Colors.white.withOpacity(.5),
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 16.0),
                                              child: SizedBox(
                                                width: size.width * .6,
                                                child: Text(
                                                  notificationState
                                                      .allNotifications[index].title!.en
                                                      .toString(),
                                                  style: const TextStyle(
                                                      overflow:
                                                      TextOverflow.ellipsis,
                                                      color: Colors.white,
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 20),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )),
                  ],
                ),
              ),
            );
          }),
          //  ),

          //helpLoading()
        ));
  }
}
