import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/bloc/rate_bloc/rate_cubit.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../theme.dart';
import 'bottom_nav.dart';

class RatingScreen extends StatelessWidget {
  const RatingScreen({Key? key,this.orderId}) : super(key: key);
  final int? orderId;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppTheme.background,
      body: WillPopScope(
        onWillPop: (){
          pushReplacement(context,   MultiBlocProvider(
            providers: [
              BlocProvider<HomeAdCubit>(
                create: (BuildContext context) => HomeAdCubit(GetHomeRepository()),
              ),
              BlocProvider<DepartmentsCubit>(
                create: (BuildContext context) => DepartmentsCubit(GetHomeRepository(),false,context,context.locale.toString()),
              ),
            ],

            child: BottomNavBar(),
          ),);
          return Future.value(false);
        },
        child: SafeArea(
          child: SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 9),
                        child: IconButton(
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            size: 28,
                            color: AppTheme.secondary,
                          ),
                          onPressed: () {
                            pushReplacement(context,   MultiBlocProvider(
                              providers: [
                                BlocProvider<HomeAdCubit>(
                                  create: (BuildContext context) => HomeAdCubit(GetHomeRepository()),
                                ),
                                BlocProvider<DepartmentsCubit>(
                                  create: (BuildContext context) => DepartmentsCubit(GetHomeRepository(),false,context,context.locale.toString()),
                                ),
                              ],

                              child: BottomNavBar(),
                            ),);
                          },
                        ),
                      ),
                      Text(
                        LocaleKeys.evaluation.tr(),
                        style: TextStyle(
                          fontSize: size.width * .06,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(width: 60,),
                    ],
                  ),
                ),
                BlocConsumer<RateCubit, RateState>(
                  listener:(context, state){
                    if (state is RateFailure) {
                      Navigator.pop(context);
                      showTopSnackBar(
                          context,
                          Card(
                            child: CustomSnackBar.success(
                              message: state.error,
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                  color: Colors.black, fontSize: size.height * 0.04),
                            ),
                          ));
                    }else if(state is RateSuccess){

                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (_) =>
                                MultiBlocProvider(
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
                          ));
                      showTopSnackBar(
                          context,
                          Card(
                            child: CustomSnackBar.success(
                              message:   LocaleKeys.glad_msg.tr(),
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                  color: Colors.black, fontSize: size.height * 0.025),
                            ),
                          ));
                    } else if (state is RateLoading) {
                      LoadingScreen.show(context);
                    }
                  },
                    builder: (context, state) {
                      RateCubit rateState = context.read<RateCubit>();
                        return  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: size.height * .03,
                              ),
                              Text(
                                LocaleKeys.rate_title.tr(),
                                style: TextStyle(
                                  fontSize: size.width * .05,
                                  color: AppTheme.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(
                                height: size.height * .03,
                              ),
                              Text(
                                LocaleKeys.branchRate.tr(),
                                style: TextStyle(
                                  fontSize: size.width * .05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Center(
                                child: RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    rateState.setBranchRating(rating.toString());

                                    // setState(() {
                                      // print("XXXXXXX$rating");
                                    //  branchRating = rating.toInt();
                                   // });
                                  },
                                ),
                              ),
                              SizedBox(
                                height: size.height * .03,
                              ),
                              Text(
                                LocaleKeys.foodRate.tr(),
                                style: TextStyle(
                                  fontSize: size.width * .05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Center(
                                child: RatingBar.builder(
                                  initialRating: 0,
                                  minRating: 0,
                                  direction: Axis.horizontal,
                                  allowHalfRating: false,
                                  itemCount: 5,
                                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                  itemBuilder: (context, _) => Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  onRatingUpdate: (rating) {
                                    rateState.setFoodRating(rating.toString());
                                    // setState(() {
                                    // print("XXXXXXX$rating");
                                    //  branchRating = rating.toInt();
                                    // });
                                  },
                                ),
                              ),

                              SizedBox(
                                height: size.height * .03,
                              ),
                              Text(
                                LocaleKeys.rate_comment.tr(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height: size.height *.002,
                                  fontSize: size.width * .05,
                                  fontWeight: FontWeight.bold,
                                ),

                              ),
                              Center(
                                child: SizedBox(
                                  width: size.width * .8,
                                  height: size.height * .2,
                                  child: TextFormField(
                                   controller: rateState.comment,
                                    cursorColor: AppTheme.orange,
                                    maxLines: 4,
                                    decoration: InputDecoration(
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: AppTheme.orange,
                                          width: 2.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(25.0),
                                        borderSide: BorderSide(
                                          color: AppTheme.orange,
                                          width: 2.0,
                                        ),
                                      ),
                                      // label: Text(
                                      //   LocaleKeys.address.tr(),
                                      //   style: TextStyle(color: AppTheme.orange, fontSize: size.height * 0.017),
                                      // ),
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
                                child: DefaultButton(
                                  width: size.width * .5,
                                  textColor: Colors.white,
                                  color: AppTheme.orange,
                                  title: LocaleKeys.send.tr(),
                                  radius: 15,
                                  function: () {

                                    rateState.rateOrder(orderId!);
                                  },
                                  font: size.height * 0.03,
                                ),
                              ),
                            ],
                          ),
                        );

                    }
                )],
            ),
          ),
        ),
      ),
    );
  }
}
