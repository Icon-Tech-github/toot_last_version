import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/order_details_bloc/order_details_cubit.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../data/models/orders_model.dart';
import '../../local_storage.dart';

class OrderDetailsScreen extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    List<int> list =[];
    List<int> list2 =[];

    var size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppTheme.background,
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
          child: SingleChildScrollView(
            child:  Column(
              children: [
                BlocBuilder<OrderDetailsCubit, OrderDetailsState>(
                    builder: (context, state) {

                      if (state is OrderDetailsLoading) {
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

                      if(state is OrderDetailsLoaded){
                        Orders order = state.order;
                        return Column(
                          children: [
                            SizedBox(
                              height: size.height * .01,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                              //    mainAxisAlignment: MainAxisAlignment.start,
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
                                    order.uuid!,
                                    style: TextStyle(fontSize: size.width *.07, fontWeight: FontWeight.bold,color:  AppTheme.white,),
                                  ),
                                  // SizedBox(width: 60,),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * .01,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Icon(Icons.watch_later_outlined,color: AppTheme.secondary,size: 35,),
                                  SizedBox(width: 10,),
                                  Text(
                                    order.orderStatus!.title!.en!,
                                    style: TextStyle(fontSize: 16,color:  AppTheme.white,),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * .01,),

                            SizedBox(
                              width: size.width *.9,
                              //  height: 500,
                              child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:order.details!.length,
                                  itemBuilder: (ctx, index) {
                                    Product product = order.details![index].product!;
                                    return Container(
                                      margin: EdgeInsets.only(bottom: 10),
                                      // width: 130,
                                      //height: price != null ? 200: 130,
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
                                        padding:  EdgeInsets.only(
                                            top: 6, left: 16, right: 16, bottom: 8),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.start,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Expanded(
                                                  flex:2,
                                                  child: ClipRRect(
                                                    //  margin: EdgeInsets.only(left: 20,),

                                                    // decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(7),
                                                    child: SimpleShadow(
                                                        opacity: 0.3, // Default: 0.5
                                                        color: Colors.black, // Default: Black
                                                        offset: Offset(1, 3), // Default: Offset(2, 2)
                                                        sigma: 5, // Defaul
                                                        child: Image.network(product.images!.image!)),
                                                    // ),
                                                    // child: FadeInImage.assetNetwork(
                                                    //   width: 90,
                                                    //   height: 80,
                                                    //   placeholder: 'assets/images/loadd.gif',
                                                    //   image: ,
                                                    //   fit: BoxFit.fill,
                                                    // ),
                                                  ),
                                                ),
                                                SizedBox(width: 20,),
                                                Expanded(
                                                  flex: 4,
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        width:size.width *.4,
                                                        child: Text(product.title!.en!,  overflow: TextOverflow.ellipsis, maxLines: 1,
                                                          softWrap: false,style: TextStyle( fontSize: size.width * .04,fontWeight: FontWeight.bold,height: size.height * .003),),
                                                      ),
                                                     // SizedBox(height: 5,),
                                                      Text('${LocaleKeys.quantity.tr()} / ${order.details![0].quantity}',style: TextStyle( fontSize:  size.width * .035,height: size.height * .002),),
                                                      SizedBox(height: size.height * .005,),

                                                      Column(
crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: order.details![index].attributes!.map((e) {
                                                          list.add(e.attribute!.id!);
                                                          var count = list.where((c) => c == e.attribute!.id).toList().length;
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,

                                                            children: [
                                                              if(count<=1)
                                                              Text(e.attribute!.title!.en! +' : ' ,style: TextStyle( fontSize: size.width * .037,height: size.height * .002,),),

                                                              if(count<=1)
                                                              for(int i =0; i<  order.details![index].attributes!.length ; i++)
                                                                if(order.details![index].attributes![i].attribute!.id == e.attribute!.id)
                                                              Text(order.details![index].attributes![i].attributeValue!.attributeValue!.en.toString()  ,style: TextStyle( fontSize:   size.width * .035,height: size.height * .002,color: Colors.grey),)

                                                            ],
                                                          );

                                                          list.add(e.attribute!.id!);
                                                        }

                                                        ).toList(),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: order.details![index].addons!.map((e) {
                                                          list.add(e.addon!.id!);
                                                          var count = list.where((c) => c == e.addon!.id).toList().length;
                                                          return Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,

                                                            children: [
                                                              if(count<=1)
                                                                Text(e.addon!.title!.en! +' : ' ,style: TextStyle( fontSize: size.width * .037,height: size.height * .002,),),

                                                              if(count<=1)
                                                                for(int i =0; i<  order.details![index].addons!.length ; i++)
                                                                  if(order.details![index].addons![i].addon!.id == e.addon!.id)
                                                                    Text(order.details![index].addons![i].addonValue!.title!.en.toString()  ,style: TextStyle( fontSize:   size.width * .035,height: size.height * .002,color: Colors.grey),)

                                                            ],
                                                          );

                                                        }

                                                        ).toList(),
                                                      ),

                                                      // Row(
                                                      //   // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                      //   children: [
                                                      //     Text(LocaleKeys.price.tr() ,style: TextStyle( fontSize: 13,color: Colors.black),),
                                                      //     SizedBox(width: size.width * .03,),
                                                      //     Text(product.newPrice.toString() + ' KWD',
                                                      //       style: TextStyle( fontSize: 13,fontWeight: FontWeight.bold,color: AppTheme.orange),)
                                                      //   ],
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
                                  }
                              ),
                            ),
                            SizedBox(
                              height: size.height * .01,
                            ),
                            Align(
                              alignment: Alignment.bottomCenter,

                              child: Container(
                                alignment: Alignment.bottomCenter,

                                padding: EdgeInsets.symmetric(horizontal: size.width *.05),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: size.height * .02,
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.receipt,size: size.width * .07,),
                                        SizedBox(
                                          width: size.width * .02,
                                        ),
                                        Text(LocaleKeys.total_items_price.tr(),
                                          style: TextStyle(fontSize:  size.width * .05,fontWeight: FontWeight.bold,),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * .02,
                                    ),

                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text( LocaleKeys.total_price.tr(),
                                          style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                                          child: Text(order.subtotal!.toStringAsFixed(2)+ ' ${LocaleKeys.kwd.tr()}', style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,)),
                                        ),

                                      ],
                                    ),
                                    SizedBox(
                                      height: size.height * .01,
                                    ),
                                    if(order.deliveryFee !=0)
                                      Row(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment: CrossAxisAlignment.end,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text( LocaleKeys.delivery.tr(),
                                            style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,),
                                            textAlign: TextAlign.center,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                                            child: Text(order.deliveryFee!.toStringAsFixed(2)+ ' ${LocaleKeys.kwd.tr()}', style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,)),
                                          ),

                                        ],
                                      ),
                                    if(order.deliveryFee !=0)
                                    SizedBox(
                                      height: size.height * .01,
                                    ),
                                    if(order.discount !=0)
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Text( LocaleKeys.discount.tr(),
                                          style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                                          child: Text("-"+order.discount!.toStringAsFixed(2)+ ' ${LocaleKeys.kwd.tr()}', style:  TextStyle(fontSize:  size.width * .04, color: Colors.green,height: size.height * .0015,)),
                                        ),

                                      ],
                                    ),
                                    if(order.discount !=0)
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
                                        Text( LocaleKeys.tax_expense.tr(),
                                          style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                                          child: Text(order.tax!.toStringAsFixed(2)+ ' ${LocaleKeys.kwd.tr()}', style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,)),
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
                                        Text( LocaleKeys.total_order.tr(),
                                          style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2),
                                          child: Text(order.total!.toStringAsFixed(2)+ ' ${LocaleKeys.kwd.tr()}', style:  TextStyle(fontSize:  size.width * .04, color: Colors.black,height: size.height * .0015,fontWeight: FontWeight.bold)),
                                        ),

                                      ],
                                    ),

                                    SizedBox(
                                      height: size.height * .03,
                                    ),
                                    // SizedBox(
                                    //   height: size.height * .12,
                                    // ),
                                  ],
                                ),
                              ),
                            ),


                          ],
                        );
                      }
                      return SizedBox();
                    }
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
