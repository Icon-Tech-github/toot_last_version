import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:lottie/lottie.dart'as lottie;

import 'package:loz/bloc/cart_bloc/cart_cubit.dart';
import 'package:loz/bloc/order_method_bloc/order_method_cubit.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/data/repositories/cart.dart';
import 'package:loz/data/repositories/order_method_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/screens/bottom_nav.dart';
import 'package:loz/presentation/screens/order_methods.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../bloc/order_method_bloc/payment_method_bloc/payment_method_cubit.dart';

import 'Auth_screens/login.dart';

class CartScreen extends StatelessWidget {
  final bool fromHome;
  CartScreen({Key? key,required this.fromHome}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        // backgroundColor: AppTheme.background,
        body: Container(
          height: size.height,
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
          child: SafeArea(
              child: BlocProvider<CartCubit>(
                  create: (BuildContext context) => CartCubit(CartRepos()),
                  child: CartList(fromHome: fromHome,))),
        ));
  }
}

class CartList extends StatefulWidget {
  final bool fromHome;
  CartList({Key? key,required this.fromHome}) : super(key: key);
  @override
  _CartListState createState() => _CartListState();
}

class _CartListState extends State<CartList> {
  bool checkedValue = false;
  bool checkedNote = false;

  bool apply = false;
  bool ActiveConnection = true;
  @override
  void initState() {
    // TODO: implement initState
    CheckUserConnection();
    super.initState();
  }

  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;

        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var lang = context.locale.toString();


