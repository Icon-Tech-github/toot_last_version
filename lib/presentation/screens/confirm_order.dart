import 'package:easy_localization/src/public_ext.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/confirm_order_bloc/confirm_order_cubit.dart';
import 'package:loz/data/repositories/confirm_order_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:xml/xml.dart';

import '../../payment_vars/constants_payment.dart';

class ConfirmOrderScreen extends StatelessWidget {
  final double? delivery_fee;
  final double? discount;
  final bool? freeToday ;
  final String ?deliveryTime;
  final String ?deliveryDate;

  ConfirmOrderScreen({Key? key, this.delivery_fee, this.discount,this.freeToday = false,this.deliveryTime,this.deliveryDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
     //  backgroundColor: AppTheme.background,
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
              child: BlocProvider<ConfirmOrderCubit>(
                  create: (BuildContext context) =>
                      ConfirmOrderCubit(ConfirmRepo()),
                  child: CartList(
                    delivery_fee: delivery_fee,
                    discount: discount,
                    freeToday: freeToday,
                  ))),
        ));
  }
}

class CartList extends StatelessWidget {
  CartList({Key? key, this.delivery_fee,this.discount,this.freeToday}) : super(key: key);
  final double? discount;
  //final AnimationController? animationController;
  bool checkedValue = false;
  bool apply = false;
  final double? delivery_fee;
  final bool? freeToday ;
  TextEditingController code = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return BlocConsumer<ConfirmOrderCubit, ConfirmOrderState>(
        listener: (context, state) {
          if (state is AddCouponFailure) {
            showTopSnackBar(
                context,
                Card(
                  child: CustomSnackBar.success(
                    message: state.error,
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(
                        color: Colors.black, fontSize: size.height * 0.03),
                  ),
                ));
          } else if (state is UseBalanceFailure) {
            showTopSnackBar(
                context,
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
                context,
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
                context,
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
      if (state is ConfirmLoading) {
        LoadingScreen.show(context);
        //    pushReplacement(context, OrderSuccess(orderNum:"" ));

      }
    }, builder: (context, state) {
      // if (state is ConfirmOrderLoaded) {
      ConfirmOrderCubit confirmOrderState = context.read<ConfirmOrderCubit>();
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
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                    child: IconButton(
                      icon: const Icon(
                        Icons.arrow_back_ios,
                        size: 28,
                        color: AppTheme.white,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Text(
                    LocaleKeys.confirm.tr(),
                    style: TextStyle(
                      fontSize: 22,
                      color: AppTheme.white,
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
            SizedBox(
              width: size.width * .9,
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: confirmOrderState.products.length,
                  itemBuilder: (ctx, index) {
                    return Container(
                   //   height: size.height * .18,
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
                        padding: const EdgeInsets.only(
                            top: 0, left: 0, right: 0, bottom: 0),
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
                                  //       height: size.height * .17,
                                  //       width: size.width * .35,
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
                                  //       height: size.height * .17,
                                  //       width: size.width * .28,
                                  //       decoration: BoxDecoration(
                                  //         color: AppTheme.secondary,
                                  //         shape: BoxShape.rectangle,
                                  //         borderRadius: BorderRadius.horizontal(
                                  //           left: Radius.circular(20.0),
                                  //           right: Radius.circular(40.0),
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
                                  //     Positioned(
                                  //       bottom: 6,
                                  //       child: Padding(
                                  //         padding: const EdgeInsets.symmetric(horizontal: 0.0),
                                  //         child: Image.network(confirmOrderState
                                  //             .products[index].images!.image
                                  //             .toString(),height: size.height * .16,),
                                  //       ),
                                  //     ),
                                  //
                                  //   ],
                                  // ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7),
                                      child: SimpleShadow(
                                        opacity: 0.3, // Default: 0.5
                                        color: Colors.black, // Default: Black
                                        offset: Offset(1, 3), // Default: Offset(2, 2)
                                        sigma: 5, // Defaul
                                        child: Image.network(confirmOrderState
                                            .products[index].images!.image
                                            .toString()),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        confirmOrderState
                                            .products[index].title!.en!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        softWrap: false,
                                        style: TextStyle(
                                            fontSize: size.height * 0.02,
                                            height: size.height * 0.003,
                                            fontWeight: FontWeight.bold),
                                      ),

                                      Row(
                                        children: [
                                          Text(
                                            "${LocaleKeys.quantity.tr()} | ",
                                            style: TextStyle(
                                                fontSize: size.height * 0.016,
                                                height: size.height * .002),
                                          ),
                                          Text(
                                            confirmOrderState
                                                .products[index].count
                                                .toString(),
                                            style: TextStyle(
                                                fontSize: size.height * 0.016,
                                                color: Colors.grey,
                                                height: size.height * .002),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        height: size.height * .01,
                                      ),
                                      Text(
                                        "${confirmOrderState.products[index].total!.toStringAsFixed(2)} ${LocaleKeys.kwd.tr()}",
                                        style: TextStyle(
                                            fontSize: size.height * 0.018,
                                            height: size.height * .002,
                                            fontWeight: FontWeight.bold,
                                            color: AppTheme.orange),
                                      ),

                                      // SizedBox(
                                      //   height: size.height * .005,
                                      // ),
                                    ],
                                  ),
                                ),
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
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)
                    )),
                padding: EdgeInsets.symmetric(horizontal: size.width * .05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30,),
                    if (context.read<ConfirmOrderCubit>().discount == 0.0 &&
                        LocalStorage.getData(key: "token") != null)
                      Container(
                        padding: EdgeInsets.only(
                            left: size.width * .04,
                            right: size.width * .04,
                            top: size.width * .02),
                        decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(7),
                          color: AppTheme.secondary.withOpacity(.1),
                        ),
                        child: ExpandablePanel(
                          theme: const ExpandableThemeData(
                            headerAlignment:
                            ExpandablePanelHeaderAlignment.center,
                            tapBodyToCollapse: true,
                          ),
                          header: Text(
                            LocaleKeys.need_discount.tr(),
                            //  textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: size.height * 0.022,
                                fontWeight: FontWeight.bold),
                          ),
                          collapsed: Container(),
                          expanded: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                //  height: 100,
                                  padding: EdgeInsets.only(bottom: 10),
                                  child: Column(
                                    //  crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [

                                      Row(
                                        children: [
                                          Switch(
                                            value: context.read<ConfirmOrderCubit>().checkedValue,
                                            activeColor: AppTheme.secondary,
                                            onChanged: (newValue) {
                                              // setState(() {
                                              //   context.read<ConfirmOrderCubit>().checkedValue = newValue;
                                              // });
                                              BlocProvider.of<ConfirmOrderCubit>(context).switchCoupon();
                                            },

                                          ),
                                          SizedBox(width: 10,),
                                          GestureDetector(
                                              onTap: () {
                                                // setState(() {
                                                //   checkedValue = !checkedValue;
                                                // });
                                                BlocProvider.of<ConfirmOrderCubit>(context).switchCoupon();
                                              },
                                              child: Text(
                                                LocaleKeys.you_have_promo_code
                                                    .tr(),
                                                style: TextStyle(
                                                    fontSize: size.height * 0.023,
                                                    color: AppTheme.secondary),
                                              ))
                                        ],
                                      ),



                                      // CheckboxListTile(
                                      //   contentPadding: EdgeInsets.zero,
                                      //   title: GestureDetector(
                                      //       onTap: () {
                                      //         setState(() {
                                      //           checkedValue = !checkedValue;
                                      //         });
                                      //       },
                                      //       child: Text(
                                      //         LocaleKeys.you_have_promo_code
                                      //             .tr(),
                                      //         style: TextStyle(
                                      //             fontSize: size.height * 0.023,
                                      //             color: AppTheme.secondary),
                                      //       )),
                                      //   value: checkedValue,
                                      //   onChanged: (newValue) {
                                      //     setState(() {
                                      //       checkedValue = newValue!;
                                      //     });
                                      //   },
                                      //   controlAffinity: ListTileControlAffinity
                                      //       .leading, //  <-- leading Checkbox
                                      // ),
                                      if (context.read<ConfirmOrderCubit>().discount == 0.0 &&
                                          LocalStorage.getData(key: "token") !=
                                              null)
                                        Visibility(
                                          visible: context.read<ConfirmOrderCubit>().checkedValue,
                                          child: Container(
                                            height: size.height*0.08,
                                            child: TextFormField(
                                              controller: code,
                                              style: TextStyle(
                                                  fontSize: size.height * 0.02,height:  size.height * 0.001),
                                              cursorColor: AppTheme.orange,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                suffixIcon: !context.read<ConfirmOrderCubit>().apply
                                                    ? Text('')
                                                    : GestureDetector(
                                                  onTap: () {},
                                                  child: InkWell(
                                                    onTap: () {
                                                      FocusScope.of(
                                                          context)
                                                          .unfocus();
                                                      BlocProvider.of<ConfirmOrderCubit>(context)
                                                          .addCoupon(code.text);
                                                    },
                                                    child: Container(
                                                      width: 70,
                                                      height: size.height*0.08,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.secondary,
                                                        borderRadius: BorderRadius.only(
                                                          topLeft: Radius.circular(LocalStorage.getData(key: "lang") == "en"?0: 10),
                                                          bottomLeft: Radius.circular(LocalStorage.getData(key: "lang") == "en"?0: 10),
                                                          topRight: Radius.circular(LocalStorage.getData(key: "lang") == "en"?10: 0),
                                                          bottomRight: Radius.circular(LocalStorage.getData(key: "lang") == "en"?10: 0),
                                                        )
                                                      ),
                                                      child: state is AddCouponLoading?
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: CircularProgressIndicator(color: Colors.white,strokeWidth: 3,),
                                                      ):
                                                      Center(
                                                        child: Text(
                                                          LocaleKeys.apply.tr(),
                                                          style: TextStyle(
                                                              height: size.height * .002,
                                                              color: Colors.white ,
                                                              fontSize:
                                                              size.height *
                                                                  0.022),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                hintText: LocaleKeys
                                                    .enter_discount_code
                                                    .tr(),
                                                hintStyle: TextStyle(
                                                    height: size.height * .002,
                                                    fontSize: size.height * 0.022),
                                                border: OutlineInputBorder(
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius.circular(8)),
                                                    borderSide: BorderSide(
                                                        width: 1,
                                                        color: AppTheme.orange)),
                                                focusedBorder: OutlineInputBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.circular(15)),
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.grey),
                                                ),
                                              ),
                                              onChanged: (value) {
                                                // setState(() {
                                                //   if (value != "")
                                                //     apply = true;
                                                //   else
                                                //     apply = false;
                                                // });

                                                  if (value != "")
                                                    BlocProvider.of<ConfirmOrderCubit>(context)
                                                        .showApply(true);

                                                  else
                                                    BlocProvider.of<ConfirmOrderCubit>(context)
                                                        .showApply(false);
                                              },
                                              validator: (value) {
                                                if (value!.isEmpty)
                                                  return LocaleKeys.Required.tr();
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                      SizedBox(
                                        height: size.height * .03,
                                      ),
                                      InkWell(
                                        onTap: (){
                                          BlocProvider.of<ConfirmOrderCubit>(context).useBalance();
                                        },
                                        child: Container(
                                          height: size.height * .065,

                                          width: size.width * .7,
                                          decoration: BoxDecoration(
                                              color: AppTheme.secondary,
                                              borderRadius: BorderRadius.circular(15)
                                            //     bottomRight: Radius.circular(7),
                                            //     bottomLeft: Radius.circular(7)),
                                          ),
                                          child:  Center(
                                            child: Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                children: [
                                                  state is UseBalanceLoading?
                                                  CircularProgressIndicator(color: Colors.white,strokeWidth: 2,):
                                                  Image.asset(
                                                    "assets/images/surprise.png",
                                                    height: size.width * .08,
                                                    color: Colors.white,
                                                  ),

                                                  Text(
                                                    LocaleKeys.use_my_balance.tr(),

                                                    //  textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      height: size.height * .003,
                                                      color: Colors.white,
                                                      fontSize: size.height * 0.025,
                                                      // fontWeight: FontWeight.bold
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Row(
                                      //   children: [
                                      //     Image.asset(
                                      //       "assets/images/gift.png",
                                      //       height: size.width * .1,
                                      //     ),
                                      //     SizedBox(
                                      //       width: size.width * .06,
                                      //     ),
                                      //     DefaultButton(
                                      //       isLoad: state is UseBalanceLoading
                                      //           ? true
                                      //           : false,
                                      //       textColor: Colors.white,
                                      //       color: AppTheme.orange,
                                      //       title:
                                      //           LocaleKeys.use_my_balance.tr(),
                                      //       radius: 20,
                                      //       function: () {
                                      //         cartState.useBalance();
                                      //       },
                                      //       font: 13,
                                      //       width: size.width * .5,
                                      //       height: size.height * .056,
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ))
                            ],
                          ),
                          builder: (_, collapsed, expanded) {
                            return Padding(
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: Expandable(
                                collapsed: collapsed,
                                expanded: expanded,
                                theme: const ExpandableThemeData(
                                    crossFadePoint: 0),
                              ),
                            );
                          },
                        ),
                      ),
                    SizedBox(
                      height: size.height * .02,
                    ),
                    Row(
                      children: [
                        Icon(Icons.receipt,size: size.width * .07,),
                        SizedBox(
                          width: size.width * .02,
                        ),
                        Text(
                          LocaleKeys.total_items_price.tr(),
                          style: TextStyle(
                              fontSize: size.height * 0.025,
                              fontWeight: FontWeight.bold),
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
                          LocaleKeys.total_items.tr(),
                          style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                              '${context.read<ConfirmOrderCubit>().products.length} ',
                            style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          ),
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
                          style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),
                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                            '${context.read<ConfirmOrderCubit>().calculatePrices().toStringAsFixed(2)} ${LocaleKeys.kwd.tr()} ',
                            style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    if (confirmOrderState.discount != 0)
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
                                '-${confirmOrderState.calculateDiscount()} ${LocaleKeys.kwd.tr()}',
                              style: TextStyle(fontSize: size.height * 0.023, color: Colors.red, height: size.height * .0015,),

                            ),
                          ),
                        ],
                      ),
                    if (confirmOrderState.discount != 0)
                      SizedBox(
                        height: size.height * .01,
                      ),
                    if (delivery_fee != 0 || freeToday == true)
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            LocaleKeys.delivery.tr(),
                            style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 6.0, vertical: 2),
                            child: Text(
      LocalStorage.getData(key: "deliveryTime") == null?
      '${delivery_fee! +  double.parse(LocalStorage.getData(key: "fast_delivery").toString())} ${LocaleKeys.kwd.tr()}':
                              '${delivery_fee!.toStringAsFixed(2)} ${LocaleKeys.kwd.tr()}',
                              style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                            ),
                          ),
                        ],
                      ),
                    if (delivery_fee != 0 || freeToday == true)
                      SizedBox(
                        height: size.height * .01,
                      ),

                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          LocaleKeys.order_method.tr(),
                          style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          textAlign: TextAlign.center,
                        ),
                        Container(
                          //      width: size.width * .3,
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                              LocalStorage.getData(key: "order_method_name"),
                              overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: size.height * 0.02, color: Colors.black, height: size.height * .0015,),

                          ),
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
                          LocaleKeys.payment_method.tr(),
                          style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                              LocalStorage.getData(key: "payment_method_name"),
                            style: TextStyle(fontSize: size.height * 0.02, color: Colors.black, height: size.height * .0015,),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),
                    if(LocalStorage.getData(key: "deliveryTime") != null)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          LocaleKeys.date.tr(),
                          style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                            "${LocalStorage.getData(key: "deliveryDate").toString()}",
                            style: TextStyle(fontSize: size.height * 0.02, color: Colors.black, height: size.height * .0015,),

                          ),
                        ),
                      ],
                    ),
                    if(LocalStorage.getData(key: "deliveryTime") != null)
                    SizedBox(
                      height: size.height * .01,
                    ),
                    if(LocalStorage.getData(key: "deliveryTime") != null)
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
      LocaleKeys.time.tr(),
                          style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                            "${LocalStorage.getData(key: "deliveryTime")}",
                            style: TextStyle(fontSize: size.height * 0.02, color: Colors.black, height: size.height * .0015,),

                          ),
                        ),
                      ],
                    ),
                    if(LocalStorage.getData(key: "deliveryTime") != null)
                    SizedBox(
                      height: size.height * .01,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Divider(),
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
                          LocaleKeys.tax_expense.tr(),
                          style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                            '${context.read<ConfirmOrderCubit>().calculateTax().toStringAsFixed(2)} ${LocaleKeys.kwd.tr()} ',
                            style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,),

                          ),
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
                          LocaleKeys.total_amount.tr(),
                          style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,fontWeight: FontWeight.bold),

                          textAlign: TextAlign.center,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 6.0, vertical: 2),
                          child: Text(
                            confirmOrderState.calculateTotal().toStringAsFixed(2)+" "+LocaleKeys.kwd.tr(),
                          //  delivery_fee !=0 ?
                            // '${((context.read<ConfirmOrderCubit>().calculateTotal(delivery_fee!) + delivery_fee!)- confirmOrderState.discountRest) > 0 ?((context.read<ConfirmOrderCubit>().calculateTotal() + delivery_fee!)- confirmOrderState.discountRest).toStringAsFixed(2) : 0.000}  ${LocaleKeys.kwd.tr()}':
                            // '${((context.read<ConfirmOrderCubit>().calculateTotal() + delivery_fee!)).toStringAsFixed(2)}  ${LocaleKeys.kwd.tr()}',
                            style: TextStyle(fontSize: size.height * 0.023, color: Colors.black, height: size.height * .0015,fontWeight: FontWeight.bold),

                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: size.height * .01,
                    ),

                    SizedBox(
                      height: size.height * .04,
                    ),
                    Center(
                      child: DefaultButton(
                        textColor: Colors.white,
                        color: AppTheme.secondary,
                        title: LocaleKeys.send_order.tr(),
                        radius: 15,
                        function: () {


                          if(LocalStorage.getData(key: "payment_method_id")==2 && confirmOrderState.calculateTotal() !=0 ) {
                            final builder = XmlBuilder();
                            builder.processing('xml', 'version="1.0"');
                            builder.element('mobile', nest: () {
                              builder.element('store', nest: () {
                                builder.text(GlobalUtils.storeId);
                              });
                              builder.element('key', nest: () {
                                builder.text(GlobalUtils.key);
                              });

                              builder.element('device', nest: () {
                                builder.element('type', nest: () {
                                  builder.text(GlobalUtils.devicetype);
                                });
                                builder.element('id', nest: () {
                                  builder.text(context
                                      .read<ConfirmOrderCubit>()
                                      .deviceId
                                      .toString());
                                });
                              });

                              // app
                              builder.element('app', nest: () {
                                builder.element('name', nest: () {
                                  builder.text(GlobalUtils.appname);
                                });
                                builder.element('version', nest: () {
                                  builder.text(GlobalUtils.version);
                                });
                                builder.element('user', nest: () {
                                  builder
                                      .text(LocalStorage.getData(key: "token"));
                                });
                                builder.element('id', nest: () {
                                  builder.text(GlobalUtils.appid);
                                });
                              });

                              //tran
                              builder.element('tran', nest: () {
                                builder.element('test', nest: () {
                                  builder.text(GlobalUtils.testmode);
                                });
                                builder.element('type', nest: () {
                                  builder.text(GlobalUtils.transtype);
                                });
                                builder.element('class', nest: () {
                                  builder.text(GlobalUtils.transclass);
                                });
                                builder.element('cartid', nest: () {
                                  builder.text(
                                      "${DateTime.now().millisecondsSinceEpoch}");
                                });

                                builder.element('description', nest: () {
                                  builder.text('Test for Mobile API order');
                                });
                                builder.element('currency', nest: () {
                                  builder.text('SAR');
                                });
                                builder.element('amount', nest: () {
                                  builder.text(confirmOrderState.calculateTotal().toStringAsFixed(2));
                                });
                                builder.element('language', nest: () {
                                  builder.text("en");
                                });
                                builder.element('firstref', nest: () {
                                  builder.text(GlobalUtils.firstref);
                                });
                                builder.element('ref', nest: () {
                                  builder.text('null');
                                });
                              });

                              //billing
                              builder.element('billing', nest: () {
                                // name
                                builder.element('name', nest: () {
                                  builder.element('title', nest: () {
                                    builder.text('');
                                  });
                                  builder.element('first', nest: () {
                                    builder.text(LocalStorage.getData(key: "userName"));
                                  });
                                  builder.element('last', nest: () {
                                    builder.text(GlobalUtils.lastname);
                                  });
                                });

                                // address
                                builder.element('address', nest: () {
                                  builder.element('line1', nest: () {
                                    builder.text(GlobalUtils.addressline1);
                                  });
                                  builder.element('city', nest: () {
                                    builder.text(GlobalUtils.city);
                                  });
                                  builder.element('region', nest: () {
                                    builder.text(GlobalUtils.region);
                                  });
                                  builder.element('country', nest: () {
                                    builder.text(GlobalUtils.country);
                                  });
                                });

                                builder.element('phone', nest: () {
                                  builder.text(LocalStorage.getData(key: "phone"));
                                });
                                builder.element('email', nest: () {
                                  builder.text(GlobalUtils.emailId);
                                });
                              });
                              //custref savedcard
                              builder.element('custref', nest: () {
                                builder.text(GlobalUtils.custref);
                              });
                            });

                            final bookshelfXml = builder.buildDocument();

                            print(bookshelfXml);
                            context
                                .read<ConfirmOrderCubit>()
                                .pay(bookshelfXml, context);
                          }
                          //  print(cardToken);
                          //  link = dataOrder['link'];
                          //   Navigator.pushReplacement(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) =>
                          //             PaymentView(
                          //               home: widget.home??false,
                          //               link: link,
                          //               allMyCardProducts: allMyCardProducts,
                          //               code: code,
                          //             )),);






                          // String total =  delivery_fee !=0 ?
                          // '${((context.read<ConfirmOrderCubit>().calculateTotal() + delivery_fee!)- confirmOrderState.discountRest) > 0 ?((context.read<ConfirmOrderCubit>().calculateTotal() + delivery_fee!)- confirmOrderState.discountRest).toStringAsFixed(2) : 0.000}':
                          // '${((context.read<ConfirmOrderCubit>().calculateTotal() + delivery_fee!)).toStringAsFixed(2)} ';
                          // print(total);
                          // if(LocalStorage.getData(key: "order_method_id") == 3 &&   LocalStorage.getData(key: "minTotalOrder") !=0){
                          //   if(LocalStorage.getData(key: "minTotalOrder") > double.parse(total) ){
                          //     showTopSnackBar(
                          //         context,
                          //         Card(
                          //           child: CustomSnackBar.success(
                          //             message:"${LocaleKeys.min_delivery.tr()}${LocalStorage.getData(key: "minTotalOrder")} ${LocaleKeys.kwd.tr()}",
                          //             backgroundColor: Colors.white,
                          //             textStyle: TextStyle(
                          //                 color: Colors.black,
                          //                 fontSize: size.height * 0.02),
                          //           ),
                          //         ));
                          //   }else{
                          //     context
                          //         .read<ConfirmOrderCubit>()
                          //         .confirmOrder(context);
                          //   }
                          // }else{

                          else


                            context
                                .read<ConfirmOrderCubit>()
                                .confirmOrder(context);
                          // context
                          //     .read<ConfirmOrderCubit>()
                          //     .confirmOrder(context);
                        },
                        font: 18,
                      ),
                    ),
                    SizedBox(
                      height: size.height * .04,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
      // }
      //  return SizedBox();
    });
  }
}
