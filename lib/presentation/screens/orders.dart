import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart'as lottie;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:loz/bloc/order_details_bloc/order_details_cubit.dart';
import 'package:loz/bloc/orders_bloc/orders_bloc_cubit.dart';
import 'package:loz/bloc/status_bloc/status_cubit.dart';
import 'package:loz/data/repositories/Order_details_repo.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/data/repositories/tracking_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/screens/order_details.dart';
import 'package:loz/presentation/screens/track_order.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../data/models/orders_model.dart';
import 'Auth_screens/login.dart';
import 'order_tracking.dart';

class OrderScreen extends StatelessWidget {
   OrderScreen({Key? key}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
     // backgroundColor: AppTheme.background,
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
        child: SafeArea(
          child:  OfflineBuilder(
          connectivityBuilder: (BuildContext context,
          ConnectivityResult connectivity, Widget child) {
        final bool connected = connectivity != ConnectivityResult.none;
        return connected
            ?
          BlocBuilder<OrdersBlocCubit, OrdersBlocState>(
              builder: (context, state) {
                if (state is OrdersLoading && state.isFirstFetch) {
                  return Center(
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(height: size.height *.02,),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 5, horizontal: 9),
                                  child: Text(
                                    LocaleKeys.my_orders.tr(),
                                    style: TextStyle(
                                      fontSize: size.width * .07,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white
                                    ),
                                  ),
                                ),
                                // SizedBox(width: 60,),
                              ],
                            ),
                          ),
                          Container(
                            height: size.height * 0.4,
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
                        ],
                      ),
                    ),
                  );
                }
                List<Orders> orders = [];
                bool isLoading = false;
                if (state is OrdersLoading) {
                  orders = state.OldOrders;
                  isLoading = true;
                } else if (state is OrdersLoaded) {
                  orders = state.orders;
                }
                OrdersBlocCubit ordersState = context.read<OrdersBlocCubit>();


                return

                    SmartRefresher(
                      header: WaterDropHeader(),

                      controller: ordersState.controller,
                      onLoading: (){
                        ordersState.onLoad();
                      },
                      enablePullUp: true,
                      enablePullDown: false,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * .02,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Row(
                                //    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  // Container(
                                  //   padding:
                                  //   const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                                  //   child: IconButton(
                                  //     icon: const Icon(
                                  //       Icons.arrow_back_ios,
                                  //       size: 28,
                                  //       color: AppTheme.secondary,
                                  //     ),
                                  //     onPressed: () {
                                  //       Navigator.of(context).pop();
                                  //     },
                                  //   ),
                                  // ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.symmetric( horizontal: 9),
                                    child: Text(
                                      LocaleKeys.my_orders.tr(),
                                      style: TextStyle(fontSize: size.width * .07, fontWeight: FontWeight.bold,color:  AppTheme.white,),
                                    ),
                                  ),
                                  // SizedBox(width: 60,),
                                ],
                              ),
                            ),
                            LocalStorage.getData(key: 'token')== null?
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: size.height *.3,),
                                  Text(
                                    LocaleKeys.sign_in_to_make.tr(),
                                    style: TextStyle(
                                      //  fontWeight: FontWeight.bold,
                                        fontSize: size.height *.033,
                                        color: Colors.white),
                                  ),
                                  SizedBox(height: size.height *.02,),
                                  DefaultButton(
                                    font: size.width * .055, radius: 15,
                                    title: LocaleKeys.sign_in.tr(),
                                    color: AppTheme.orange,
                                    textColor: Colors.white,
                                    width: size.width * .5,
                                    function: (){
                                      push(context,  BlocProvider(
                                          create: (BuildContext context) =>
                                              AuthCubit(AuthRepo()),
                                          child: Login()));
                                    },
                                  )
                                ],
                              ),
                            ):
                            ordersState.orders.length ==0?
                            Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(height: size.height *.11,),
                                  lottie.Lottie.asset(
                                      'assets/images/cart.json',
                                      height: size.height *.3,
                                      width: 400),
                                  SizedBox(height: size.height *.02,),
                                  Text(
                                    LocaleKeys.empty_orders.tr(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: size.height *.03,
                                        color: Colors.black),
                                  )
                                ],
                              ),
                            ):
                            Column(
                              children: [
                                /////////////////current order /////////
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
                                  margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/ready.png",height: size.height * .04,color: AppTheme.secondary,),
                                      SizedBox(
                                        width: size.width * .02,
                                      ),
                                      Text(LocaleKeys.Current_Orders.tr(),style: TextStyle( fontSize: size.width * .05,color: Colors.black, height:  size.height*0.0025,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * .02,
                                ),
                                ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount:ordersState.orders.length,
                                  itemBuilder: (ctx, index) {
                                    Orders order = ordersState.orders[index];
                                    return order.orderStatusId !=7?
                                      Container(
                                      margin: EdgeInsets.only(bottom: 10,right: 10,left: 10),
                                   //   width: size.width * .5,
                                      //height: price != null ? 200: 130,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        boxShadow: <BoxShadow>[
                                          BoxShadow(
                                              color: Colors.grey
                                                  .withOpacity(0.3),
                                              offset: const Offset(1.1, 4.0),
                                              blurRadius: 8.0),
                                        ],

                                        borderRadius:  BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.only(
                                            top: 10, left: 5, right: 5, bottom: 8),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Stack(
                                                    children: [
                                                      Container(
                                                        height: size.height * .14,
                                                        width:order.details!.length>1? size.width * .28:size.width * .34,

                                                        padding: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                                                        decoration: BoxDecoration(
                                                          color: AppTheme.secondary.withOpacity(1),
                                                          border: Border.all(width: 4,color: Colors.white),
                                                          borderRadius:  BorderRadius.circular(20),
                                                        ),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(7),
                                                          child: CachedNetworkImage(
                                                              imageUrl: order.details![0].product!.images!.image.toString()),
                                                        ),
                                                      ),
                                                      if(order.details!.length >1)
                                                      Container(
                                                        height: size.height * .14,
                                                        margin: EdgeInsets.only(left: context.locale.toString() == 'ar'?0:35,right: context.locale.toString() == 'ar'? 35:0,top: 10),
                                                        child: Container(
                                                          padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                                          decoration: BoxDecoration(
                                                            color: AppTheme.yellow,
                                                            border: Border.all(width: 4,color: Colors.white),
                                                            borderRadius:  BorderRadius.circular(20),
                                                          ),
                                                          child: Center(
                                                            child: ClipRRect(
                                                              borderRadius: BorderRadius.circular(7),
                                                              child: CachedNetworkImage(
                                                                  imageUrl: order.details![1].product!.images!.image.toString()),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(width: size.width *.04,),
                                                Expanded(
                                                  flex: 4,
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                         children: [
                                                          Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                            children: [
                                                              Text(order.uuid.toString(),  overflow: TextOverflow.ellipsis, maxLines: 1,
                                                                softWrap: false,style: TextStyle( fontSize: size.width * .044,fontWeight: FontWeight.bold, height:  size.height*0.003,),),
                                                              if(order.orderStatusId == 1)
                                                              GestureDetector(
                                                                onTap: () {
                                                                  ordersState.removeOrder(order.id, context);
                                                               //   cartState.removeItem(index,context);
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
                                                            ],
                                                          ),

                                                          SizedBox(height: size.height * .005,),
                                                          Row(
                                                            children: [

                                                              Text("${order.quantity} items  |",style: TextStyle( fontSize: size.width * .035,color: Colors.grey, height:  size.height*0.0015,fontWeight: FontWeight.bold),),
                                                              SizedBox(width: size.width * .01,),
                                                              Text("${order.createdAt?.substring(0,order.createdAt.toString().indexOf(" "))}",style: TextStyle( fontSize: size.width * .035,color: Colors.grey, height:  size.height*0.0015,fontWeight: FontWeight.bold),),
                                                              SizedBox(width: size.width * .05,),


                                                            ],
                                                          ),
                                                           SizedBox(height: size.height * .007,),
                                                           Text("${order.total.toString()} ${LocaleKeys.kwd.tr()}" ,style: TextStyle( fontSize: size.width * .04,color: AppTheme.secondary, height:  size.height*0.0015,fontWeight: FontWeight.bold),),
                                                           SizedBox(height: size.height * .007,),
                                                           Row(
                                                            children: [
                                                              Container(
                                                                  padding: EdgeInsets.symmetric(vertical: 5,horizontal: 12),
                                                                  decoration: BoxDecoration(
                                                                    color: AppTheme.secondary.withOpacity(.3),
                                                                  //  border: Border.all(width: 4,color: Colors.white),
                                                                    borderRadius:  BorderRadius.circular(5),
                                                                  ),
                                                                  child: Center(child: Text(order.orderStatus!.title!.en.toString() ,
                                                                    style: TextStyle( fontSize: size.width * .03,color: Colors.black, height:  size.height*0.002,fontWeight: FontWeight.bold),))),
                                                            ],
                                                          ),
                                                          SizedBox(height: size.height * .009,),



                                                        ],
                                                      ),


                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(height: size.height * .007,),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 27.0),
                                              child: Divider(
                                                thickness: .8,
                                              ),
                                            ),
                                            SizedBox(height: size.height * .007,),
                                            Center(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  DefaultButton(
                                                    textColor: AppTheme.secondary,
                                                    color: AppTheme.white,
                                                    borderColor: AppTheme.secondary,
                                                    title: LocaleKeys.details.tr(),
                                                    radius: 15,
                                                    function: (){
                                                      push(context,
                                                        BlocProvider<OrderDetailsCubit>(
                                                            create: (BuildContext context) => OrderDetailsCubit(OrderDetailsRepo(), order.id!),
                                                            child: OrderDetailsScreen()),
                                                      );
                                                    },
                                                    font: size.width * .042,
                                                    width: size.width * .33,
                                                    height: size.height *.046,

                                                  ),
                                                  if(order.orderStatusId != 7)
                                                  SizedBox(width: size.width * .07,),
                                                  if(order.orderStatusId != 7)
                                                  DefaultButton(
                                                    textColor: Colors.white,
                                                    color: AppTheme.secondary,
                                                    title: LocaleKeys.tracking.tr(),
                                                    radius: 15,
                                                    function: (){
                                                      push(context,
                                                          BlocProvider(
                                                              create: (BuildContext context) => StatusCubit(TrackingOrderRepo(),order.id),
                                                              child: TrackOrderScreen(orderMethodId: order.orderMethodId!,)));

                                                    },
                                                    font: size.width * .04,
                                                    width: size.width * .33,
                                                    height: size.height *.046,

                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: size.height * .007,),
                                          ],
                                        ),
                                      ),
                                    ):
                                        Container();
                                  }

                  ),
                                SizedBox(
                                  height: size.height * .01,
                                ),
                                ///////////////previous order /////////////
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 8),
                                  margin: const EdgeInsets.symmetric(horizontal: 15.0,vertical: 0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)
                                  ),                                  child: Row(
                                    children: [
                                      Image.asset("assets/images/pre.png",height: size.height * .04,color: AppTheme.secondary,),
                                      SizedBox(
                                        width: size.width * .02,
                                      ),
                                      Text(LocaleKeys.Previous_Orders.tr(),style: TextStyle( fontSize: size.width * .05,color: Colors.black, height:  size.height*0.0015,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: size.height * .02,
                                ),
                                ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemCount:ordersState.orders.length,
                                    itemBuilder: (ctx, index) {
                                      Orders order = ordersState.orders[index];
                                      return order.orderStatusId ==7?
                                      Container(
                                        margin: EdgeInsets.only(bottom: 10,right: 10,left: 10),
                                        //   width: size.width * .5,
                                        //height: price != null ? 200: 130,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          boxShadow: <BoxShadow>[
                                            BoxShadow(
                                                color: Colors.grey
                                                    .withOpacity(0.3),
                                                offset: const Offset(1.1, 4.0),
                                                blurRadius: 8.0),
                                          ],

                                          borderRadius:  BorderRadius.circular(20),
                                        ),
                                        child: Padding(
                                          padding:  EdgeInsets.only(
                                              top: 10, left: 5, right: 5, bottom: 8),
                                          child: Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                    flex: 3,
                                                    child: Stack(
                                                      children: [
                                                        Container(
                                                          height: size.height * .14,
                                                          width:order.details!.length>1? size.width * .28:size.width * .34,

                                                          padding: EdgeInsets.symmetric(vertical: 8,horizontal: 5),
                                                          decoration: BoxDecoration(
                                                            color: AppTheme.secondary.withOpacity(1),
                                                            border: Border.all(width: 4,color: Colors.white),
                                                            borderRadius:  BorderRadius.circular(20),
                                                          ),
                                                          child: ClipRRect(
                                                            borderRadius: BorderRadius.circular(7),
                                                            child: CachedNetworkImage(
                                                                imageUrl: order.details![0].product!.images!.image.toString()),
                                                          ),
                                                        ),
                                                        if(order.details!.length >1)
                                                          Container(
                                                            height: size.height * .14,
                                                            margin: EdgeInsets.only(left: context.locale.toString() == 'ar'?0:35,right: context.locale.toString() == 'ar'? 35:0,top: 10),
                                                            child: Container(
                                                              padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                                                              decoration: BoxDecoration(
                                                                color: AppTheme.yellow,
                                                                border: Border.all(width: 4,color: Colors.white),
                                                                borderRadius:  BorderRadius.circular(20),
                                                              ),
                                                              child: Center(
                                                                child: ClipRRect(
                                                                  borderRadius: BorderRadius.circular(7),
                                                                  child: CachedNetworkImage(
                                                                      imageUrl: order.details![1].product!.images!.image.toString()),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(width: size.width *.04,),
                                                  Expanded(
                                                    flex: 4,
                                                    child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: <Widget>[
                                                        Column(
                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                          children: [
                                                            SizedBox(
                                                              width:size.width *.7,
                                                              child: Text(order.uuid.toString(),  overflow: TextOverflow.ellipsis, maxLines: 1,
                                                                softWrap: false,style: TextStyle( fontSize: size.width * .044,fontWeight: FontWeight.bold, height:  size.height*0.003,),),
                                                            ),

                                                            SizedBox(height: size.height * .005,),
                                                            Row(
                                                              children: [

                                                                Text("${order.quantity} items  |",style: TextStyle( fontSize: size.width * .035,color: Colors.grey, height:  size.height*0.0015,fontWeight: FontWeight.bold),),
                                                                SizedBox(width: size.width * .01,),
                                                                Text("${order.createdAt?.substring(0,order.createdAt.toString().indexOf(" "))}",style: TextStyle( fontSize: size.width * .035,color: Colors.grey, height:  size.height*0.0015,fontWeight: FontWeight.bold),),
                                                                SizedBox(width: size.width * .05,),


                                                              ],
                                                            ),
                                                            SizedBox(height: size.height * .007,),
                                                            Text("${order.total.toString()} ${LocaleKeys.kwd.tr()}" ,style: TextStyle( fontSize: size.width * .04,color: AppTheme.secondary, height:  size.height*0.0015,fontWeight: FontWeight.bold),),
                                                            SizedBox(height: size.height * .007,),
                                                            Row(
                                                              children: [
                                                                Container(
                                                                    padding: EdgeInsets.symmetric(vertical: 5,horizontal: 12),
                                                                    decoration: BoxDecoration(
                                                                      color: AppTheme.secondary.withOpacity(.3),
                                                                      //  border: Border.all(width: 4,color: Colors.white),
                                                                      borderRadius:  BorderRadius.circular(5),
                                                                    ),
                                                                    child: Center(child: Text(order.orderStatus!.title!.en.toString() ,
                                                                      style: TextStyle( fontSize: size.width * .03,color: Colors.black, height:  size.height*0.002,fontWeight: FontWeight.bold),))),
                                                              ],
                                                            ),
                                                            SizedBox(height: size.height * .009,),



                                                          ],
                                                        ),


                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: size.height * .007,),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 27.0),
                                                child: Divider(
                                                  thickness: .8,
                                                ),
                                              ),
                                              SizedBox(height: size.height * .007,),
                                              Center(
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    DefaultButton(
                                                      textColor: AppTheme.secondary,
                                                      color: AppTheme.white,
                                                      borderColor: AppTheme.secondary,
                                                      title: LocaleKeys.details.tr(),
                                                      radius: 15,
                                                      function: (){
                                                        push(context,
                                                          BlocProvider<OrderDetailsCubit>(
                                                              create: (BuildContext context) => OrderDetailsCubit(OrderDetailsRepo(), order.id!),
                                                              child: OrderDetailsScreen()),
                                                        );
                                                      },
                                                      font: size.width * .042,
                                                      width: size.width * .33,
                                                      height: size.height *.046,

                                                    ),
                                                    if(order.orderStatusId != 7)
                                                      SizedBox(width: size.width * .07,),
                                                    if(order.orderStatusId != 7)
                                                      DefaultButton(
                                                        textColor: Colors.white,
                                                        color: AppTheme.secondary,
                                                        title: LocaleKeys.tracking.tr(),
                                                        radius: 15,
                                                        function: (){
                                                          push(context,
                                                              BlocProvider(
                                                                  create: (BuildContext context) => StatusCubit(TrackingOrderRepo(),order.id),
                                                                  child: OrderTrackingScreen(orderMethodId: order.orderMethodId!,)));

                                                        },
                                                        font: size.width * .04,
                                                        width: size.width * .33,
                                                        height: size.height *.046,

                                                      ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: size.height * .007,),
                                            ],
                                          ),
                                        ),
                                      ):
                                      Container();
                                    }

                                ),

                              ],
                            ),
                            SizedBox(height: size.height * .03,),
                          ],
                        ),
                      ),
                    );

            }
          )
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
          },
            child: CircularProgressIndicator(),
          )
        ),
      ),
    );
  }

}
