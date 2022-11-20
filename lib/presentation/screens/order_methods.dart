import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/address_bloc/address_cubit.dart';
import 'package:loz/bloc/cars_bloc/cars_cubit.dart';
import 'package:loz/data/repositories/order_method_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/screens/addresses_gift.dart';
import 'package:loz/presentation/screens/cars.dart';
import 'package:loz/presentation/screens/confirm_order.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../bloc/address_gift_bloc/address_gift_cubit.dart';
import '../../bloc/order_method_bloc/order_method_cubit.dart';
import '../../theme.dart';
import '../widgets/helper.dart';
import 'adresses.dart';

class OrderMethodsScreen extends StatelessWidget {
  final double? descount ;
  const OrderMethodsScreen({Key? key,this.descount}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(

      child: Scaffold(
        resizeToAvoidBottomInset: false,
      //  backgroundColor: AppTheme.background,
        body: Container(
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
          child: ListView(
            children: [
              SizedBox(
                height: size.height * .01,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
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
                      LocaleKeys.order_method.tr(),
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
              OrderMethods(),
              PaymentMethods(),
              SizedBox(
                height: size.height * .02,
              ),
              Center(
                child: DefaultButton(
                  height: size.height * .07,
                  textColor: Colors.white,
                  color: AppTheme.orange,
                  title: LocaleKeys.continuee.tr(),
                  radius: 15,
                  function: () {
                    if (LocalStorage.getData(key: "order_method_id") == null ||
                        LocalStorage.getData(key: "payment_method_id") == null) {
                      showTopSnackBar(
                          context,
                          Card(
                            child: CustomSnackBar.success(
                              message:
                                  LocalStorage.getData(key: "order_method_id") ==
                                          null
                                      ? LocaleKeys.please_add_order_method.tr()
                                      : LocaleKeys.please_add_payment_method.tr(),
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.height * 0.02),
                            ),
                          ));
                    } else if (LocalStorage.getData(key: "order_method_id") == 2){
                      push(
                          context,
                          BlocProvider(
                              create: (BuildContext context) =>
                                  CarsCubit(OrderMethodRepo()),
                              child: CarsScreen()));
                     //   && LocalStorage.getData(key: "carId") == null) {
                      //  if(LocalStorage.getData(key: "carId") == null){
                      // showTopSnackBar(
                      //     context,
                      //     Card(
                      //       child: CustomSnackBar.success(
                      //         message: LocaleKeys.please_add_car.tr(),
                      //         backgroundColor: Colors.white,
                      //         textStyle: TextStyle(
                      //             color: Colors.black,
                      //             fontSize: size.height * 0.02),
                      //       ),
                      //     ));
                      //    }

                    } else if (LocalStorage.getData(key: "order_method_id") == 3) {
                      push(
                          context,
                          BlocProvider(
                              create: (BuildContext context) =>
                                  AddressCubit(OrderMethodRepo()),
                              child: AddressScreen()));

                    }
                    else if (LocalStorage.getData(key: "order_method_id") == 4) {
                      push(
                          context,
                          BlocProvider(
                              create: (BuildContext context) =>
                                  AddressGiftCubit(OrderMethodRepo()),
                              child: AddressGiftScreen()));

                    }

                    //  }
                    else {
                      int? index ;
                      for (int i = 0;
                          i < context.read<OrderMethodCubit>().allAddresses.length;
                          i++) {
                        if (context
                                .read<OrderMethodCubit>()
                                .allAddresses[i]
                                .id ==
                            LocalStorage.getData(key: "addressId") ) {

                          index = i;
                        }
                      }

                      push(
                          context,
                          ConfirmOrderScreen(
                            discount: descount,
                            delivery_fee: LocalStorage.getData(key: "order_method_id") == 3?
                            context
                                .read<OrderMethodCubit>()
                                .allAddresses[index!]
                                .deliveryFee:0,
                          ));
                    //   print(context
                    //       .read<OrderMethodCubit>()
                    //       .allAddresses[index!]
                    //       .deliveryFee.toString() +"kkkk");
                     }
                  },
                  font: size.width * .05,
                ),
              ),
              SizedBox(
                height: size.height * .02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderMethods extends StatelessWidget {
  const OrderMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocConsumer<OrderMethodCubit, OrderMethodState>(
        listener: (BuildContext context, state) {},
        builder: (context, state) {
          OrderMethodCubit method = context.read<OrderMethodCubit>();
          return ListView(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            children: [
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * .02, vertical: size.width * .04),
                //  color: AppTheme.background,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: size.height * .04,
                        width: size.width*.01,
                        decoration: BoxDecoration(
                          //   color: dark,

                            borderRadius: BorderRadius.circular(15)
                        ),
                        child:  VerticalDivider(
                          color: AppTheme.orange,
                          thickness:  size.width*.01,

                        ),),
                      SizedBox(
                        width:  size.width * .017,
                      ),
                      Text(
                        LocaleKeys.delivery_options.tr(),
                        style: TextStyle(
                            color: Colors.white,

                            fontSize: size.height * 0.024,
                            height: size.height * 0.0025,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),

              ListView.builder(
                  itemCount:
                      context.read<OrderMethodCubit>().allOrderMethods.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return InkWell(
                        onTap: () {
                          context.read<OrderMethodCubit>().switchOrderMethod(
                              context.read<OrderMethodCubit>().allOrderMethods,
                              i);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 25, horizontal: 24),
                          margin:  const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 18),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.3),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],

                            borderRadius:  BorderRadius.circular(15),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    context
                                        .read<OrderMethodCubit>()
                                        .allOrderMethods[i]
                                        .title!
                                        .en
                                        .toString(),
                                    style: TextStyle(
                                      fontSize: size.height * 0.022,
                                      height: size.height * 0.001,
                                      fontWeight: FontWeight.bold
                                    ),
                                  ),
                                  Container(
                                    //   width: 23,
                                    height: 25,
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: context
                                                    .read<OrderMethodCubit>()
                                                    .allOrderMethods[i]
                                                    .chosen ??
                                                false
                                            ? AppTheme.orange
                                            : Colors.white,
                                        border: Border.all(
                                            color: context
                                                        .read<
                                                            OrderMethodCubit>()
                                                        .allOrderMethods[i]
                                                        .chosen ??
                                                    false
                                                ? AppTheme.orange
                                                : Colors.grey,
                                            width: 2)),
                                    child: const Center(
                                      child: Icon(
                                        Icons.check,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              // if (context
                              //         .read<OrderMethodCubit>()
                              //         .allOrderMethods[i]
                              //         .chosen ==
                              //     true)
                              //   Text(
                              //     context
                              //                     .read<OrderMethodCubit>()
                              //                     .allOrderMethods[i]
                              //                     .id ==
                              //                 3 &&
                              //             LocalStorage.getData(
                              //                     key: 'addressTitle') !=
                              //                 null
                              //         ? LocalStorage.getData(
                              //             key: 'addressTitle')
                              //         : context
                              //                         .read<OrderMethodCubit>()
                              //                         .allOrderMethods[i]
                              //                         .id ==
                              //                     2 &&
                              //                 LocalStorage.getData(
                              //                         key: 'carTitle') !=
                              //                     null
                              //             ? LocalStorage.getData(
                              //                 key: 'carTitle')
                              //             : '',
                              //     style: TextStyle(
                              //       color: Colors.grey,
                              //       fontSize: size.height * 0.02,
                              //       height: size.height * 0.001,
                              //     ),
                              //   ),
                              // SizedBox(
                              //   height: size.height * .02,
                          //    ),
                            ],
                          ),
                        ));
                  })
            ],
          );

        });
  }
}

