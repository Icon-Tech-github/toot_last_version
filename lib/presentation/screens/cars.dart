import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/address_bloc/address_cubit.dart';
import 'package:loz/bloc/cart_bloc/cart_cubit.dart';
import 'package:loz/bloc/order_method_bloc/order_method_cubit.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:lottie/lottie.dart'as lottie;

import '../../bloc/cars_bloc/cars_cubit.dart';
import '../../local_storage.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/helper.dart';
import 'confirm_order.dart';

class CarsScreen extends StatefulWidget {
  const CarsScreen({Key? key}) : super(key: key);

  @override
  _CarsScreenState createState() => _CarsScreenState();
}

class _CarsScreenState extends State<CarsScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: AppTheme.background,
          body: SafeArea(
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
                                    color: AppTheme.secondary,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                              Text(
                                LocaleKeys.order_method.tr(),
                                style: TextStyle(
                                  fontSize: size.width * .07,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // SizedBox(width: 60,),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: size.height * .01,
                        ),
                        BlocBuilder<CarsCubit, CarsState>(
                            builder: (context, state) {
                              if (state is CarsLoading) {
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
                              if (state is CarsLoaded) {
                                return
                                  state.cars.length ==0?
                                  Column(

                                    children: [
                                      SizedBox(height: size.height * .15,),
                                      Center(
                                        child:  lottie.Lottie.asset('assets/images/car.json',height: size.height * .2 ),
                                      ),
                                    ],
                                  ):
                                  //   Center(child: Image.asset("assets/images/car.gif",height: size.height * .2,)):
                                  ListView.builder(
                                    itemCount: state.cars.length,
                                    shrinkWrap: true,
                                    physics: NeverScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return InkWell(
                                        onTap:(){
                                          context.read<CarsCubit>().chooseCar(
                                              context.read<CarsCubit>()
                                                  .allCars,
                                              index);
                                          setState(() {});
                                          //  Navigator.pop(context);
                                        },
                                        child: Container(
                                          height: size.height * .1,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
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
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 20, vertical: 10),
                                                //  width: size.width *.6,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: AppTheme.secondary,
                                                    border: Border.all(
                                                        color: AppTheme.lightGreen,
                                                        width: 7)
                                                  //borderRadius: BorderRadius.circular(20),
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.directions_car_outlined,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    state.cars[index].carModel.toString(),
                                                    maxLines: 1,
                                                    softWrap: false,
                                                    style: TextStyle(
                                                        fontSize: size.height * 0.022,
                                                        height: size.height * 0.002,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * .4,
                                                    child: Text(
                                                      "${state.cars[index].plateNumber} | ${state.cars[index].carColor}",
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
                                                ],
                                              ),
                                              SizedBox(
                                                width: size.width * .05,
                                              ),
                                              Container(
                                                //   width: 23,
                                                height: 25,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape
                                                        .circle,
                                                    color: state.cars[index].chosen ??
                                                        false
                                                        ? AppTheme
                                                        .secondary
                                                        : Colors
                                                        .white,
                                                    border: Border.all(
                                                        color: state.cars[index].chosen ??
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
                    showModalBottomSheet(
                        isScrollControlled:
                        true,
                        backgroundColor:
                        Colors
                            .transparent,
                        context: context,
                        builder: (modal) {
                          return BlocProvider
                              .value(
                            value: BlocProvider.of<
                                CarsCubit>(
                                context),
                            child:
                            Container(
                              padding: EdgeInsets.only(
                                  bottom: MediaQuery.of(context)
                                      .viewInsets
                                      .bottom),
                              height:
                              size.height *
                                  0.86,
                              decoration: const BoxDecoration(
                                  color: Colors
                                      .white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20))),
                              child:
                              Padding(
                                padding:
                                const EdgeInsets.symmetric(horizontal: 18.0),
                                child:
                                SizedBox(
                                  height:
                                  size.height * 0.85,
                                  child:
                                  Form(
                                    key:
                                    context.read<CarsCubit>().formKey,
                                    child:
                                    SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 30,
                                          ),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                LocaleKeys.add_car.tr(),
                                                style: TextStyle(fontSize: size.height * 0.02),
                                              ),
                                              Align(
                                                alignment: Alignment.bottomRight,
                                                child: InkWell(
                                                  onTap: () {
                                                    FocusScope.of(context).requestFocus(FocusNode());

                                                    context.read<CarsCubit>().addCar(context);
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
                                          SizedBox(
                                            height: size.width * .06,
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: size.width * .8,
                                              child: TextFormField(
                                                controller:   context.read<CarsCubit>().carColor,
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
                                                    LocaleKeys.car_color.tr(),
                                                    style: TextStyle(color: AppTheme.grey, fontSize: size.height * 0.019, height: size.height * 0.001),
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
                                            height: size.width * .05,
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: size.width * .8,
                                              child: TextFormField(
                                                controller:   context.read<CarsCubit>().carNumber,
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
                                                    LocaleKeys.car_number.tr(),
                                                    style: TextStyle(color: AppTheme.grey, fontSize: size.height * 0.019, height: size.height * 0.001),
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
                                                onChanged: (text) {
                                                  // detailsState
                                                  //     .setNote(
                                                  //     text);
                                                },
                                                onEditingComplete: () {
                                                  FocusScope.of(context).requestFocus(FocusNode());

                                                  //   Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.width * .05,
                                          ),
                                          Center(
                                            child: SizedBox(
                                              width: size.width * .8,
                                              child: TextFormField(
                                                controller:   context.read<CarsCubit>().carModel,
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
                                                    LocaleKeys.car_model.tr(),
                                                    style: TextStyle(color: AppTheme.grey, fontSize: size.height * 0.019, height: size.height * 0.001),
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
                                                onChanged: (text) {
                                                  // detailsState
                                                  //     .setNote(
                                                  //     text);
                                                },
                                                onEditingComplete: () {
                                                  FocusScope.of(context).requestFocus(FocusNode());

                                                  // Navigator.pop(
                                                  //     context);
                                                },
                                              ),
                                            ),
                                          ),
                                          //   Spacer(),
                                          //     SizedBox(
                                          //       height:
                                          //       size.height *
                                          //           .3,
                                          //     ),
                                        ],
                                      ),
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
                  },
                  title: LocaleKeys.add_car.tr(),
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
                    if(LocalStorage.getData(key: "carId") == null){
                      showTopSnackBar(
                          context,
                          Card(
                            child: CustomSnackBar.success(
                              message: LocaleKeys.please_add_car.tr(),
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.height * 0.02),
                            ),
                          ));
                    }else{
                      push(
                          context,
                          ConfirmOrderScreen(
                            delivery_fee: 0,
                            //    discount: descount,
                          ));
                    }
                  },
                  title: LocaleKeys.apply.tr(),
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
