import 'package:countup/countup.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/about_bloc/about_cubit.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:loz/bloc/branches_bloc/branches_cubit.dart';
import 'package:loz/bloc/contact_bloc/contact_cubit.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/bloc/notification_bloc/notification_cubit.dart';
import 'package:loz/bloc/points_bloc/points_cubit.dart';
import 'package:loz/bloc/send_balance_bloc/balance_cubit.dart';
import 'package:loz/data/ServerConstants.dart';
import 'package:loz/data/repositories/about_repo.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/data/repositories/contact_repo.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/data/repositories/notification_repo.dart';
import 'package:loz/data/repositories/points_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/screens/about.dart';
import 'package:loz/presentation/screens/points.dart';
import 'package:loz/presentation/screens/send_palance.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/presentation/widgets/more_item.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Auth_screens/login.dart';
import 'bottom_nav.dart';
import 'contact.dart';
import 'map.dart';
import 'notifications.dart';

class MenuScreen extends StatelessWidget {
  MenuScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: AppTheme.background,
        body: BlocConsumer<AuthCubit, AuthState>(
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
                      child: BottomNavBar(branches: BranchesCubit.branches,),
                    ),
                  ),
                );
              } else if (state is AuthLoading) {
                LoadingScreen.show(context);
              }
            },
            builder: (context, state) =>
                SafeArea(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    LocaleKeys.hello.tr() +
                                        " " +
                                        (LocalStorage.getData(key: "userName") != null
                                            ? LocalStorage.getData(key: "userName")
                                            : "${LocaleKeys.Guest.tr()}"),
                                    style: TextStyle(
                                        fontSize: 24, fontWeight: FontWeight.bold, height: size.height * 0.002),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                                  child: Text(
                                    (LocalStorage.getData(key: "phone") != null
                                        ?"+966${LocalStorage.getData(key: "phone")}"
                                        : ""),
                                    style: TextStyle(
                                        fontSize: size.height * 0.02,
                                        height: size.height * 0.001
                                      // fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ),
                              ],

                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Icon(Icons.logout,color: Colors.red,size: size.height * .04,),
                            )
                          ],
                        ),

                        if (LocalStorage.getData(key: 'token') != null)
                        SizedBox(height: size.height *.02,),
                        if (LocalStorage.getData(key: 'token') != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: size.width * 0.38,
                              width: size.width * .42,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.3),
                                      offset: const Offset(1.1, 2.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: size.height * 0.12,
                                    width: size.width * .12,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,

                                      //  borderRadius: BorderRadius.circular(15),
                                        color: AppTheme.secondary
                                    ),
                                    child: Center(child: Image.asset("assets/images/package.png",height: size.height * .032,color: Colors.white,)),
                                  ),
                                  state is StatsLoading ?
                                  Text("-",
              style: TextStyle(
                  fontSize: size.height * 0.03,
                  height: size.height * 0.001,
                 fontWeight: FontWeight.bold
              ),
            ):
                                  Countup(
                                    begin: 0,
                                    end: double.parse(context.read<AuthCubit>().ordersCount.toString()),
                                    curve: Curves.easeOut,
                                    duration: Duration(seconds: 1),
                                    separator: ',',
                                    style: TextStyle(
                                        fontSize: size.height * 0.03,
                                        height: size.height * 0.001,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(LocaleKeys.total_orders.tr(),
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        height: size.height * 0.002,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              height: size.width * 0.38,
                              width: size.width * .42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.3),
                                      offset: const Offset(1.1, 2.0),
                                      blurRadius: 8.0),
                                ],
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    height: size.height * 0.12,
                                    width: size.width * .12,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        //  borderRadius: BorderRadius.circular(15),
                                        color: AppTheme.secondary
                                    ),
                                    child: Center(child: Image.asset("assets/images/wallet.png",height: size.height * .032,color: Colors.white,)),
                                  ),
                                  state is StatsLoading ?
                                  Text("-",
                                    style: TextStyle(
                                        fontSize: size.height * 0.03,
                                        height: size.height * 0.001,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ):
                                  Countup(
                                    begin: 0,
                                    end: double.parse(context.read<AuthCubit>().balance!),
                                    curve: Curves.easeOut,
                                    duration: Duration(seconds: 1),
                                    separator: ',',
                                    style: TextStyle(
                                        fontSize: size.height * 0.03,
                                        height: size.height * 0.001,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Text(LocaleKeys.balance.tr(),
                                    style: TextStyle(
                                        fontSize: size.height * 0.018,
                                        height: size.height * 0.002,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            ),


                          ],
                        ),
                        SizedBox(height: size.height *.02,),
                        if (LocalStorage.getData(key: 'token') != null)
                          Menu(
                            text: LocaleKeys.my_points.tr(),
                            icon: Icons.account_balance_wallet_outlined,
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
                          Menu(
                            text: LocaleKeys.send_balance.tr(),
                            icon: Icons.card_giftcard,
                            press: () {
                              context.read<AuthCubit>().status == true
                                  ? push(
                                context,
                                BlocProvider<BalanceCubit>(
                                    create: (BuildContext context) =>
                                        BalanceCubit(PointsRepo()),
                                    child: SendBalanceScreen()),
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
                        Menu(
                          text: LocaleKeys.contact_us.tr(),
                          icon: Icons.email_outlined,
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
                        Menu(
                          text: LocaleKeys.Excellent_Request.tr(),
                          icon: Icons.request_page_outlined,
                          press: () async{
                            await launch('https://forms.gle/XSB8ecJX7sjiBFTS9');

                          },
                        ),
                        if (LocalStorage.getData(key: 'token') != null)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 28.0),
                          child: Divider(color: Colors.black38,),
                        ),
                        Menu(
                          text: LocaleKeys.our_branches.tr(),
                          icon: Icons.location_on_outlined,
                          press: () {
                            print(context.read<AuthCubit>().status == true);
                            context.read<AuthCubit>().status == true
                                ? push(
                              context,
                                MapScreen(branches: BranchesCubit.branches,))
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
                        //  if (token != null)



                        Menu(
                          text: LocaleKeys.language_translate.tr(),
                          icon: Icons.language,
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

                        Menu(
                          text: LocaleKeys.about.tr(),
                          icon: Icons.contact_support_outlined,
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

                        // Menu(
                        //   text: LocalStorage.getData(key: 'token') != null
                        //       ? LocaleKeys.logout.tr()
                        //       : LocaleKeys.login.tr(),
                        //   icon: Icons.logout,
                        //   press: () async {
                        //     if (context.read<AuthCubit>().status == true) {
                        //       if (LocalStorage.getData(key: 'token') != null)
                        //         context.read<AuthCubit>().logout();
                        //       else
                        //         push(
                        //             context,
                        //             BlocProvider(
                        //                 create: (BuildContext context) =>
                        //                     AuthCubit(AuthRepo()),
                        //                 child: Login()));
                        //     } else {
                        //       showTopSnackBar(
                        //           context,
                        //           Card(
                        //             child: CustomSnackBar.success(
                        //               message:
                        //                   " ${LocaleKeys.offline_translate.tr()}",
                        //               backgroundColor: Colors.white,
                        //               textStyle: TextStyle(
                        //                   color: Colors.black,
                        //                   fontSize: size.height * 0.025),
                        //             ),
                        //           ));
                        //     }
                        //   },
                        // ),
                        if (LocalStorage.getData(key: 'token') != null)
                        Menu(
                          text: LocaleKeys.delete_account.tr(),
                          icon: Icons.delete_sweep_outlined,
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
                                                  width: we * .3,
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
                                                    width: we * .3,
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

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 5),
                          child: DefaultButton(
                            width: size.width *.3,
                            height: size.height * .06,
                            textColor: AppTheme.nearlyBlack,
                            color: AppTheme.white,
                            borderColor: AppTheme.nearlyBlack,
                            title: LocalStorage.getData(key: 'token') != null
                                ? LocaleKeys.logout.tr()
                                : LocaleKeys.login.tr(),
                            radius: 10,
                            function: () {
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
                            font: size.height * 0.022,
                          ),
                        ),
                        SizedBox(
                          height: LocalStorage.getData(key: 'token') != null
                              ? 10
                              : size.height * .1,
                        ),
                        Center(
                          child: Text(
                            "version 1.0",
                            style: TextStyle(
                                fontSize: 12,
                                height: size.height * .002,
                                color: Colors.black),
                          ),
                        ),
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Powered by ',
                                style: TextStyle(
                                    height: size.height * .002,
                                    fontSize: 12,
                                    color: Colors.black),
                              ),
                              InkWell(
                                onTap: () {
                                  String url = "https://icontds.com/";
                               //   launch(url);
                                },
                                child: Text(
                                  'Icon Tech ',
                                  style: TextStyle(
                                      height: size.height * .002,
                                      decoration: TextDecoration.underline,
                                      fontSize: 12,
                                      color: AppTheme.orange),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: LocalStorage.getData(key: 'token') != null
                              ? 90
                              : 0,
                        ),
                      ],
                    ),
                  ),
                )));
  }
  Future _showDialog(context) async {

  }
// void _showToastMessage(){
//   Fluttertoast.showToast(
//       msg: LocaleKeys.offline_translate.tr(),
//       toastLength: Toast.LENGTH_LONG,
//       // gravity: ToastGravity.BOTTOM,
//       timeInSecForIosWeb: 1
//   );
// }
}
