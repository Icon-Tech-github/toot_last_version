import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:loz/bloc/cart_bloc/cart_cubit.dart';
import 'package:loz/bloc/single_product_bloc/single_product_cubit.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/data/repositories/cart.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/widgets/custom_icon_button.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/presentation/widgets/hex_color.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../theme.dart';
import 'Auth_screens/login.dart';
import 'cart.dart';

class ProductDetailsScreen extends StatelessWidget {
  List<int> options = [];
  final ScrollController scrollController = ScrollController();
  var opacityActionButton = 1.0;
  var isVisibleActionButton = true;
  bool isFavorite = false;
  final AnimationController? animationController;
  final ProductModel? product;
  final String? startColor;
  final String? endColor;

  ProductDetailsScreen(
      {Key? key,
      this.animationController,
      this.product,
      this.endColor,
      this.startColor})
      : super(key: key);

  void onEndAnimationActionButton() {
    if (opacityActionButton == 0) {
      isVisibleActionButton = false;
    } else {
      isVisibleActionButton = true;
    }
  }

  //
  // @override
  // void initState() {
  //   // TODO: implement initState
  //   //  onScroll();
  //   scrollController.addListener(() {
  //     if (scrollController.offset >= 100) {
  //       if (opacityActionButton != 0.0) {
  //         print("kkkk");
  //
  //         setState(() {
  //           opacityActionButton = 0.0;
  //         });
  //       }
  //     } else if (scrollController.offset <= 0) {
  //
  //       if (opacityActionButton != 1.0) {
  //         setState(() {
  //           opacityActionButton = 1.0;
  //           isVisibleActionButton = true;
  //         });
  //       }
  //     } else if (scrollController.offset <= 100 &&
  //         scrollController.offset >= 0) {
  //       print("kkklllk");
  //       if (opacityActionButton != scrollController.offset / 100) {
  //         setState(() {
  //           opacityActionButton = scrollController.offset / 100;
  //         });
  //       }
  //     }
  //   });
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          // DETAIL CONTENT
          BlocBuilder<SingleProductCubit, SingleProductState>(
              builder: (context, state) {
            final detailsState = context.read<SingleProductCubit>();
            return detailsState.isLoad == true
                ? Center(
                    child: Container(
                      height: size.height * 0.4,
                      width: size.width * 0.5,
                      alignment: Alignment.bottomCenter,
                      child: const LoadingIndicator(
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
                  )
                : SingleChildScrollView(
                    controller: scrollController,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            // BACKGROUND IMAGES
                            Container(
                              height: size.height,
                              width: size.width,
                              decoration: BoxDecoration(
                                color: AppTheme.secondary,
                                borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(8.0),
                                  bottomLeft: Radius.circular(8.0),
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: size.height * .1,
                                  ),
                                  Text(detailsState.globalProduct!.category!.title!.en.toString(),
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: AppTheme.yellow,
                                          letterSpacing: 10)),
                                  Text(
                                      detailsState.globalProduct!.title!.en
                                          .toString()
                                          .toUpperCase(),
                                      style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.white,
                                          height: size.height * .001)),
                                  SizedBox(
                                    height: size.height * .18,
                                  ),
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.symmetric(horizontal: 35),
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: AppTheme.lightSec,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.3),
                                            topRight: Radius.circular(
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3.3),
                                          )),
                                      child: Column(
                                        children: [
                                          Transform.translate(
                                            offset: Offset(10, -40),
                                            child: Transform.scale(
                                              scale: 2.6,
                                              child: Hero(
                                                tag: detailsState
                                                    .globalProduct!.id
                                                    .toString(),
                                                child: Image(
                                                  image: NetworkImage(
                                                    detailsState.globalProduct!
                                                                .images ==
                                                            null
                                                        ? ""
                                                        : detailsState
                                                            .globalProduct!
                                                            .images!
                                                            .image
                                                            .toString(),
                                                  ),
                                                  height: 100,
                                                  width: 100,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: size.height * .04,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    detailsState.price
                                                            .toStringAsFixed(
                                                                2) +
                                                        ' ' +
                                                        LocaleKeys.kwd.tr(),
                                                    style: TextStyle(
                                                        height: size.height *.002,
                                                        color: AppTheme.nearlyBlack,
                                                        fontSize: size.width * .08),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Text(
                                                    "PER KG",
                                                    style: TextStyle(
                                                      fontSize: size.width * .04,
                                                        height: size.height *.001,
                                                        color: Colors.grey,
                                                        letterSpacing: 5),
                                                  )
                                                ],
                                              ),
                                              CircleAvatar(
                                                  backgroundColor:
                                                      Colors.grey.withOpacity(.3),
                                                  radius: 30,
                                                  child: Icon(Icons.favorite,
                                                      color: Colors.red))
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),

                             //BODY
                              BlocConsumer<SingleProductCubit, SingleProductState>(
                                  listener:(context, state)  {

                                  },
                                  builder: (context, state) {
                                    final detailsState = context.read<SingleProductCubit>();
                                    return      detailsState.isLoad == true?

                                    Center(
                                      child: Container(
                                        height: size.height * 0.4,
                                        width: size.width * 0.5,
                                        alignment: Alignment.bottomCenter,
                                        child: const LoadingIndicator(
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
                                    ):
                                    Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              top: MediaQuery.of(context).size.width - 110),
                                        //  height: size.height,
                                          // padding: EdgeInsets.fromLTRB(15, 50, 10, 10),
                                          // constraints: BoxConstraints(
                                          //   maxHeight: MediaQuery.of(context).size.height ,
                                          //   //    maxWidth: 400,
                                          // ),
                                          decoration:  BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(size.width * 0.5),
                                              topRight: Radius.circular(size.width * 0.5),
                                            ),
                                          ),
                                          child: Stack(
                                            alignment: Alignment.topCenter,
                                            children: [
                                              ListView(
                                                physics: NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                children: [
                                                  SizedBox(height: size.height *
                                                      0.15,),
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Text(detailsState.globalProduct!.title!.en.toString(),
                                                          style: TextStyle(
                                                              height:  size.height*0.002,
                                                              fontSize:
                                                              size.height *
                                                                  0.03,
                                                              fontWeight:
                                                              FontWeight
                                                                  .bold),
                                                        ),
                                                        if(detailsState.globalProduct!.calories != null)
                                                        Row(

                                                          children: [
                                                            Image.asset("assets/images/burning.png",height: size.height * .033,),
                                                            Text("${detailsState.globalProduct!.calories} ${LocaleKeys.kcal.tr()}",
                                                              style: TextStyle(
                                                                height:  size.height*0.003,
                                                                fontSize:
                                                                size.height *
                                                                    0.02,),
                                                            ),
                                                          ],
                                                        )


                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.01 ,
                                                  ),
                                                  if(detailsState.globalProduct!.description?.en != null)
                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                    child: Text(detailsState.globalProduct!.description!.en.toString(),
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        height:  size.height*0.002,
                                                        fontSize:
                                                        size.height *
                                                            0.02,),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: size.height * 0.02 ,
                                                  ),

                                                  Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(   detailsState.globalProduct!.price ==0? LocaleKeys.depends_on.tr():
                                                          //  "the price depends on your choice":
                                                            context.read<SingleProductCubit>().price.toStringAsFixed(2) + ' ' +LocaleKeys.kwd.tr(),
                                                              style: TextStyle(
                                                                  height:  size.height*0.002,
                                                                  color: detailsState.globalProduct!.price ==0 ? AppTheme.yellow : AppTheme.nearlyBlack,
                                                                  fontSize:  detailsState.globalProduct!.price ==0?
                                                                  size.height *
                                                                      0.018: size.height * .028,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                            ),
                                                            SizedBox(
                                                              width: size.width * 0.02 ,
                                                            ),

                                                            if(double.parse(detailsState.globalProduct!.newPrice.toString()) != 0.0 || detailsState.globalProduct!.newPrice !=0)
                                                              Text(  detailsState.globalProduct!.price.toString() + ' ' +LocaleKeys.kwd.tr(),
                                                                style: TextStyle(
                                                                  decoration: TextDecoration.lineThrough,
                                                                    height:  size.height*0.002,
                                                                    color: AppTheme.yellow,
                                                                    fontSize:
                                                                    size.height *
                                                                        0.02,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                              ),
                                                          ],
                                                        ),
                                                        if(detailsState.globalProduct!.sensitive?.en != null)
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                          children: [
                                                            InkWell(
                                                              onTap:(){
                                                                _showDialog(context,detailsState.globalProduct!.sensitive!.en.toString());
                                                              },
                                                              child: Container(
                                                                width: 25,
                                                                height: 25,
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
                                                                    Icons.info,
                                                                    color: Colors
                                                                        .white,
                                                                    size: 20,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: size.width * 0.02 ,
                                                            ),
                                                            Text(
                                                              LocaleKeys.sensitive.tr(),
                                                              style: TextStyle(
                                                                fontSize: size.width * .035,
                                                                color: Colors.black,
                                                              ),
                                                              textAlign: TextAlign.center,
                                                            ),

                                                          ],
                                                        ),
                                                        // Row(
                                                        //   crossAxisAlignment: CrossAxisAlignment.center,
                                                        //   children: [
                                                        //     Image.asset("assets/images/attention.png",height: size.height * .033,),
                                                        //     Text("100 g",
                                                        //       style: TextStyle(
                                                        //         height:  size.height*0.003,
                                                        //         fontSize:
                                                        //         size.height *
                                                        //             0.02,),
                                                        //     ),
                                                        //   ],
                                                        // )

                                                      ],
                                                    ),
                                                  ),
                                                  ListView.builder(
                                                      physics:
                                                      NeverScrollableScrollPhysics(),
                                                      scrollDirection: Axis.vertical,
                                                      shrinkWrap: true,
                                                      itemCount:
                                                      detailsState.globalProduct!.attributes!.length,
                                                      itemBuilder: (context, i) {
                                                        return Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                            CrossAxisAlignment.start,
                                                            children: [

                                                              // Row(
                                                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                              //   crossAxisAlignment: CrossAxisAlignment.center,
                                                              //   children: [
                                                              //
                                                              //     Row(
                                                              //       mainAxisAlignment:
                                                              //       MainAxisAlignment.center,
                                                              //       children: [
                                                              //         InkWell(
                                                              //           onTap: () {
                                                              //             context
                                                              //                 .read<SingleProductCubit>()
                                                              //                 .countIncrementAdnDecrement(
                                                              //                 '+');
                                                              //           },
                                                              //           child: Container(
                                                              //             height: size.height * 0.06,
                                                              //             width: size.width * 0.1,
                                                              //             decoration: BoxDecoration(
                                                              //               shape: BoxShape.circle,
                                                              //               border: Border.all(
                                                              //                   color:
                                                              //                   HexColor(endColor!)),
                                                              //               // borderRadius:
                                                              //               // BorderRadius.circular(
                                                              //               //     10)
                                                              //             ),
                                                              //             child: Center(
                                                              //               child: Icon(
                                                              //                 Icons.add,
                                                              //                 color: AppTheme.secondary,
                                                              //                 size:  size.width * 0.07,
                                                              //               ),
                                                              //             ),
                                                              //           ),
                                                              //         ),
                                                              //         SizedBox(
                                                              //           width: size.width * 0.01,
                                                              //         ),
                                                              //         Container(
                                                              //           height: size.height * 0.06,
                                                              //           width: size.width * 0.1,
                                                              //           // decoration: BoxDecoration(
                                                              //           //     color: Colors.white,
                                                              //           //     borderRadius:
                                                              //           //     BorderRadius.circular(10),
                                                              //           //     border: Border.all(
                                                              //           //         color:
                                                              //           //         HexColor(endColor!))),
                                                              //           child: Center(
                                                              //             child: Text(context
                                                              //                 .read<SingleProductCubit>()
                                                              //                 .itemCount
                                                              //                 .toString(),style: TextStyle(fontSize: size.height * 0.025,),),
                                                              //           ),
                                                              //         ),
                                                              //         SizedBox(
                                                              //           width: size.width * 0.01,
                                                              //         ),
                                                              //         InkWell(
                                                              //           onTap: () {
                                                              //             context
                                                              //                 .read<SingleProductCubit>()
                                                              //                 .countIncrementAdnDecrement(
                                                              //                 '-');
                                                              //           },
                                                              //           child: Container(
                                                              //             height: size.height * 0.06,
                                                              //             width: size.width * 0.1,
                                                              //             decoration: BoxDecoration(
                                                              //               shape: BoxShape.circle,
                                                              //               //  color: HexColor(endColor!),
                                                              //               border: Border.all(
                                                              //                   color:
                                                              //                   HexColor(endColor!)),
                                                              //               // borderRadius:
                                                              //               // BorderRadius.circular(
                                                              //               //     10)
                                                              //             ),
                                                              //             child: Center(
                                                              //               child: Icon(
                                                              //                 Icons.remove,
                                                              //                 color: AppTheme.secondary,
                                                              //                 size:  size.width * 0.07,
                                                              //               ),
                                                              //             ),
                                                              //           ),
                                                              //         ),
                                                              //       ],
                                                              //     ),
                                                              //     Text(  context.read<SingleProductCubit>().price.toStringAsFixed(3) + ' ' +LocaleKeys.kwd.tr(),
                                                              //       style: TextStyle(
                                                              //           height:  size.height*0.002,
                                                              //           color: AppTheme.nearlyBlack,
                                                              //           fontSize:
                                                              //           size.height *
                                                              //               0.03,
                                                              //           fontWeight:
                                                              //           FontWeight
                                                              //               .bold),
                                                              //     ),
                                                              //   ],
                                                              // ),
                                                              SizedBox(height: size.height *
                                                                  0.03,),
                                                              Row(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  // Container(
                                                                  //   height: size.height * .075,
                                                                  //   width: size.width*.01,
                                                                  //   decoration: BoxDecoration(
                                                                  //     //   color: dark,
                                                                  //
                                                                  //       borderRadius: BorderRadius.circular(15)
                                                                  //   ),
                                                                  //   child:  VerticalDivider(
                                                                  //     color: AppTheme.nearlyBlack,
                                                                  //     thickness:  size.width*.01,
                                                                  //
                                                                  //   ),),
                                                                  // SizedBox(
                                                                  //   width:  size.width * .017,
                                                                  // ),
                                                                  Column(
                                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                                    children: [
                                                                      SizedBox(
                                                                        width: size.width - 50,
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                Container(
                                                                                  height: size.height * .03,
                                                                                  width: size.width*.01,
                                                                                  decoration: BoxDecoration(
                                                                                    //   color: dark,

                                                                                      borderRadius: BorderRadius.circular(15)
                                                                                  ),
                                                                                  child:  VerticalDivider(
                                                                                    color: AppTheme.nearlyBlack,
                                                                                    thickness:  size.width*.01,

                                                                                  ),),
                                                                                SizedBox(
                                                                                  width:  size.width * .017,
                                                                                ),
                                                                                Text(
                                                                                  detailsState.globalProduct!
                                                                                      .attributes![i]
                                                                                      .title!
                                                                                      .en!,
                                                                                  style: TextStyle(
                                                                                      height:  size.height*0.003,
                                                                                      fontSize:
                                                                                      size.height *
                                                                                          0.025,
                                                                                      fontWeight:
                                                                                      FontWeight
                                                                                          .bold),
                                                                                ),
                                                                              ],
                                                                            ),

                                                                            if (detailsState
                                                                                .attributePrices[
                                                                            i] !=
                                                                                0)
                                                                              Text(
                                                                                "${detailsState.attributePrices[i].toStringAsFixed(2)} ${LocaleKeys.kwd.tr()}",
                                                                                style: TextStyle(
                                                                                    height:  size.height*0.002,
                                                                                    fontSize:
                                                                                    size.height *
                                                                                        0.02,
                                                                                    fontWeight:
                                                                                    FontWeight.bold
                                                                                ),
                                                                              ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:10.0,vertical: 0),
                                                                        child: Text(
                                                                          detailsState.globalProduct!.attributes![i]
                                                                              .multiSelect ==
                                                                              0
                                                                              ? LocaleKeys.Choice.tr()
                                                                              : LocaleKeys.Multi_Choices.tr(),
                                                                          style: TextStyle(
                                                                              height:  size.height*0.001,
                                                                              color: Colors.grey,
                                                                              fontSize:
                                                                              size.height * 0.018,
                                                                              fontWeight:
                                                                              FontWeight.bold),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),

                                                              // if ( detailsState.globalProduct!.attributes![i]
                                                              //     .overridePrice ==
                                                              //     1 &&
                                                              //     detailsState.globalProduct!.attributes![i]
                                                              //         .required ==
                                                              //         1)
                                                              //   Container(
                                                              //     height: size.height * 0.15,
                                                              //     width: double.infinity,
                                                              //     child: Row(
                                                              //       mainAxisAlignment:
                                                              //       MainAxisAlignment
                                                              //           .spaceAround,
                                                              //       children:  detailsState.globalProduct!
                                                              //           .attributes![i]
                                                              //           .values!
                                                              //           .map((e) {
                                                              //         int index = detailsState.globalProduct!
                                                              //             .attributes![i]
                                                              //             .values!
                                                              //             .indexOf(e);
                                                              //         return Padding(
                                                              //           padding:
                                                              //           const EdgeInsets
                                                              //               .symmetric(
                                                              //               vertical: 20),
                                                              //           child: InkWell(
                                                              //             onTap: () {
                                                              //               print( detailsState.globalProduct!
                                                              //                   .attributes![
                                                              //               i]
                                                              //                   .values![
                                                              //               index]
                                                              //                   .id);
                                                              //               context
                                                              //                   .read<
                                                              //                   SingleProductCubit>()
                                                              //                   .switchSingleSelect(
                                                              //                   i,
                                                              //                   detailsState.globalProduct!
                                                              //                       .attributes![
                                                              //                   i]
                                                              //                       .values!,
                                                              //                   index);
                                                              //             },
                                                              //             child:
                                                              //             Container(
                                                              //               height: size.height * 0.085,
                                                              //               padding: EdgeInsets.all(3),
                                                              //               decoration: BoxDecoration(
                                                              //                 //  shape: BoxShape.circle,
                                                              //                   color:     detailsState.globalProduct!
                                                              //                       .attributes![
                                                              //                   i]
                                                              //                       .values![
                                                              //                   index]
                                                              //                       .chosen!? AppTheme.yellow:Colors.transparent,
                                                              //
                                                              //                   borderRadius:
                                                              //                   BorderRadius.only(
                                                              //                       topLeft: Radius.circular(20),
                                                              //                       topRight:  Radius.circular(20),
                                                              //                       bottomLeft:  Radius.circular(30),
                                                              //                       bottomRight:  Radius.circular(30)
                                                              //                   )
                                                              //               ),
                                                              //
                                                              //               child: Container(
                                                              //                 height: size.height * 0.083,
                                                              //                 width: size.width * 0.26,
                                                              //                 decoration: BoxDecoration(
                                                              //                 //  shape: BoxShape.circle,
                                                              //
                                                              //                   border: Border.all(
                                                              //                     width: 1.6,
                                                              //                       color:
                                                              //                       HexColor(endColor!)),
                                                              //                   borderRadius:
                                                              //                   BorderRadius.only(
                                                              //                     topLeft: Radius.circular(20),
                                                              //                     topRight:  Radius.circular(20),
                                                              //                     bottomLeft:  Radius.circular(30),
                                                              //                     bottomRight:  Radius.circular(30)
                                                              //                       )
                                                              //                 ),
                                                              //                 child: Center(
                                                              //                   child:   Text(
                                                              //                     e.attributeValue!
                                                              //                         .en!,
                                                              //                     style: TextStyle(
                                                              //                         height:  size.height*0.0024,
                                                              //                         fontSize:
                                                              //                         size.height *
                                                              //                             0.022),
                                                              //                   ),
                                                              //                 ),
                                                              //               ),
                                                              //             ),
                                                              //
                                                              //           ),
                                                              //         );
                                                              //       }).toList(),
                                                              //     ),
                                                              //   ),
                                                              if ( detailsState.globalProduct!.attributes![i]
                                                                  .multiSelect ==
                                                                  1)
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 10),
                                                                  child: Column(
                                                                    children:  detailsState.globalProduct!
                                                                        .attributes![i]
                                                                        .values!
                                                                        .map((e) {
                                                                      int index =  detailsState.globalProduct!
                                                                          .attributes![i]
                                                                          .values!
                                                                          .indexOf(e);
                                                                      return Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 3),
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            context
                                                                                .read<
                                                                                SingleProductCubit>()
                                                                                .switchMultiSelect(
                                                                                i,
                                                                                detailsState.globalProduct!
                                                                                    .attributes![
                                                                                i]
                                                                                    .values!,
                                                                                index);
                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                e.attributeValue!
                                                                                    .en!,
                                                                                style: TextStyle(
                                                                                    height:  size.height*0.0024,
                                                                                    fontSize:
                                                                                    size.height *
                                                                                        0.022),
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  if ( detailsState.globalProduct!
                                                                                      .attributes![i]
                                                                                      .overridePrice ==
                                                                                      0)
                                                                                    Text(
                                                                        e.price !=0?
                                                                                      e.price!.toStringAsFixed(2) +' '+
                                                                                          LocaleKeys.kwd.tr():'',
                                                                                      style: TextStyle(
                                                                                          height:  size.height*0.0024,
                                                                                          color:
                                                                                          Colors.grey,
                                                                                          fontSize: size.height * 0.017),
                                                                                    ),
                                                                                  SizedBox(
                                                                                    width: size
                                                                                        .width *
                                                                                        .02,
                                                                                  ),
                                                                                  SizedBox(
                                                                                    width: 25,
                                                                                    child: Transform
                                                                                        .scale(
                                                                                      scale:
                                                                                      1.3,
                                                                                      child:
                                                                                      Checkbox(
                                                                                        shape:
                                                                                        RoundedRectangleBorder(
                                                                                          borderRadius:
                                                                                          BorderRadius.circular(5),
                                                                                        ),
                                                                                        value:
                                                                                        e.chosen ?? false,
                                                                                        activeColor:
                                                                                        HexColor(endColor!),
                                                                                        onChanged:
                                                                                            (newValue) {
                                                                                          print( detailsState.globalProduct!.attributes![i].values!);
                                                                                          context.read<SingleProductCubit>().switchMultiSelect(
                                                                                              i,
                                                                                              detailsState.globalProduct!.attributes![i].values!,
                                                                                              index);
                                                                                        },
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                              if ( detailsState.globalProduct!.attributes![i]
                                                                  .multiSelect ==
                                                                  0
                                                                  // &&
                                                                  // detailsState.globalProduct!.attributes![i]
                                                                  //     .overridePrice ==
                                                                  //     0
                                                              )
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal: 10,vertical: 4),
                                                                  child: Column(
                                                                    children: detailsState.globalProduct!
                                                                        .attributes![i]
                                                                        .values!
                                                                        .map((e) {
                                                                      int index = detailsState.globalProduct!
                                                                          .attributes![i]
                                                                          .values!
                                                                          .indexOf(e);

                                                                      return Padding(
                                                                        padding:
                                                                        const EdgeInsets
                                                                            .symmetric(
                                                                            vertical: 7),
                                                                        child: InkWell(
                                                                          onTap: () {
                                                                            context
                                                                                .read<
                                                                                SingleProductCubit>()
                                                                                .switchSingleSelect(
                                                                                i,
                                                                                detailsState.globalProduct!
                                                                                    .attributes![
                                                                                i]
                                                                                    .values!,
                                                                                index);
                                                                          },
                                                                          child: Row(
                                                                            mainAxisAlignment:
                                                                            MainAxisAlignment
                                                                                .spaceBetween,
                                                                            children: [
                                                                              Text(
                                                                                e.attributeValue!
                                                                                    .en.toString(),
                                                                                style: TextStyle(
                                                                                    height:  size.height*0.0024,
                                                                                    fontSize:
                                                                                    size.height *
                                                                                        0.022),
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  if ( detailsState.globalProduct!
                                                                                      .attributes![i]
                                                                                      .overridePrice ==
                                                                                      0)
                                                                                    Text(
                                                                      e.price !=0.0?
                                                                                      e.price!.toStringAsFixed(2) +' '+
                                                                                          LocaleKeys.kwd.tr(): '',
                                                                                      style: TextStyle(
                                                                                          height:  size.height*0.0024,
                                                                                          color:
                                                                                          Colors.grey,
                                                                                          fontSize: size.height * 0.017),
                                                                                    ),
                                                                                  SizedBox(
                                                                                    width: size
                                                                                        .width *
                                                                                        .02,
                                                                                  ),
                                                                                  Container(
                                                                                    width: 25,
                                                                                    height:
                                                                                    25,
                                                                                    decoration: BoxDecoration(
                                                                                        shape: BoxShape
                                                                                            .circle,
                                                                                        color: e.chosen ?? false
                                                                                            ? HexColor(
                                                                                            endColor!)
                                                                                            : Colors
                                                                                            .white,
                                                                                        border: Border.all(
                                                                                            color: e.chosen ?? false ? HexColor(endColor!) : Colors.grey,
                                                                                            width: 2)),
                                                                                    child:
                                                                                    Center(
                                                                                      child:
                                                                                      Icon(
                                                                                        Icons
                                                                                            .check,
                                                                                        color:
                                                                                        Colors.white,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      );
                                                                    }).toList(),
                                                                  ),
                                                                ),
                                                            ],
                                                          ),
                                                        );
                                                      }),
                                                  ListView.builder(
                                                     physics: NeverScrollableScrollPhysics(),
                                                    scrollDirection: Axis.vertical,
                                                    shrinkWrap: true,
                                                    itemCount: detailsState.globalProduct!.addons!.length,
                                                    itemBuilder: (context, i) =>
                                                     Padding(
                                                       padding: const EdgeInsets.symmetric(horizontal: 18.0),                                             child: Column(
                                                        crossAxisAlignment:
                                                        CrossAxisAlignment.start,
                                                        children: [
                                                          SizedBox(height: size.height *
                                                              0.03,),
                                                          Row(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: [
                                                                  SizedBox(
                                                                    width: size.width - 60,
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            Container(
                                                                              height: size.height * .03,
                                                                              width: size.width*.01,
                                                                              decoration: BoxDecoration(
                                                                                //   color: dark,

                                                                                  borderRadius: BorderRadius.circular(15)
                                                                              ),
                                                                              child:  VerticalDivider(
                                                                                color: AppTheme.nearlyBlack,
                                                                                thickness:  size.width*.01,

                                                                              ),),
                                                                            SizedBox(
                                                                              width:  size.width * .017,
                                                                            ),
                                                                            Text(
                                                                              detailsState.globalProduct!
                                                                                  .addons![i]
                                                                                  .title!
                                                                                  .en!,
                                                                              style: TextStyle(
                                                                                  height:  size.height*0.003,
                                                                                  fontSize:
                                                                                  size.height *
                                                                                      0.025,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                            ),
                                                                          ],
                                                                        ),

                                                                        if (detailsState
                                                                            .attributePrices[
                                                                        i] !=
                                                                            0)
                                                                          Text(
                                                                            "${detailsState.attributePrices[i].toStringAsFixed(2)} ${LocaleKeys.kwd.tr()}",
                                                                            style: TextStyle(
                                                                                height:  size.height*0.002,
                                                                                fontSize:
                                                                                size.height *
                                                                                    0.02,
                                                                                fontWeight:
                                                                                FontWeight.bold
                                                                            ),
                                                                          ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:10.0,vertical: 0),
                                                                    child: Text(
                                                                      detailsState.globalProduct!.addons![i]
                                                                          .multiSelect ==
                                                                          0
                                                                          ? LocaleKeys.Choice.tr()
                                                                          : LocaleKeys.Multi_Choices.tr(),
                                                                      style: TextStyle(
                                                                          height:  size.height*0.001,
                                                                          color: Colors.grey,
                                                                          fontSize:
                                                                          size.height * 0.018,
                                                                          fontWeight:
                                                                          FontWeight.bold),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),


                                                          if ( detailsState.globalProduct!.addons![i]
                                                              .multiSelect ==
                                                              1)

                                                            SizedBox(
                                                              height: size.height * .2,
                                                              child: ListView.builder(
                                                                // physics: NeverScrollableScrollPhysics(),
                                                                  scrollDirection: Axis.horizontal,
                                                                  shrinkWrap: true,
                                                                  itemCount:  detailsState.globalProduct!
                                                                      .addons![i]
                                                                      .values!.length,
                                                                  itemBuilder: (context, ind) {
                                                                    return InkWell(
                                                                      onTap: (){
                                                                        context
                                                                            .read<
                                                                            SingleProductCubit>()
                                                                            .switchMultiSelectAddon(
                                                                            i,
                                                                            detailsState.globalProduct!
                                                                                .addons![
                                                                            i]
                                                                                .values!,
                                                                            ind);
                                                                      },
                                                                      child: Container(
                                                                        width: size.width * .27,
                                                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                                        margin:  EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                                                        decoration: BoxDecoration(
                                                                          //color: Colors.grey.withOpacity(.2),
                                                                          // border: Border.all(color: AppTheme.secondary,width: 6),

                                                                            borderRadius: BorderRadius.circular(15)
                                                                        ),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Stack(
                                                                              children: [
                                                                                Container(
                                                                                    height:  size.height * .08,
                                                                                    width: double.infinity,
                                                                                    padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                                                                                    decoration: BoxDecoration(
                                                                                        color:  Colors.grey.withOpacity(.2),
                                                                                        // border: Border.all(color: AppTheme.secondary,width: 6),

                                                                                        borderRadius: BorderRadius.circular(10)
                                                                                    ),
                                                                                    child: Image.network(detailsState.globalProduct!.addons![i].values![ind].image.toString(),height: size.height * .06,)),
                                                                                if((detailsState.globalProduct!.addons![i].values![ind].chosen ?? false) == true)
                                                                                  Container(
                                                                                    height:  size.height * .08,
                                                                                    width: double.infinity,
                                                                                    padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                                                                                    decoration: BoxDecoration(
                                                                                      //     color:  (detailsState.globalProduct!.addons![i].values![ind].chosen ?? false) == true?AppTheme.nearlyBlack.withOpacity(.3): Colors.transparent,
                                                                                        gradient: LinearGradient(
                                                                                          colors: [
                                                                                            Colors.black.withOpacity(0.02),
                                                                                            Colors.black.withOpacity(0.5),
                                                                                            Colors.black.withOpacity(0.7),
                                                                                          ],
                                                                                          begin: Alignment.topCenter,
                                                                                          end: Alignment.bottomCenter,
                                                                                        ),
                                                                                        // border: Border.all(color: AppTheme.secondary,width: 6),

                                                                                        borderRadius: BorderRadius.circular(10)
                                                                                    ),
                                                                                    child: Icon(Icons.done,color: Colors.white,),
                                                                                  )
                                                                              ],
                                                                            ),
                                                                            Text(
                                                                              detailsState.globalProduct!
                                                                                  .addons![i]
                                                                                  .values![ind].title!
                                                                                  .en!,
                                                                              style: TextStyle(
                                                                                  height:  size.height*0.003,
                                                                                  color: Colors.black,
                                                                                  fontSize:
                                                                                  size.height *
                                                                                      0.02,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                            ),
                                                                            Text(
                                                                              detailsState.globalProduct!
                                                                                  .addons![i]
                                                                                  .values![ind].price.toString()+" ${LocaleKeys.kwd.tr()}",
                                                                              style: TextStyle(
                                                                                  color: Colors.grey,
                                                                                  height:  size.height*0.002,
                                                                                  fontSize:
                                                                                  size.height *
                                                                                      0.015,
                                                                                  fontWeight:
                                                                                  FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),

                                                                      ),
                                                                    );
                                                                  }),
                                                            ),
                                                            // Padding(
                                                            //   padding: const EdgeInsets
                                                            //       .symmetric(
                                                            //       horizontal: 10),
                                                            //   child: Column(
                                                            //     children:  detailsState.globalProduct!
                                                            //         .addons![i]
                                                            //         .values!
                                                            //         .map((e) {
                                                            //       int index =  detailsState.globalProduct!
                                                            //           .addons![i]
                                                            //           .values!
                                                            //           .indexOf(e);
                                                            //       return Padding(
                                                            //         padding:
                                                            //         const EdgeInsets
                                                            //             .symmetric(
                                                            //             vertical: 3),
                                                            //         child: InkWell(
                                                            //           onTap: () {
                                                            //             context
                                                            //                 .read<
                                                            //                 SingleProductCubit>()
                                                            //                 .switchMultiSelectAddon(
                                                            //                 i,
                                                            //                 detailsState.globalProduct!
                                                            //                     .addons![
                                                            //                 i]
                                                            //                     .values!,
                                                            //                 index);
                                                            //           },
                                                            //           child: Row(
                                                            //             mainAxisAlignment:
                                                            //             MainAxisAlignment
                                                            //                 .spaceBetween,
                                                            //             children: [
                                                            //               Text(
                                                            //                 e.title!
                                                            //                     .en!,
                                                            //                 style: TextStyle(
                                                            //                     height:  size.height*0.0024,
                                                            //                     fontSize:
                                                            //                     size.height *
                                                            //                         0.022),
                                                            //               ),
                                                            //               Row(
                                                            //                 children: [
                                                            //                     Text(
                                                            //                       e.price !=0?
                                                            //                       e.price!.toStringAsFixed(2) +' '+
                                                            //                           LocaleKeys.kwd.tr():'',
                                                            //                       style: TextStyle(
                                                            //                           height:  size.height*0.0024,
                                                            //                           color:
                                                            //                           Colors.grey,
                                                            //                           fontSize: size.height * 0.017),
                                                            //                     ),
                                                            //                   SizedBox(
                                                            //                     width: size
                                                            //                         .width *
                                                            //                         .02,
                                                            //                   ),
                                                            //                   SizedBox(
                                                            //                     width: 25,
                                                            //                     child: Transform
                                                            //                         .scale(
                                                            //                       scale:
                                                            //                       1.3,
                                                            //                       child:
                                                            //                       Checkbox(
                                                            //                         shape:
                                                            //                         RoundedRectangleBorder(
                                                            //                           borderRadius:
                                                            //                           BorderRadius.circular(5),
                                                            //                         ),
                                                            //                         value:
                                                            //                         e.chosen ?? false,
                                                            //                         activeColor:
                                                            //                         HexColor(endColor!),
                                                            //                         onChanged:
                                                            //                             (newValue) {
                                                            //                           print( detailsState.globalProduct!.addons![i].values!);
                                                            //                           context.read<SingleProductCubit>().switchMultiSelectAddon(
                                                            //                               i,
                                                            //                               detailsState.globalProduct!.addons![i].values!,
                                                            //                               index);
                                                            //                         },
                                                            //                       ),
                                                            //                     ),
                                                            //                   ),
                                                            //                 ],
                                                            //               ),
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       );
                                                            //     }).toList(),
                                                            //   ),
                                                            // ),
                                                          if ( detailsState.globalProduct!.addons![i]
                                                              .multiSelect ==
                                                              0
                                                          // &&
                                                          // detailsState.globalProduct!.attributes![i]
                                                          //     .overridePrice ==
                                                          //     0
                                                          )
                                                             SizedBox(
                                                              height: size.height * .2,
                                                              child: ListView.builder(
                                                                // physics: NeverScrollableScrollPhysics(),
                                                                  scrollDirection: Axis.horizontal,
                                                                  shrinkWrap: true,
                                                                  itemCount:  detailsState.globalProduct!
                                                                      .addons![i]
                                                                      .values!.length,
                                                                  itemBuilder: (context, ind) {
                                                                    return InkWell(
                                                                      onTap: (){
                                                                        context
                                                                            .read<
                                                                            SingleProductCubit>()
                                                                            .switchSingleSelectAddon(
                                                                            i,
                                                                            detailsState.globalProduct!
                                                                                .addons![
                                                                            i]
                                                                                .values!,
                                                                            ind);
                                                                      },
                                                                      child: Container(
                                                                        width: size.width * .27,
                                                                        padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                                                        margin:  EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                                                                        decoration: BoxDecoration(
                                                                          //color: Colors.grey.withOpacity(.2),
                                                                          // border: Border.all(color: AppTheme.secondary,width: 6),

                                                                            borderRadius: BorderRadius.circular(15)
                                                                        ),
                                                                        child: Column(
                                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                                          children: [
                                                                            Stack(
                                                                              children: [
                                                                                Container(
                                                                                    height:  size.height * .08,
                                                                                  width: double.infinity,
                                                                                    padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                                                                                    decoration: BoxDecoration(
                                                                                        color:Colors.grey.withOpacity(.2),
                                                                                        // border: Border.all(color: AppTheme.secondary,width: 6),

                                                                                        borderRadius: BorderRadius.circular(10)
                                                                                    ),
                                                                                    child: Image.network(detailsState.globalProduct!.addons![i].values![ind].image.toString(),height: size.height * .06,)),
                                                                                if((detailsState.globalProduct!.addons![i].values![ind].chosen ?? false) == true)
                                                                                Container(
                                                                                 height:  size.height * .08,
                                                                                    width: double.infinity,
                                                                                    padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                                                                                    decoration: BoxDecoration(
                                                                                   //     color:  (detailsState.globalProduct!.addons![i].values![ind].chosen ?? false) == true?AppTheme.nearlyBlack.withOpacity(.3): Colors.transparent,
                                                                                        gradient: LinearGradient(
                                                                                          colors: [
                                                                                            Colors.black.withOpacity(0.02),
                                                                                            Colors.black.withOpacity(0.5),
                                                                                            Colors.black.withOpacity(0.7),
                                                                                          ],
                                                                                          begin: Alignment.topCenter,
                                                                                          end: Alignment.bottomCenter,
                                                                                        ),
                                                                                        // border: Border.all(color: AppTheme.secondary,width: 6),

                                                                                        borderRadius: BorderRadius.circular(10)
                                                                                    ),
                                                                                  child: Icon(Icons.done,color: Colors.white,),
                                                                                )                                                                    ],
                                                                            ),
                                                                            Text(
                                                                              detailsState.globalProduct!
                                                                                  .addons![i]
                                                                                  .values![ind].title!
                                                                                  .en!,
                                                                              style: TextStyle(
                                                                                  height:  size.height*0.003,
                                                                                  color: Colors.black,
                                                                                  fontSize:
                                                                                  size.height *
                                                                                      0.02,
                                                                                  fontWeight:
                                                                                  FontWeight
                                                                                      .bold),
                                                                            ),
                                                                            Text(
                                                                              detailsState.globalProduct!
                                                                                  .addons![i]
                                                                                  .values![ind].price.toString()+" ${LocaleKeys.kwd.tr()}",
                                                                              style: TextStyle(
                                                                                  color: Colors.grey,
                                                                                  height:  size.height*0.002,
                                                                                  fontSize:
                                                                                  size.height *
                                                                                      0.015,
                                                                                  fontWeight:
                                                                                  FontWeight.bold),
                                                                            ),
                                                                          ],
                                                                        ),

                                                                      ),
                                                                    );
                                                                  }),
                                                            ),

                                                            // Padding(
                                                            //   padding: const EdgeInsets
                                                            //       .symmetric(
                                                            //       horizontal: 10,vertical: 4),
                                                            //   child: Column(
                                                            //     children: detailsState.globalProduct!
                                                            //         .addons![i]
                                                            //         .values!
                                                            //         .map((e) {
                                                            //       int index = detailsState.globalProduct!
                                                            //           .addons![i]
                                                            //           .values!
                                                            //           .indexOf(e);
                                                            //
                                                            //       return Padding(
                                                            //         padding:
                                                            //         const EdgeInsets
                                                            //             .symmetric(
                                                            //             vertical: 7),
                                                            //         child: InkWell(
                                                            //           onTap: () {
                                                            //             context
                                                            //                 .read<
                                                            //                 SingleProductCubit>()
                                                            //                 .switchSingleSelectAddon(
                                                            //                 i,
                                                            //                 detailsState.globalProduct!
                                                            //                     .addons![
                                                            //                 i]
                                                            //                     .values!,
                                                            //                 index);
                                                            //           },
                                                            //           child: Row(
                                                            //             mainAxisAlignment:
                                                            //             MainAxisAlignment
                                                            //                 .spaceBetween,
                                                            //             children: [
                                                            //               Text(
                                                            //                 e.title!
                                                            //                     .en.toString(),
                                                            //                 style: TextStyle(
                                                            //                     height:  size.height*0.0024,
                                                            //                     fontSize:
                                                            //                     size.height *
                                                            //                         0.022),
                                                            //               ),
                                                            //               Row(
                                                            //                 children: [
                                                            //
                                                            //                     Text(
                                                            //                       e.price !=0.0?
                                                            //                       e.price!.toStringAsFixed(2) +' '+
                                                            //                           LocaleKeys.kwd.tr(): '',
                                                            //                       style: TextStyle(
                                                            //                           height:  size.height*0.0024,
                                                            //                           color:
                                                            //                           Colors.grey,
                                                            //                           fontSize: size.height * 0.017),
                                                            //                     ),
                                                            //                   SizedBox(
                                                            //                     width: size
                                                            //                         .width *
                                                            //                         .02,
                                                            //                   ),
                                                            //                   Container(
                                                            //                     width: 25,
                                                            //                     height:
                                                            //                     25,
                                                            //                     decoration: BoxDecoration(
                                                            //                         shape: BoxShape
                                                            //                             .circle,
                                                            //                         color: e.chosen ?? false
                                                            //                             ? HexColor(
                                                            //                             endColor!)
                                                            //                             : Colors
                                                            //                             .white,
                                                            //                         border: Border.all(
                                                            //                             color: e.chosen ?? false ? HexColor(endColor!) : Colors.grey,
                                                            //                             width: 2)),
                                                            //                     child:
                                                            //                     Center(
                                                            //                       child:
                                                            //                       Icon(
                                                            //                         Icons
                                                            //                             .check,
                                                            //                         color:
                                                            //                         Colors.white,
                                                            //                       ),
                                                            //                     ),
                                                            //                   ),
                                                            //                 ],
                                                            //               ),
                                                            //             ],
                                                            //           ),
                                                            //         ),
                                                            //       );
                                                            //     }).toList(),
                                                            //   ),
                                                            // ),
                                                        ],
                                                    ),
                                                     ),
                                                  ),

                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      InkWell(
                                                        onTap: () {
                                                          context
                                                              .read<SingleProductCubit>()
                                                              .countIncrementAdnDecrement(
                                                              '+');
                                                        },
                                                        child: Container(
                                                          height: size.height * 0.06,
                                                          width: size.width * 0.12,
                                                          decoration: BoxDecoration(
                                                              color:AppTheme.secondary,
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  10)),
                                                          child: Center(
                                                            child: Icon(
                                                              FontAwesomeIcons.plus,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.width * 0.07,
                                                      ),
                                                      Container(
                                                        height: size.height * 0.06,
                                                        width: size.width * 0.12,
                                                        decoration: BoxDecoration(
                                                            color: Colors.white,
                                                            borderRadius:
                                                            BorderRadius.circular(10),
                                                            border: Border.all(
                                                                color:
                                                                AppTheme.secondary,)),
                                                        child: Center(
                                                          child: Text(context
                                                              .read<SingleProductCubit>()
                                                              .itemCount
                                                              .toString(),style: TextStyle(fontSize: size.height * 0.025,),),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: size.width * 0.07,
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          context
                                                              .read<SingleProductCubit>()
                                                              .countIncrementAdnDecrement(
                                                              '-');
                                                        },
                                                        child: Container(
                                                          height: size.height * 0.06,
                                                          width: size.width * 0.12,
                                                          decoration: BoxDecoration(
                                                              color: AppTheme.secondary,
                                                              borderRadius:
                                                              BorderRadius.circular(
                                                                  10)),
                                                          child: Center(
                                                            child: Icon(
                                                              FontAwesomeIcons.minus,
                                                              color: Colors.white,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 40,
                                                  ),
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
                                                                            .all(20.0),
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
                                                                              detailsState
                                                                                  .notes,
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
                                                                                detailsState
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
                                                          horizontal: 20),
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
                                                    padding: const EdgeInsets.symmetric(horizontal: 58.0),
                                                    child: Text(
                                                      detailsState.globalProduct!.notes ??
                                                          '',
                                                      style: TextStyle(
                                                          color: Colors.black38,
                                                          height:  size.height*0.003,
                                                          fontSize: size.height * 0.02),
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        Positioned(
                                          //    right: 0,
                                          top: MediaQuery.of(context).size.width - 150,
                                          child: SizedBox(
                                            width: MediaQuery.of(context).size.width,
                                            child: Padding(
                                              padding:
                                              EdgeInsets.only(left: size.width * .04,right: size.width * .04),
                                              child: Hero(
                                                tag:  detailsState.globalProduct!.id.toString(),
                                                child: Transform.translate(
                                                  offset: Offset(10, -40),
                                                  child:  Transform.scale(
                                                    scale: 2.6,
                                                    child: Image.network(
                                                      detailsState.globalProduct!.images == null
                                                          ? ""
                                                          :  detailsState.globalProduct!.images!.image
                                                          .toString(),
                                                      fit: BoxFit.contain,
                                                      height: size.height * .15,
                                                     // width: size.width * .46,

                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                                //    return SizedBox();
                              ),
                          ],
                        )
                      ],
                    ),
                  );
          }),

          // HEADER BUTTON
          BlocBuilder<SingleProductCubit, SingleProductState>(
              builder: (context, state) {
            return AnimatedOpacity(
              opacity: opacityActionButton,
              duration: Duration(milliseconds: 200),
              onEnd: () => onEndAnimationActionButton(),
              child: Visibility(
                visible: isVisibleActionButton,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 40,
                  ),
                  child: Row(
                    children: [
                      CustomIconButton(
                        icon: Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        size: 40,
                        color: Colors.white.withOpacity(.3),
                        borderRadius: 10,
                        tooltip: "Back",
                      ),
                      Spacer(),
                      CustomIconButton(
                        color: Colors.white.withOpacity(.3),
                        icon: Icon(
                          context
                                      .read<SingleProductCubit>()
                                      .globalProduct
                                      ?.inFavourite ==
                                  1
                              ? FontAwesomeIcons.solidHeart
                              : FontAwesomeIcons.heart,
                          color: context
                                      .read<SingleProductCubit>()
                                      .globalProduct
                                      ?.inFavourite ==
                                  1
                              ? AppTheme.yellow
                              : Colors.white,
                        ),
                        onPressed: () {
                          if (LocalStorage.getData(key: "token") != null)
                            context.read<SingleProductCubit>().favToggle(context
                                .read<SingleProductCubit>()
                                .globalProduct!
                                .id!);
                          else
                            push(
                                context,
                                BlocProvider(
                                    create: (BuildContext context) =>
                                        AuthCubit(AuthRepo()),
                                    child: Login()));
                          //   isFavorite.toggle();
                          //     onChanged(isFavorite.value);
                        },
                        size: 42,
                        borderRadius: 10,
                        tooltip: "Favorite",
                      ),
                      //     _ShareButton(onPressed: () {}),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      bottomNavigationBar: BlocBuilder<SingleProductCubit, SingleProductState>(
          builder: (context, state) {
        if (state is AttributesLoaded) {
          final detailsState = context.read<SingleProductCubit>();
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                  color: Colors.white,
                  height: size.height * 0.08,
                  child: Center(
                    child: SizedBox(
                      width: size.width * .72,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: AppTheme.secondary,
                        ),
                        onPressed: () {
                          if (context.read<SingleProductCubit>().price > 0) {
                            context
                                .read<SingleProductCubit>()
                                .addToCard(context);
                          } else {
                            showTopSnackBar(
                                Overlay.of(context),
                                Card(
                                  child: CustomSnackBar.success(
                                    message: LocaleKeys.not_valid.tr(),
                                    backgroundColor: Colors.white,
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.height * 0.027),
                                  ),
                                ));
                          }
                        },
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: size.height * .016),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                LocaleKeys.add_to_cart.tr(),
                                style: TextStyle(
                                    height: size.height * 0.0023,
                                    fontSize: size.height * 0.024,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                context
                                        .read<SingleProductCubit>()
                                        .price
                                        .toStringAsFixed(2) +
                                    ' ' +
                                    LocaleKeys.kwd.tr(),
                                style: TextStyle(
                                  height: size.height * 0.0023,
                                  fontSize: size.height * 0.024,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
              Stack(
                alignment: Alignment.topLeft,
                children: [
                  CustomIconButton(
                    color: AppTheme.orange,
                    icon: Icon(
                      FontAwesomeIcons.shoppingCart,
                      color:
                          //  context.read<SingleProductCubit>().inCart
                          // ? Colors.black
                          //  :
                          Colors.white,
                    ),
                    onPressed: () {
                      push(
                          context,
                          BlocProvider(
                              create: (BuildContext context) =>
                                  CartCubit(CartRepos()),
                              child: CartScreen(
                                fromHome: false,
                              )));
                    },
                    size: size.height * .08,
                    borderRadius: 7,
                  ),
                  Container(
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                        color: Colors.deepOrange, shape: BoxShape.circle),
                    child: Center(
                        child: Text(
                      SingleProductCubit.cartCount.toString(),
                      style: TextStyle(
                          fontSize: 12,
                          height: size.height * 0.002,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    )),
                  ),
                ],
              ),
            ],
          );
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
                color: Colors.white,
                height: size.height * 0.08,
                child: Center(
                  child: SizedBox(
                    width: size.width * .72,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: AppTheme.secondary,
                      ),
                      onPressed: () {
                        // context.read<SingleProductCubit>().addToCard();
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: size.height * .02),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              LocaleKeys.add_to_cart.tr(),
                              style: TextStyle(
                                  height: size.height * 0.0023,
                                  fontSize: size.height * 0.024,
                                  fontWeight: FontWeight.bold),
                            ),
                            // Text(
                            //   'Total:  ' +
                            //       context
                            //           .read<SingleProductCubit>()
                            //           .price
                            //           .toStringAsFixed(0) +
                            //       ' KWD',
                            //   style: TextStyle(
                            //     fontSize: size.height * 0.016,
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
            Stack(
              alignment: Alignment.topLeft,
              children: [
                CustomIconButton(
                  color: AppTheme.orange,
                  icon: Icon(
                    FontAwesomeIcons.shoppingCart,
                    color:
                        //  context.read<SingleProductCubit>().inCart
                        // ? Colors.black
                        //  :
                        Colors.white,
                  ),
                  onPressed: () {
                    push(
                        context,
                        BlocProvider(
                            create: (BuildContext context) =>
                                CartCubit(CartRepos()),
                            child: CartScreen(
                              fromHome: false,
                            )));
                  },
                  size: size.height * .08,
                  borderRadius: 7,
                ),
                Container(
                  height: 16,
                  width: 16,
                  decoration: BoxDecoration(
                      color: Colors.deepOrange, shape: BoxShape.circle),
                  child: Center(
                      child: Text(
                    SingleProductCubit.cartCount.toString(),
                    style: TextStyle(
                        fontSize: 12,
                        height: size.height * 0.002,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  )),
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Future _showDialog(context, String title) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        var we = MediaQuery.of(context).size.width;
        var he = MediaQuery.of(context).size.height;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: he * .02,
                  ),
                  Text(
                    LocaleKeys.sensitive.tr(),
                    style: TextStyle(
                      color: AppTheme.orange,
                      fontSize: we * .045,
                      height: he * .002,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: we * .035,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: he * .02,
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