      return ActiveConnection
          ?
      BlocConsumer<CartCubit, CartState>(listener: (context, state) {
      if (state is AddCouponFailure) {
        showTopSnackBar(
            Overlay.of(context),
            Card(
              child: CustomSnackBar.success(
                message: state.error,
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black, fontSize: size.height * 0.04),
              ),
            ));
      } else if (state is UseBalanceFailure) {
        showTopSnackBar(
            Overlay.of(context),
            Card(
              child: CustomSnackBar.success(
                message: state.error,
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black, fontSize: size.height * 0.025),
              ),
            ));
      } else if (state is UseBalanceSuccess) {
        showTopSnackBar(
            Overlay.of(context),
            Card(
              child: CustomSnackBar.success(
                message:
                    " ${LocaleKeys.your_balance.tr()}  ${state.balance} ${LocaleKeys.kwd.tr()}",
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black, fontSize: size.height * 0.025),
              ),
            ));
      } else if (state is AddCouponSuccess) {
        showTopSnackBar(
            Overlay.of(context),
            Card(
              child: CustomSnackBar.success(
                message:
                    " ${LocaleKeys.your_discount.tr()}  ${state.coupon.data!.value} ${state.coupon.data!.type == 2 ? "%" : "${LocaleKeys.kwd.tr()}"}",
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black, fontSize: size.height * 0.025),
              ),
            ));
      }
    }, builder: (context, state) {
      CartCubit cartState = context.read<CartCubit>();
      return SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * .01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  if(!widget.fromHome)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 9),
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
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                    child: Text(
                      LocaleKeys.my_cart.tr(),
                      style: TextStyle(
                        fontSize: size.width * .07,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.white,
                      ),
                    ),
                  ),
                  // SizedBox(width: 60,),
                ],
              ),
            ),
            SizedBox(
              height: size.height * .01,
            ),
            cartState.products.length ==0?
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: size.height *.11,),
                  lottie.Lottie.asset(
                      'assets/images/cartt.json',
                      height: size.height *.3,
                      width: 400),
                  SizedBox(height: size.height *.02,),
                  Text(
                    LocaleKeys.empty_cart.tr(),
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: size.height *.03,
                        color: Colors.white),
                  ),
                  SizedBox(height: size.height *.02,),
                  DefaultButton(
                    font: size.width * .055, radius: 15,
                    title: LocaleKeys.back_to_make_order.tr(),
                    color: AppTheme.orange,
                    textColor: Colors.white,
                    width: size.width * .5,
                    function: (){
                     Navigator.pushAndRemoveUntil(context,
                         MaterialPageRoute(builder: (_)=>BottomNavBar()),
                             (route) => false);
                    },
                  )
                ],
              ),
            ):
                Column(
                  children: [
                    SizedBox(
                      width: size.width * .9,
                      child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: cartState.products.length,
                          itemBuilder: (ctx, index) {
                            return Container(
                              margin: EdgeInsets.only(bottom: 10),
                              decoration:  BoxDecoration(
                                boxShadow: <BoxShadow>[
                                  BoxShadow(
                                      color: Colors.grey
                                          .withOpacity(0.3),
                                      offset: const Offset(1.1, 2.0),
                                      blurRadius: 8.0),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 0, left: 0, right: 0, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child:
                                          // Stack(
                                          //
                                          //   children: [
                                          //     Container(
                                          //       height: 120,
                                          //       width: size.width * .4,
                                          //       decoration: BoxDecoration(
                                          //         color: AppTheme.lightSec,
                                          //         shape: BoxShape.rectangle,
                                          //         borderRadius: BorderRadius.horizontal(
                                          //           left: Radius.circular(20.0),
                                          //           right: Radius.circular(40.0),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     Container(
                                          //       height: 120,
                                          //       width: size.width * .3,
                                          //       decoration: BoxDecoration(
                                          //         color: AppTheme.secondary,
                                          //         shape: BoxShape.rectangle,
                                          //         borderRadius: BorderRadius.horizontal(
                                          //           left: Radius.circular(20.0),
                                          //           right: Radius.circular(50.0),
                                          //         ),
                                          //       ),
                                          //     ),
                                          //     // Positioned(
                                          //     //   top: 0,
                                          //     //   child: Transform.translate(
                                          //     //     offset: Offset(10, -40),
                                          //     //     child: Transform.scale(
                                          //     //       scale: 2,
                                          //     //       child: Image(
                                          //     //         image: NetworkImage(
                                          //     //             cartState
                                          //     //                 .products[index].images!.image
                                          //     //                 .toString()
                                          //     //         ),
                                          //     //         height: size.height * .08,
                                          //     //      //   width: size.height * .15,
                                          //     //       ),
                                          //     //     ),
                                          //     //   ),
                                          //     // ),
                                          //     // SimpleShadow(
                                          //     //     opacity: 0.3, // Default: 0.5
                                          //     //     color: Colors.black, // Default: Black
                                          //     //     offset: Offset(1, 3), // Default: Offset(2, 2)
                                          //     //     sigma: 5, // Defaul
                                          //     //    child:
                                          //         Image.network(cartState
                                          //             .products[index].images!.image
                                          //             .toString()),
                                          //
                                          //   ],
                                          // ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                            child: ClipRRect(
                                             // clipper: NativeClipper2(size:  size.width * .4),
                                              borderRadius: BorderRadius.circular(7),
                                              child:
                                              SimpleShadow(
                                                opacity: 0.3, // Default: 0.5
                                                color: Colors.black, // Default: Black
                                                offset: Offset(1, 3), // Default: Offset(2, 2)
                                                sigma: 5, // Defaul
                                                child: Image.network(cartState
                                                    .products[index].images!.image
                                                    .toString()),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                cartState.products[index].title!.en!,
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: TextStyle(
                                                    fontSize: size.height * 0.022,
                                                    height:  size.height*0.003,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              ListView.builder(
                                                padding: EdgeInsets.zero,
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: cartState.products[index]
                                                      .attributes?.length ??
                                                      0,
                                                  itemBuilder: (ctx, i) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        // if (cartState
                                                        //     .products[index]
                                                        //     .attributes![i]
                                                        //     .title!
                                                        //     .en ==
                                                        //     "Size")
                                                        //   Text(
                                                        //     cartState
                                                        //         .products[index]
                                                        //         .attributes![i]
                                                        //         .values![0]
                                                        //         .attributeValue!
                                                        //         .en
                                                        //         .toString(),
                                                        //     style: TextStyle(
                                                        //         height:  size.height*0.001,
                                                        //         fontSize: size.height *
                                                        //             0.02),
                                                        //   ),
                                                        // if (cartState
                                                        //     .products[index]
                                                        //     .attributes![i]
                                                        //     .title!
                                                        //     .en !=
                                                        //     "Size")
                                                          Text(
                                                            cartState
                                                                .products[index]
                                                                .attributes![i]
                                                                .title!
                                                                .en
                                                                .toString(),
                                                            style: TextStyle(
                                                                height:  size.height*0.001,
                                                                fontSize: size.height *
                                                                    0.018),
                                                          ),
                                                        // if (cartState
                                                        //     .products[index]
                                                        //     .attributes![i]
                                                        //     .title!
                                                        //     .en !=
                                                        //     "Size")
                                                          Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                            children: [
                                                              for (int e = 0;
                                                              e <
                                                                  cartState
                                                                      .products[
                                                                  index]
                                                                      .attributes![
                                                                  i]
                                                                      .values!
                                                                      .length;
                                                              e++)
                                                                Text(
                                                                  cartState
                                                                      .products[index]
                                                                      .attributes![i]
                                                                      .values![e]
                                                                      .attributeValue!
                                                                      .en
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      height:  size.height*0.0025,
                                                                      fontSize:
                                                                      size.height *
                                                                          0.015,
                                                                      color:
                                                                      Colors.grey),
                                                                ),
                                                            ],
                                                          ),

                                                      ],
                                                    );
                                                  }),
                                              ListView.builder(
                                                  physics:
                                                  NeverScrollableScrollPhysics(),
                                                  shrinkWrap: true,
                                                  scrollDirection: Axis.vertical,
                                                  itemCount: cartState.products[index]
                                                      .addons?.length ??
                                                      0,
                                                  itemBuilder: (ctx, i) {
                                                    return Column(
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                      children: [
                                                        Text(
                                                          cartState
                                                              .products[index]
                                                              .addons![i]
                                                              .title!
                                                              .en
                                                              .toString(),
                                                          style: TextStyle(
                                                              height:  size.height*0.001,
                                                              fontSize: size.height *
                                                                  0.018),
                                                        ),
                                                        Column(
                                                          crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                          children: [
                                                            for (int e = 0;
                                                            e <
                                                                cartState
                                                                    .products[
                                                                index]
                                                                    .addons![
                                                                i]
                                                                    .values!
                                                                    .length;
                                                            e++)
                                                              Text(
                                                                cartState
                                                                    .products[index]
                                                                    .addons![i]
                                                                    .values![e]
                                                                    .title!
                                                                    .en
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    height:  size.height*0.0025,
                                                                    fontSize:
                                                                    size.height *
                                                                        0.015,
                                                                    color:
                                                                    Colors.grey),
                                                              ),
                                                          ],
                                                        ),

                                                      ],
                                                    );
                                                  }),

                                              SizedBox(
                                                height: size.height * .003,
                                              ),
                                              //
                                              Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<CartCubit>()
                                                          .countIncrementAdnDecrement(
                                                          '+', index);
                                                    },
                                                    child: Container(
                                                      height: 20,
                                                      width: 30,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppTheme.secondary,
                                                        //  borderRadius:
                                                        //  BorderRadius.only(
                                                        //    topLeft:
                                                        //    Radius.circular(8),
                                                        // )
                                                      ),
                                                      child: Center(
                                                        child: Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: 15,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * .02,
                                                  ),
                                                  Text(
                                                    cartState.products[index].count
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: size.height * 0.022),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * .02,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      context
                                                          .read<CartCubit>()
                                                          .countIncrementAdnDecrement(
                                                          '-', index);
                                                    },
                                                    child: Container(
                                                      height: 20,
                                                      width: 30,
                                                      alignment: Alignment.center,
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        color: AppTheme.secondary,
                                                        // borderRadius:
                                                        // BorderRadius.only(
                                                        //   bottomLeft:
                                                        //   Radius.circular(8),
                                                        // )
                                                      ),
                                                      child: Icon(
                                                        FontAwesomeIcons.minus,
                                                        color: Colors.white,
                                                        size: 12,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      thickness: 1,
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        GestureDetector(
                                          onTap: () {

                                           cartState.removeItem(index,context);
                                          },
                                          child: Container(
                                           // color: Colors.orange,
                                            padding:EdgeInsets.symmetric(horizontal:  size.width * .06,vertical:   size.width * .018),
                                              child: Image.asset(
                                                "assets/images/bin.png",
                                                width: size.height * .03,
                                                color: Colors.grey,
                                              )),
                                        ),
                                        Container(
                                          height: size.height * .035,
                                          width: size.width * .012,
                                          decoration: BoxDecoration(
                                            //  color: dark,

                                              borderRadius: BorderRadius.circular(15)),
                                          child: VerticalDivider(
                                            //  color: FitnessAppTheme.secondary,
                                            //   width:  size.width*.001,
                                            thickness: 1,
                                          ),
                                        ),
                                        Text(
                                          "${cartState.products[index].total!.toStringAsFixed(2)} ${LocaleKeys.kwd.tr()}",
                                          style: TextStyle(
                                              height:  size.height*0.003,
                                              fontSize: size.height * 0.02,
                                              fontWeight: FontWeight.bold,
                                              color: AppTheme.orange),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        alignment: Alignment.bottomCenter,
                        decoration: BoxDecoration(
                          //  color: dark,
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey
                                      .withOpacity(0.3),
                                  offset: const Offset(1.1, 4.0),
                                  blurRadius: 8.0),
                            ],
                            color: AppTheme.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(15),
                              topRight: Radius.circular(15)
                            )),
                        padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                        child: Column(
                          children: [


                            SizedBox(height: size.height*0.02,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: ExpansionTile(
                                title:    Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      LocaleKeys.total_amount.tr(),
                                      style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 6.0, vertical: 2),
                                      child: Text(
                                          '${cartState.calculateTotal().toStringAsFixed(2)} ${LocaleKeys.kwd.tr()}',
                                          style:
                                          TextStyle(fontSize: size.height * 0.023 , color: Colors.green, height: size.height * .0015,fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                                iconColor: Colors.black45,

                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: size.height * .03,
                                      ),


                                      if(LocalStorage.getData(key: "coupon") != null)
                                        Container(
                                            padding: EdgeInsets.only(
                                                left: size.width * .04,
                                                right: size.width * .04,
                                                top: size.width * .02,
                                                bottom: size.width *.01),
                                            //   margin: EdgeInsets.only(bottom: 12),
                                            decoration: BoxDecoration(

                                              borderRadius: BorderRadius.circular(7),
                                              color: AppTheme.secondary.withOpacity(.1),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  LocaleKeys.coupon.tr() +" : "+ (LocalStorage.getData(key: "coupon")??""),
                                                  //  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: size.height * 0.022,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                GestureDetector(
                                                  onTap: (){
                                                    cartState.deleteCoupon();
                                                  },
                                                  child: Text(
                                                    LocaleKeys.delete.tr() ,
                                                    //  textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.red,
                                                        fontSize: size.height * 0.022,
                                                        fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            )
                                        ),
                                      SizedBox(
                                        height: size.height * .02,
                                      ),
                                      Text(
                                        LocaleKeys.the_total_amount.tr(),
                                        style:
                                        TextStyle(fontSize: size.height * 0.025, fontWeight: FontWeight.bold, height: size.height * .002,),
                                      ),
                                      SizedBox(
                                        height: size.height * .02,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            LocaleKeys.total_items.tr(),
                                            style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 2),
                                            child: Text(
                                                '${context.read<CartCubit>().calculateAmount()}',
                                                style:
                                                TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * .01,
                                      ),
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text(
                                            LocaleKeys.total_price.tr(),
                                            style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .001,),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 6.0, vertical: 2),
                                            child: Text(
                                                '${context.read<CartCubit>().calculatePrices().toStringAsFixed(2)} ${LocaleKeys.kwd.tr()} ',
                                                style:
                                                TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .001,)),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * .01,
                                      ),
                                      // if (cartState.tax != 0.0)
                                      //   Row(
                                      //     mainAxisSize: MainAxisSize.max,
                                      //     crossAxisAlignment: CrossAxisAlignment.end,
                                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //     children: <Widget>[
                                      //       Text(
                                      //         LocaleKeys.tax_expense.tr(),
                                      //         style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),
                                      //         textAlign: TextAlign.center,
                                      //       ),
                                      //       Padding(
                                      //         padding: EdgeInsets.symmetric(
                                      //             horizontal: 6.0, vertical: 2),
                                      //         child: Text(
                                      //             '${context.read<CartCubit>().calculateTax().toStringAsFixed(2)} ${LocaleKeys.kwd.tr()} ',
                                      //             style: TextStyle(
                                      //               fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,)),
                                      //       ),
                                      //     ],
                                      //   ),
                                      // SizedBox(
                                      //   height: size.height * .01,
                                      // ),

                                      if (cartState.discount != 0)
                                        Row(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              LocaleKeys.discount.tr(),
                                              style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),
                                              textAlign: TextAlign.center,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 6.0, vertical: 2),
                                              child: Text(
                                                  '-${cartState.calculateDiscount()} ${LocaleKeys.kwd.tr()}',
                                                  style: TextStyle(
                                                    fontSize: size.height * 0.023, color: Colors.red, height: size.height * .0015,)),
                                            ),
                                          ],
                                        ),
                                      if (cartState.discount != 0)
                                        SizedBox(
                                          height: size.height * .03,
                                        ),
                                      // Row(
                                      //   mainAxisSize: MainAxisSize.max,
                                      //   crossAxisAlignment: CrossAxisAlignment.end,
                                      //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      //   children: <Widget>[
                                      //     Text(
                                      //       LocaleKeys.total_amount.tr(),
                                      //       style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,fontWeight: FontWeight.bold),
                                      //       textAlign: TextAlign.center,
                                      //     ),
                                      //     Padding(
                                      //       padding: EdgeInsets.symmetric(
                                      //           horizontal: 6.0, vertical: 2),
                                      //       child: Text(
                                      //           '${cartState.calculateTotal().toStringAsFixed(2)} ${LocaleKeys.kwd.tr()}',
                                      //           style:
                                      //           TextStyle(fontSize: size.height * 0.023 , color: Colors.green, height: size.height * .0015,fontWeight: FontWeight.bold)),
                                      //     ),
                                      //   ],
                                      // ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text(
                                        LocaleKeys.cart_warning.tr(),
                                        style: TextStyle(fontSize: size.height * 0.018, color: Colors.red, height: size.height * .0015),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(
                                        height: size.height * .02,
                                      ),
                                      // CheckboxListTile(
                                      //   contentPadding: EdgeInsets.zero,
                                      //   title: GestureDetector(
                                      //       onTap: () {
                                      //         setState(() {
                                      //           checkedNote = !checkedNote;
                                      //         });
                                      //       },
                                      //       child: Text(
                                      //         LocaleKeys.any_special_request.tr(),
                                      //         style:
                                      //         TextStyle(fontSize: size.height * 0.025, color: AppTheme.orange),
                                      //       )),
                                      //   value: checkedNote,
                                      //   onChanged: (newValue) {
                                      //     setState(() {
                                      //       checkedNote = newValue!;
                                      //     });
                                      //   },
                                      //   controlAffinity: ListTileControlAffinity
                                      //       .leading, //  <-- leading Checkbox
                                      // ),
                                      // Visibility(
                                      //   visible: checkedNote,
                                      //   child: Padding(
                                      //     padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                      //     child: TextFormField(
                                      //       controller: cartState.note,
                                      //       cursorColor: AppTheme.orange,
                                      //       keyboardType: TextInputType.text,
                                      //       style: TextStyle(
                                      //           fontSize: size.height * 0.025, height: size.height * .002,),
                                      //       decoration: InputDecoration(
                                      //         hintText: LocaleKeys.enter_your_notes.tr(),
                                      //         hintStyle:  TextStyle(
                                      //             fontSize: size.height * 0.025, height: size.height * .002,),
                                      //         border: OutlineInputBorder(
                                      //             borderRadius:
                                      //             BorderRadius.all(Radius.circular(8)),
                                      //             borderSide:
                                      //             BorderSide(width: 1, color: AppTheme.orange)),
                                      //         focusedBorder: OutlineInputBorder(
                                      //           borderRadius: BorderRadius.all(Radius.circular(15)),
                                      //           borderSide:
                                      //           BorderSide(width: 1, color: Colors.grey),
                                      //         ),
                                      //       ),
                                      //       onChanged: (value) {
                                      //         cartState.setNote(value);
                                      //       },
                                      //       validator: (value) {
                                      //         if (value!.isEmpty) return 'Required';
                                      //         return null;
                                      //       },
                                      //     ),
                                      //   ),
                                      // ),
                                      InkWell(
                                        onTap: () {
                                          Scaffold.of(context)
                                              .showBottomSheet<void>(
                                                (BuildContext context) {
                                              return Container(
                                                height: size.height * 0.25,
                                                color: Colors.white,
                                                child: Stack(
                                                  children: [
                                                    Center(
                                                      child: Column(
                                                        mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .start,
                                                        mainAxisSize:
                                                        MainAxisSize.min,
                                                        children: <Widget>[
                                                          Padding(
                                                            padding:
                                                            const EdgeInsets
                                                                .all(18.0),
                                                            child: Container(
                                                              height:
                                                              size.height *
                                                                  0.19,
                                                              width: size.width,
                                                              decoration: BoxDecoration(
                                                                  borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                      15),
                                                                  border: Border.all(
                                                                      color: AppTheme
                                                                          .orange)),
                                                              child: Padding(
                                                                padding:
                                                                const EdgeInsets
                                                                    .all(
                                                                    10.0),
                                                                child:
                                                                TextField(
                                                                  maxLength: 140,
                                                                  maxLines: 4,
                                                                  controller:
                                                                  cartState.note,
                                                                  style:  TextStyle(
                                                                      fontSize:
                                                                      size.height * 0.025),
                                                                  cursorColor:
                                                                  AppTheme
                                                                      .orange,
                                                                  decoration:
                                                                  InputDecoration(
                                                                    label: Text(
                                                                      LocaleKeys.add_notes.tr(),
                                                                      style: TextStyle(
                                                                          color: AppTheme
                                                                              .orange,
                                                                          fontSize:
                                                                          size.height * 0.025),
                                                                    ),
                                                                    border:
                                                                    InputBorder
                                                                        .none,
                                                                  ),
                                                                  onChanged:
                                                                      (text) {
                                                                    cartState
                                                                        .setNote(
                                                                        text);
                                                                  },
                                                                  onEditingComplete:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    Positioned(
                                                        right: 10,
                                                        top: 10,
                                                        child: GestureDetector(
                                                          onTap: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Container(
                                                            width: 28,
                                                            height: 28,
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                color: AppTheme
                                                                    .orange,
                                                                border: Border.all(
                                                                    color: AppTheme
                                                                        .orange,
                                                                    width: 2)),
                                                            child: Center(
                                                              child: Icon(
                                                                Icons.check,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            ),
                                                          ),
                                                        ))
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 0),
                                          child: Row(
                                            children: [
                                              Icon(Icons.messenger_outline),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                LocaleKeys.any_special_request.tr(),
                                                style: TextStyle(
                                                    height:  size.height*0.002,
                                                    fontSize:
                                                    size.height * 0.022,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              ),
                                              Spacer(),
                                              Text(
                                                LocaleKeys.add_note.tr(),
                                                style: TextStyle(
                                                    height:  size.height*0.002,
                                                    color: AppTheme.orange,
                                                    fontSize:
                                                    size.height * 0.022,
                                                    fontWeight:
                                                    FontWeight.w500),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 38.0),
                                        child: Text(
                                          cartState.note.text.toString() ??
                                              '',
                                          style: TextStyle(
                                              color: Colors.black38,
                                              height:  size.height*0.003,
                                              fontSize: size.height * 0.02),
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * .03,
                                      ),

                                    ],
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: size.height * .07,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                DefaultButton(
                                  width: size.width *.4,
                                  height: size.height * .07,
                                  textColor: AppTheme.secondary,
                                  color: AppTheme.white,
                                  borderColor: AppTheme.secondary,
                                  title: LocaleKeys.add_more.tr(),
                                  radius: 15,
                                  function: () {
                                    push(context, BottomNavBar());
                                  },
                                  font: size.height * 0.025,
                                ),
                                DefaultButton(
                                  width: size.width *.4,

                                  height: size.height * .07,
                                  textColor: Colors.white,
                                  color: AppTheme.secondary,
                                  title: LocaleKeys.continuee.tr(),
                                  radius: 15,
                                  function: () {
                                    if (LocalStorage.getData(key: "token") != null) {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MultiBlocProvider(
                                                providers: [
                                                  BlocProvider<OrderMethodCubit>(
                                                    create: (BuildContext context) =>
                                                        OrderMethodCubit(
                                                            OrderMethodRepo(),context,lang),
                                                  ),
                                                  BlocProvider<PaymentMethodCubit>(
                                                    create: (BuildContext context) =>
                                                        PaymentMethodCubit(
                                                            OrderMethodRepo()),
                                                  ),
                                                ],
                                                child: OrderMethodsScreen(descount:cartState.discountRest),
                                              )));
                                    } else {
                                      push(
                                          context,
                                          BlocProvider(
                                              create: (BuildContext context) =>
                                                  AuthCubit(AuthRepo()),
                                              child: Login()));
                                    }
                                  },
                                  font: size.height * 0.025,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: widget.fromHome? size.height * .1:size.height * .03,
                            ),
                          ],
                        ),

                      ),
                    ),
                    // SizedBox(
                    //   height: widget.fromHome? size.height * .12:size.height * .04,
                    // ),
                  ],
                )

          ],
        ),
      );

      return SizedBox();
    })
          : Container(
        height: MediaQuery.of(context).size.height,
        width:  MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset("assets/images/off.gif"),
            Text(LocaleKeys.offline_translate.tr(),
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ],
        ),
      );

  }
}


class NativeClipper2 extends CustomClipper<Path> {
  final double size;
  const NativeClipper2({Key? key, required this.size});

  @override
  Path getClip(sizee) {
    Path path = Path();

    path.lineTo(0, 0);
    path.lineTo(0, size);
    path.quadraticBezierTo(
        size / 2, size, size, size - 180);
    path.lineTo(size, 0);
   // path.lineTo(size, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}