
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../bloc/auth_bloc/auth_cubit.dart';
import '../../bloc/cart_bloc/cart_cubit.dart';
import '../../bloc/single_product_bloc/single_product_cubit.dart';
import '../../data/repositories/auth_repo.dart';
import '../../data/repositories/cart.dart';
import '../../local_storage.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/custom_icon_button.dart';
import '../widgets/helper.dart';
import '../widgets/native_clipper.dart';
import 'Auth_screens/login.dart';
import 'cart.dart';

class ProductDetails1 extends StatelessWidget {
  List<int> options = [];
  final ScrollController scrollController = ScrollController();
  var opacityActionButton = 1.0;
  var isVisibleActionButton = true;
  bool isFavorite = false;
  final AnimationController? animationController;

  ProductDetails1(
      {Key? key,
      this.animationController,
      })
      : super(key: key);

  void onEndAnimationActionButton() {
    if (opacityActionButton == 0) {
      isVisibleActionButton = false;
    } else {
      isVisibleActionButton = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        bottomNavigationBar: BlocBuilder<SingleProductCubit, SingleProductState>(
            builder: (context, state) {
              if (state is AttributesLoaded) {
                final detailsState = context.read<SingleProductCubit>();
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          color: Colors.white,
                          height: size.height * 0.07,
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
                                        context,
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
                                child: Container(
                                  height:  size.height * 0.07,
                                  padding: EdgeInsets.symmetric(
                                      vertical: size.height * .0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        LocaleKeys.add_to_cart.tr(),
                                        style: TextStyle(
                                            height: size.height * 0.002,
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
                            color: AppTheme.secondary,
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
                            size: size.height * .07,
                            borderRadius: 7,
                          ),
                          Container(
                            height: 18,
                            width: 18,
                            decoration: BoxDecoration(
                                color: Colors.deepOrange, shape: BoxShape.circle),
                            child: Center(
                                child: Text(
                                  SingleProductCubit.cartCount.toString(),
                                  style: TextStyle(
                                      fontSize: 12,
                                      height: size.height * 0.0025,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                )),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                        color: Colors.white,
                        height: size.height * 0.07,
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
                              child: SizedBox(
                                height:  size.height * 0.07,

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
                          color: AppTheme.secondary,
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
                          size: size.height * .07,
                          borderRadius: 7,
                        ),
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                              color: Colors.deepOrange, shape: BoxShape.circle),
                          child: Center(
                              child: Text(
                                SingleProductCubit.cartCount.toString(),
                                style: TextStyle(
                                    fontSize: 12,
                                    height: size.height * 0.0025,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }),
        body: BlocBuilder<SingleProductCubit, SingleProductState>(
        builder: (context, state) {
      final detailsState = context.read<SingleProductCubit>();
      if (state is AttributesLoading) {
        return Center(
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
        );
      }
      if (state is AttributesLoaded) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Stack(
                    // alignment: Alignment.topCenter,
                    children: [
                      ClipPath(
                        clipper: NativeClipper(),
                        child: Container(
                            padding: EdgeInsets.zero,
                            height: size.height * .65,
                            color: AppTheme.lightSec
                            //Colors.red.withOpacity(.3),
                            ),
                      ),
                      ClipPath(
                        clipper: NativeClipper(),
                        child: Container(
                          padding: EdgeInsets.zero,
                          height: size.height * .57,
                          color: AppTheme.secondary,
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: opacityActionButton,
                        duration: Duration(milliseconds: 200),
                        onEnd: () => onEndAnimationActionButton(),
                        child: Visibility(
                          visible: isVisibleActionButton,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 70,
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
          Text(detailsState.globalProduct!.category!.title!.en.toString().toUpperCase(),
          style: TextStyle(
         // decoration: TextDecoration.underline,
          fontSize: size.width * .055,
          color: AppTheme.white,
        // letterSpacing: 2
          )),
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
                                    if (LocalStorage.getData(key: "token") !=
                                        null)
                                      context
                                          .read<SingleProductCubit>()
                                          .favToggle(context
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
                      ),
                    ],
                  ),
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: size.height * .1),
                      child: Transform.translate(
                        offset: Offset(10, -40),
                        child: Transform.scale(
                          scale: 2.4,
                          child: Hero(
                            tag: detailsState.globalProduct!.id.toString(),
                            child: Image(
                              image: NetworkImage(
                                detailsState.globalProduct!.images == null
                                    ? ""
                                    : detailsState.globalProduct!.images!.image
                                        .toString(),
                              ),
                              height: size.height * .2,
                              width: size.height * .16,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(detailsState.globalProduct!.title!.en.toString(),
                    //    .toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: size.width * .07,
                            color: Colors.black,
                            height: size.width * .0002
                        )),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    //   child: Text('FRUITS',
                    //       style: TextStyle(
                    //           height: size.width * .0002,
                    //           decoration: TextDecoration.underline,
                    //           fontSize: size.width * .06,
                    //           color: AppTheme.secondary,
                    //           letterSpacing: 10)),
                    // ),
                  ],
                ),
              ),
           //   SizedBox(height: size.height * .01,),
           //    Padding(
           //      padding: const EdgeInsets.symmetric(horizontal: 18.0),
           //      child: Text('FRUITS',
           //          style: TextStyle(
           //              decoration: TextDecoration.underline,
           //              fontSize: size.width * .05,
           //              color: AppTheme.secondary,
           //              letterSpacing: 10)),
           //    ),  Padding(
           //      padding: const EdgeInsets.symmetric(horizontal: 18.0),
           //      child: Text('FRUITS',
           //          style: TextStyle(
           //              decoration: TextDecoration.underline,
           //              fontSize: size.width * .05,
           //              color: AppTheme.secondary,
           //              letterSpacing: 10)),
           //    ),
             SizedBox(height: size.height * .03,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  "${detailsState.globalProduct!.unit!.title!.en}",
                  style: TextStyle(
                      fontSize: size.width * .045,
                      height: size.height * .001,
                      color: AppTheme.orange,
                   //   letterSpacing: 5
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.02,
              ),
              if (detailsState.globalProduct!.description?.en != null)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0),
                  child: Text(
                    detailsState.globalProduct!.description!.en.toString(),
                    //    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey,
                      height: size.height * 0.002,
                      fontSize: size.height * 0.025,
                    ),
                  ),
                ),
              if (detailsState.globalProduct!.description?.en != null)
              SizedBox(
                height: size.height * 0.02,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          detailsState.globalProduct!.price == 0
                              ? LocaleKeys.depends_on.tr()
                              :
                              //  "the price depends on your choice":
                              context
                                      .read<SingleProductCubit>()
                                      .price
                                      .toStringAsFixed(2) +
                                  ' ' +
                                  LocaleKeys.kwd.tr(),
                          style: TextStyle(
                              height: size.height * 0.002,
                              color: detailsState.globalProduct!.price == 0
                                  ? AppTheme.yellow
                                  : AppTheme.nearlyBlack,
                              fontSize: detailsState.globalProduct!.price == 0
                                  ? size.height * 0.018
                                  : size.height * .028,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: size.width * 0.03,
                        ),
                        if (double.parse(detailsState.globalProduct!.newPrice
                                    .toString()) !=
                                0.0 ||
                            detailsState.globalProduct!.newPrice != 0)
                          Text(
                            detailsState.globalProduct!.price.toString() +
                                ' ' +
                                LocaleKeys.kwd.tr(),
                            style: TextStyle(
                                decoration: TextDecoration.lineThrough,
                                height: size.height * 0.002,
                                color: AppTheme.orange,
                                fontSize: size.height * 0.02,
                                fontWeight: FontWeight.bold),
                          ),
                      ],
                    ),
                    Container(
                      height: size.height *.06,
                      padding: EdgeInsets.symmetric(horizontal:18),
                      decoration: BoxDecoration(
                          color: AppTheme.secondary,
                          borderRadius: BorderRadius.all(Radius.circular(13))),
                      child: Row(
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
                              // height: size.height * 0.06,
                              // width: size.width * 0.12,
                              // decoration: BoxDecoration(
                              //     color:AppTheme.secondary,
                              //     borderRadius:
                              //     BorderRadius.circular(
                              //         10)),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.plus,
                                  color: Colors.white,
                                  size: size.height * 0.025,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Container(
                            height: size.height * 0.06,
                            width: size.width * 0.12,
                            // decoration: BoxDecoration(
                            //     color: Colors.white,
                            //     borderRadius:
                            //     BorderRadius.circular(10),
                            //     border: Border.all(
                            //       color:
                            //       AppTheme.secondary,)),
                            child: Center(
                              child: Text(context
                                  .read<SingleProductCubit>()
                                  .itemCount
                                  .toString(),style: TextStyle(fontSize: size.height * 0.025,color: Colors.white),),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          InkWell(
                            onTap: () {
                              context
                                  .read<SingleProductCubit>()
                                  .countIncrementAdnDecrement(
                                  '-');
                            },
                            child: Container(
                              // height: size.height * 0.06,
                              // width: size.width * 0.12,
                              // decoration: BoxDecoration(
                              //     color: AppTheme.secondary,
                              //     borderRadius:
                              //     BorderRadius.circular(
                              //         10)),
                              child: Center(
                                child: Icon(
                                  FontAwesomeIcons.minus,
                                  color: Colors.white,
                                  size: size.height * 0.025,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              ListView.builder(
                  physics:
                  NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount:
                  detailsState.globalProduct!.attributes!.length,
                  itemBuilder: (context, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: Column(
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
                                                    AppTheme.secondary,
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
                                                        ? AppTheme.secondary
                                                        : Colors
                                                        .white,
                                                    border: Border.all(
                                                        color: e.chosen ?? false ? AppTheme.secondary : Colors.grey,
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
                padding: EdgeInsets.zero,
                itemCount: detailsState.globalProduct!.addons!.length,
                itemBuilder: (context, i) =>
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),                                             child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: size.height *
                            0.02,),
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
                                          .addonPrices[
                                      i] !=
                                          0)
                                        Text(
                                          "${detailsState.addonPrices[i].toStringAsFixed(2)} ${LocaleKeys.kwd.tr()}",
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

                        //
                        // if ( detailsState.globalProduct!.addons![i]
                        //     .multiSelect ==
                        //     1)

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
                                      if ( detailsState.globalProduct!.addons![i]
                                          .multiSelect ==
                                          0){
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
                                      }else {
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
                                      } },
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
                                                          AppTheme.secondary.withOpacity(0.02),
                                                          AppTheme.secondary.withOpacity(0.5),
                                                          AppTheme.secondary.withOpacity(0.7),
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
                                              overflow: TextOverflow.ellipsis,
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
                        // if ( detailsState.globalProduct!.addons![i]
                        //     .multiSelect ==
                        //     0)
                        //   SizedBox(
                        //     height: size.height * .2,
                        //     child: ListView.builder(
                        //       // physics: NeverScrollableScrollPhysics(),
                        //         scrollDirection: Axis.horizontal,
                        //         shrinkWrap: true,
                        //         itemCount:  detailsState.globalProduct!
                        //             .addons![i]
                        //             .values!.length,
                        //         itemBuilder: (context, ind) {
                        //           return InkWell(
                        //             onTap: (){
                        //               context
                        //                   .read<
                        //                   SingleProductCubit>()
                        //                   .switchSingleSelectAddon(
                        //                   i,
                        //                   detailsState.globalProduct!
                        //                       .addons![
                        //                   i]
                        //                       .values!,
                        //                   ind);
                        //             },
                        //             child: Container(
                        //               width: size.width * .27,
                        //               padding: const EdgeInsets.symmetric(horizontal: 18.0),
                        //               margin:  EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                        //               decoration: BoxDecoration(
                        //                 //color: Colors.grey.withOpacity(.2),
                        //                 // border: Border.all(color: AppTheme.secondary,width: 6),
                        //
                        //                   borderRadius: BorderRadius.circular(15)
                        //               ),
                        //               child: Column(
                        //                 mainAxisAlignment: MainAxisAlignment.center,
                        //                 children: [
                        //                   Stack(
                        //                     children: [
                        //                       Container(
                        //                           height:  size.height * .08,
                        //                           width: double.infinity,
                        //                           padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                        //                           decoration: BoxDecoration(
                        //                               color:Colors.grey.withOpacity(.2),
                        //                               // border: Border.all(color: AppTheme.secondary,width: 6),
                        //
                        //                               borderRadius: BorderRadius.circular(10)
                        //                           ),
                        //                           child: Image.network(detailsState.globalProduct!.addons![i].values![ind].image.toString(),height: size.height * .06,)),
                        //                       if((detailsState.globalProduct!.addons![i].values![ind].chosen ?? false) == true)
                        //                         Container(
                        //                           height:  size.height * .08,
                        //                           width: double.infinity,
                        //                           padding:  EdgeInsets.symmetric(horizontal: 5,vertical: 7),
                        //                           decoration: BoxDecoration(
                        //                             //     color:  (detailsState.globalProduct!.addons![i].values![ind].chosen ?? false) == true?AppTheme.nearlyBlack.withOpacity(.3): Colors.transparent,
                        //                               gradient: LinearGradient(
                        //                                 colors: [
                        //                                   Colors.black.withOpacity(0.02),
                        //                                   Colors.black.withOpacity(0.5),
                        //                                   Colors.black.withOpacity(0.7),
                        //                                 ],
                        //                                 begin: Alignment.topCenter,
                        //                                 end: Alignment.bottomCenter,
                        //                               ),
                        //                               // border: Border.all(color: AppTheme.secondary,width: 6),
                        //
                        //                               borderRadius: BorderRadius.circular(10)
                        //                           ),
                        //                           child: Icon(Icons.done,color: Colors.white,),
                        //                         )                                                                    ],
                        //                   ),
                        //                   Text(
                        //                     detailsState.globalProduct!
                        //                         .addons![i]
                        //                         .values![ind].title!
                        //                         .en!,
                        //                     style: TextStyle(
                        //                         height:  size.height*0.003,
                        //                         color: Colors.black,
                        //                         fontSize:
                        //                         size.height *
                        //                             0.02,
                        //                         fontWeight:
                        //                         FontWeight
                        //                             .bold),
                        //                   ),
                        //                   Text(
                        //                     detailsState.globalProduct!
                        //                         .addons![i]
                        //                         .values![ind].price.toString()+" ${LocaleKeys.kwd.tr()}",
                        //                     style: TextStyle(
                        //                         color: Colors.grey,
                        //                         height:  size.height*0.002,
                        //                         fontSize:
                        //                         size.height *
                        //                             0.015,
                        //                         fontWeight:
                        //                         FontWeight.bold),
                        //                   ),
                        //                 ],
                        //               ),
                        //
                        //             ),
                        //           );
                        //         }),
                        //   ),

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

              // SizedBox(height: size.height * .02,),
              // Center(
              //   child: Container(
              //     width: size.width * .4,
              //     padding: EdgeInsets.symmetric(horizontal:18),
              //     decoration: BoxDecoration(
              //         color: AppTheme.secondary,
              //         borderRadius: BorderRadius.all(Radius.circular(13))),
              //     child: Row(
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
              //             // height: size.height * 0.06,
              //             // width: size.width * 0.12,
              //             // decoration: BoxDecoration(
              //             //     color:AppTheme.secondary,
              //             //     borderRadius:
              //             //     BorderRadius.circular(
              //             //         10)),
              //             child: Center(
              //               child: Icon(
              //                 FontAwesomeIcons.plus,
              //                 color: Colors.white,
              //                 size: size.height * 0.025,
              //               ),
              //             ),
              //           ),
              //         ),
              //         SizedBox(
              //           width: size.width * 0.02,
              //         ),
              //         Container(
              //           height: size.height * 0.06,
              //           width: size.width * 0.12,
              //           // decoration: BoxDecoration(
              //           //     color: Colors.white,
              //           //     borderRadius:
              //           //     BorderRadius.circular(10),
              //           //     border: Border.all(
              //           //       color:
              //           //       AppTheme.secondary,)),
              //           child: Center(
              //             child: Text(context
              //                 .read<SingleProductCubit>()
              //                 .itemCount
              //                 .toString(),style: TextStyle(fontSize: size.height * 0.025,color: Colors.white),),
              //           ),
              //         ),
              //         SizedBox(
              //           width: size.width * 0.02,
              //         ),
              //         InkWell(
              //           onTap: () {
              //             context
              //                 .read<SingleProductCubit>()
              //                 .countIncrementAdnDecrement(
              //                 '-');
              //           },
              //           child: Container(
              //             // height: size.height * 0.06,
              //             // width: size.width * 0.12,
              //             // decoration: BoxDecoration(
              //             //     color: AppTheme.secondary,
              //             //     borderRadius:
              //             //     BorderRadius.circular(
              //             //         10)),
              //             child: Center(
              //               child: Icon(
              //                 FontAwesomeIcons.minus,
              //                 color: Colors.white,
              //                 size: size.height * 0.025,
              //               ),
              //             ),
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
              // SizedBox(height: size.height * .02,),
            ],
          ),
        );
      }
      return SizedBox();
    }));

  }
}



