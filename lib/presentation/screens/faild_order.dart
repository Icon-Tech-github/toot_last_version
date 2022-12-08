import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/confirm_order_bloc/confirm_order_cubit.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/bloc/status_bloc/status_cubit.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:lottie/lottie.dart'as lottie;

import 'package:loz/data/repositories/tracking_repo.dart';
import 'package:loz/presentation/screens/track_order.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/translations/locale_keys.g.dart';

import '../../data/repositories/confirm_order_repo.dart';
import '../../theme.dart';
import 'bottom_nav.dart';
import 'confirm_order.dart';
import 'order_tracking.dart';

class OrderFailed extends StatelessWidget {
  const OrderFailed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: (){
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: size.height,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: size.height *.1,),
              lottie.Lottie.asset(
                'assets/images/sadd.json',
                height: size.height *.4,
                // width: 400
              ),              SizedBox(height: size.height *.02,),

              Text(
                LocaleKeys.your_order_failed.tr(),
                style: TextStyle(fontSize: size.width * .06, color: AppTheme.secondary,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height *.001,),

              Text(
                "${ LocaleKeys.payment_failed.tr()}",
                style: TextStyle(fontSize: size.width * .04, color: Colors.grey,),
                textAlign: TextAlign.center,
              ),
              Spacer(),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //
              //   child: Center(
              //
              //     child: DefaultButton(
              //       textColor: Colors.white,
              //       color: AppTheme.orange,
              //       title:  LocaleKeys.confirm.tr(),
              //       radius: 20,
              //       function: () {
              //         push(context,
              //             BlocProvider(
              //                 create: (BuildContext context) => ConfirmOrderCubit(ConfirmRepo()),
              //                 child: ConfirmOrderScreen()));
              //       },
              //       font: 18,
              //     ),
              //   ),
              // ),
              // SizedBox(height: size.height *.03,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Center(
                  child: DefaultButton(
                    textColor:AppTheme.white,
                    color: AppTheme.orange,
                    title:  LocaleKeys.home.tr(),
                    radius: 20,
                    function: () {  Navigator.push(
                        context,
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
                        ));},
                    font: 18,
                    borderColor: AppTheme.orange,
                  ),
                ),
              ),
              SizedBox(height: size.height *.06,),
            ],
          ),
        ),
      ),
    );
  }
}