class PaymentMethods extends StatelessWidget {
  const PaymentMethods({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<OrderMethodCubit, OrderMethodState>(
        builder: (context, state) {
      if (state is PaymentMethodLoading) {
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
      if (state is PaymentMethodLoaded) {
        return ListView(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            SizedBox(
              height: size.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * .02, vertical: size.width * .04),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Container(
                      height: size.height * .04,
                      width: size.width*.01,
                      decoration: BoxDecoration(
                        //   color: dark,

                          borderRadius: BorderRadius.circular(15)
                      ),
                      child:  VerticalDivider(
                        color: AppTheme.orange,
                        thickness:  size.width*.01,

                      ),),
                    SizedBox(
                      width:  size.width * .017,
                    ),
                    Text(
                      LocaleKeys.payment_options.tr(),
                      style: TextStyle(
                        color: Colors.white,
                          fontSize: size.height * 0.024,
                          height: size.height * 0.0025,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ListView.builder(
                itemCount: state.paymentMethods.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return InkWell(
                    onTap: () {
                      context
                          .read<OrderMethodCubit>()
                          .switchPaymentMethod(state.paymentMethods, i);
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 25, horizontal: 24),
                      margin:  const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 18),
                      decoration: BoxDecoration(
                        color:   state.paymentMethods[i].id==1 && context.read<OrderMethodCubit>().gift ?Colors.grey.shade400:Colors.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.3),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],

                        borderRadius:  BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                state.paymentMethods[i].title!.en.toString(),
                                style: TextStyle(
                                  fontSize: size.height * 0.022,
                                  height: size.height * 0.002,
                                  fontWeight: FontWeight.bold
                                ),
                              ),
                              Container(
                                //   width: 23,
                                height: 25,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color:
                                        state.paymentMethods[i].chosen ?? false
                                            ? AppTheme.orange
                                            : Colors.white,
                                    border: Border.all(
                                        color: state.paymentMethods[i].chosen ??
                                                false
                                            ? AppTheme.orange
                                            : Colors.grey,
                                        width: 2)),
                                child: const Center(
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                })
          ],
        );
      }
      return SizedBox();
    });
  }
}
