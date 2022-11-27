import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/notification_bloc/notification_cubit.dart';
import 'package:loz/bloc/transaction_bloc/transaction_cubit.dart';
import 'package:loz/data/repositories/notification_repo.dart';
import 'package:loz/data/repositories/transaction_repo.dart';
import 'package:loz/presentation/screens/contact.dart';
import 'package:loz/presentation/screens/points.dart';
import 'package:loz/presentation/screens/send_palance.dart';
import 'package:loz/presentation/screens/transaction_screen.dart';
import 'package:loz/presentation/widgets/menu_item.dart';
import 'package:loz/theme.dart';
import 'package:share/share.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../bloc/about_bloc/about_cubit.dart';
import '../../bloc/auth_bloc/auth_cubit.dart';
import '../../bloc/contact_bloc/contact_cubit.dart';
import '../../bloc/home/departments_bloc/departments_cubit.dart';
import '../../bloc/home/home_ad_bloc/home_ad_cubit.dart';
import '../../bloc/points_bloc/points_cubit.dart';
import '../../bloc/send_balance_bloc/balance_cubit.dart';
import '../../data/ServerConstants.dart';
import '../../data/repositories/about_repo.dart';
import '../../data/repositories/auth_repo.dart';
import '../../data/repositories/contact_repo.dart';
import '../../data/repositories/home_repo.dart';
import '../../data/repositories/points_repo.dart';
import '../../local_storage.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/default_button.dart';
import '../widgets/helper.dart';
import '../widgets/loading.dart';
import 'Auth_screens/login.dart';
import 'about.dart';
import 'bottom_nav.dart';
import 'notifications.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
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
        child: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
        if (state is AuthFailure) {
          ServerConstants.showDialog1(context, state.error, false, '');
        } else if (state is AuthSuccess) {
          showTopSnackBar(
              context,
              Card(
                child: CustomSnackBar.success(
                  message: LocaleKeys.logout_success.tr(),
                  backgroundColor: Colors.white,
                  textStyle: TextStyle(
                      color: Colors.black, fontSize: size.height * 0.02),
                ),
              ));
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider<HomeAdCubit>(
                    create: (BuildContext context) =>
                        HomeAdCubit(GetHomeRepository()),
                  ),
                  BlocProvider<DepartmentsCubit>(
                    create: (BuildContext context) =>
                        DepartmentsCubit(GetHomeRepository(),false,context,context.locale.toString()),
                  ),
                ],
                child: BottomNavBar(),
              ),
            ),
          );
        } else if (state is AuthLoading) {
          LoadingScreen.show(context);
        }
    },
    builder: (context, state) =>
        SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: size.height * .12 ,),
              Container(
                padding: EdgeInsets.symmetric(vertical: 18),

                width: size.width *.9,
                decoration: BoxDecoration(
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: Colors.black
                              .withOpacity(0.2),
                          offset: const Offset(1.1, 2.0),
                          blurRadius: 8.0),
                    ],
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white
                ),
                child: Column(
                  children: [
                    Text(
                          (LocalStorage.getData(key: "userName") != null
                              ? LocalStorage.getData(key: "userName")
                              : "${LocaleKeys.Guest.tr()}"),
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold, height: size.height * 0.002,color: AppTheme.nearlyBlack),
                    ),
                    Text(
                      (LocalStorage.getData(key: "phone") != null
                          ?"${LocalStorage.getData(key: "phone")}"
                          : ""),
                      style: TextStyle(

                          fontSize: size.height * 0.02,
                          height: size.height * 0.002
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(height: size.height * .03,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          Column(
                            children: [
                              Image.asset("assets/images/purse.png",height: size.height * .04,),
                              SizedBox(width: size.width * .02,),
                              Text(state is StatsLoading ?"-":context.read<AuthCubit>().balance!+" "+LocaleKeys.kwd.tr(),
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    height: size.height * 0.003,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(LocaleKeys.balance.tr(),
                                style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    height: size.height * 0.001,
                                    fontWeight: FontWeight.bold,
                                  color: Colors.grey
                                ),
                              )

                            ],
                          ),
                          Column(
                            children: [
                              Image.asset("assets/images/shopping.png",height: size.height * .04,),
                              SizedBox(width: size.width * .02,),
                              Text(state is StatsLoading ?"-":context.read<AuthCubit>().ordersCount!,
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    height: size.height * 0.003,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(LocaleKeys.orders.tr(),
                                style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    height: size.height * 0.001,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                ),)

                            ],
                          ),

                          Column(
                            children: [
                              Image.asset("assets/images/debt.png",height: size.height * .04,),
                              SizedBox(width: size.width * .02,),
                              Text(state is StatsLoading ?"-":context.read<AuthCubit>().payLater!+" "+LocaleKeys.kwd.tr(),
                                style: TextStyle(
                                    fontSize: size.height * 0.02,
                                    height: size.height * 0.003,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(LocaleKeys.dept.tr(),
                                style: TextStyle(
                                    fontSize: size.height * 0.015,
                                    height: size.height * 0.001,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey
                                ),)


                            ],
                          ),
                        ],
                      ),
                    ),


                  ],
                ),
              ),
              SizedBox(height: size.height * .04,),
          GridView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, childAspectRatio: 1.2,crossAxisSpacing: 0),
            padding: const EdgeInsets.only(
                top: 0, bottom: 0, right: 5, left: 5),
            children: [
              if (LocalStorage.getData(key: 'token') != null)
                MenuWidget(
                  text: LocaleKeys.my_points.tr(),
                  image: "assets/images/purse.png",
                  press: () {
                    print(context.read<AuthCubit>().status == true);
                    context.read<AuthCubit>().status == true
                        ? push(
                      context,
                      BlocProvider<PointsCubit>(
                          create: (BuildContext context) =>
                              PointsCubit(PointsRepo()),
                          child: PointsScreen()),
                    )
                        : showTopSnackBar(
                        context,
                        Card(
                          child: CustomSnackBar.success(
                            message:
                            " ${LocaleKeys.offline_translate.tr()}",
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.025),
                          ),
                        ));
                  },
                ),
              if (LocalStorage.getData(key: 'token') != null)
              MenuWidget(
                text: LocaleKeys.notifications.tr(),
                image: "assets/images/bell.png",
                press: () {
                  print(context.read<AuthCubit>().status == true);
                  context.read<AuthCubit>().status == true
                      ? push(
                    context,
                    BlocProvider<NotificationCubit>(
                        create: (BuildContext context) =>
                            NotificationCubit(NotificationRepo()),
                        child: NotifyScreen()),
                  )
                      : showTopSnackBar(
                      context,
                      Card(
                        child: CustomSnackBar.success(
                          message:
                          " ${LocaleKeys.offline_translate.tr()}",
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: size.height * 0.025),
                        ),
                      ));
                },
              ),

              MenuWidget(
                text: LocaleKeys.contact_us.tr(),
                image: "assets/images/email.png",
                press: () {
                  context.read<AuthCubit>().status == true
                      ? push(
                    context,
                    BlocProvider<ContactCubit>(
                        create: (BuildContext context) =>
                            ContactCubit(ContactRepo()),
                        child: ContactUsScreen()),
                  )
                      : showTopSnackBar(
                      context,
                      Card(
                        child: CustomSnackBar.success(
                          message:
                          " ${LocaleKeys.offline_translate.tr()}",
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: size.height * 0.025),
                        ),
                      ));
                },
              ),
              if (LocalStorage.getData(key: 'token') != null)
                MenuWidget(
                  text: LocaleKeys.send_balance.tr(),
                  image: "assets/images/money.png",
                  press: () {
                    context.read<AuthCubit>().status == true
                        ? Navigator.push(context, MaterialPageRoute(builder: (_)=>  BlocProvider<TransactionCubit>(
                        create: (BuildContext context) =>
                            TransactionCubit(TransactionRepo()),
                        child: TransactionScreen()))).then((value) {
                      context.read<AuthCubit>().statics();
                    })
                        : showTopSnackBar(
                        context,
                        Card(
                          child: CustomSnackBar.success(
                            message:
                            " ${LocaleKeys.offline_translate.tr()}",
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.025),
                          ),
                        ));
                  },
                ),
              MenuWidget(
                text: LocaleKeys.share.tr(),
                image: "assets/images/share.png",
                press: () {
                  Share.share("شارك تطبيق توت مع العائلة و الاصدقاء\n\n"
                  "تحميل التطبيق لنظام Android\n"
                  "https://play.google.com/store/apps/details?id=com.icontds.toot\n\n"
                  "تحميل التطبيق لنظام ios\n"
                  "https://apps.apple.com/us/app/toot-%D8%AA%D9%88%D8%AA/id1603425900");
                },
              ),
              MenuWidget(
                text: LocaleKeys.language_translate.tr(),
                image: "assets/images/language.png",
                press: () async {
                  //   await  context.read<AuthCubit>().swichLag(context);
                  if (context.read<AuthCubit>().status == true) {
                    if (context.locale.toString() == 'ar') {
                      LocalStorage.saveData(key: "lang", value: 'en');
                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // prefs.setString("lang", "en");
                      await context.setLocale(
                        Locale("en"),
                      );
                    } else {
                      LocalStorage.saveData(key: "lang", value: 'ar');

                      // SharedPreferences prefs =
                      //     await SharedPreferences.getInstance();
                      // prefs.setString("lang", "ar");
                      await context.setLocale(
                        Locale("ar"),
                      );
                    }
                    context.read<AuthCubit>().changeLang();
                  } else {
                    showTopSnackBar(
                        context,
                        Card(
                          child: CustomSnackBar.success(
                            message:
                            " ${LocaleKeys.offline_translate.tr()}",
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.025),
                          ),
                        ));
                  }
                },
              ),
              //

              MenuWidget(
                text: LocaleKeys.about.tr(),
                image: "assets/images/information.png",
                press: () {
                  context.read<AuthCubit>().status == true
                      ? push(
                    context,
                    BlocProvider<AboutCubit>(
                        create: (BuildContext context) =>
                            AboutCubit(AboutRepo()),
                        child: AboutScreen()),
                  )
                      : showTopSnackBar(
                      context,
                      Card(
                        child: CustomSnackBar.success(
                          message:
                          " ${LocaleKeys.offline_translate.tr()}",
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: size.height * 0.025),
                        ),
                      ));
                },
              ),
              MenuWidget(
                text: LocalStorage.getData(key: 'token') != null
                    ? LocaleKeys.logout.tr()
                    : LocaleKeys.login.tr(),
                image: LocalStorage.getData(key: 'token') != null?
                "assets/images/logout.png":
    "assets/images/login2.png",
                press: () async {
                  if (context.read<AuthCubit>().status == true) {
                    if (LocalStorage.getData(key: 'token') != null)
                      context.read<AuthCubit>().logout();
                    else
                      push(
                          context,
                          BlocProvider(
                              create: (BuildContext context) =>
                                  AuthCubit(AuthRepo()),
                              child: Login()));
                  } else {
                    showTopSnackBar(
                        context,
                        Card(
                          child: CustomSnackBar.success(
                            message:
                                " ${LocaleKeys.offline_translate.tr()}",
                            backgroundColor: Colors.white,
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.025),
                          ),
                        ));
                  }
                },
              ),
              if (LocalStorage.getData(key: 'token') != null)
                MenuWidget(
                  text: LocaleKeys.delete_account.tr(),
                  image: "assets/images/delete-document.png",
                  press: () async {
                    if (context.read<AuthCubit>().status == true) {
                      showDialog<void>(
                        context: context,
                        builder: (modal) {
                          var we = MediaQuery.of(context).size.width;
                          var he = MediaQuery.of(context).size.height;
                          return AlertDialog(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(32.0))),
                              content:
                              // StatefulBuilder(
                              //   builder: (BuildContext context, StateSetter setState) {
                              //     return
                              BlocProvider.value(
                                  value: BlocProvider.of<AuthCubit>(
                                      context),
                                  child:
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      SizedBox(height: he*.01,),
                                      Text( LocaleKeys.delete_account.tr(),
                                        style: TextStyle(
                                          color: AppTheme.orange,
                                          fontSize: we * .04,
                                          height: he *.003,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),),
                                      Text( LocaleKeys.delete_account_msg.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: we * .035,
                                          height: he *.002,
                                          fontWeight:
                                          FontWeight.bold,
                                        ),),
                                      SizedBox(height: he*.02,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [

                                          SizedBox(
                                            width: we * .28,
                                            child: DefaultButton(
                                              height: he*.06 ,
                                              width: we+ .3,
                                              textColor: Colors.white,
                                              color: Colors.red,
                                              title: LocaleKeys.ok_translate.tr(),
                                              radius: 15,
                                              function: ()async {
                                                //  context.read<AuthCubit>().deleteAcount();
                                                await BlocProvider.of<AuthCubit>(context).deleteAcount(
                                                  // phone: phone,
                                                  // password: password,
                                                );
                                              },
                                              font: he * 0.02,
                                            ),
                                          ),
                                          SizedBox(
                                            width: we * .3,
                                            child: DefaultButton(
                                              height: he*.06 ,
                                              width: we * .28,
                                              textColor: Colors.white,
                                              color: Colors.green,
                                              title: LocaleKeys.cancel.tr(),
                                              radius: 15,
                                              function: () {
                                                Navigator.pop(context);
                                              },
                                              font: he* 0.02,
                                            ),
                                          ),
                                        ],
                                      )

                                    ],
                                  )
                              )
                            //   }
                            //
                            // ),
                          );
                        },
                      );
                      //
                    } else {
                      showTopSnackBar(
                          context,
                          Card(
                            child: CustomSnackBar.success(
                              message:
                              " ${LocaleKeys.offline_translate.tr()}",
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.height * 0.025),
                            ),
                          ));
                    }
                  },
                ),
            ],
          ),
            ],
          ),
        ) ),
      ),
    );
  }
}
