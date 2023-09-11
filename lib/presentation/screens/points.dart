import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/order_details_bloc/order_details_cubit.dart';
import 'package:loz/bloc/points_bloc/points_cubit.dart';
import 'package:loz/data/repositories/Order_details_repo.dart';
import 'package:loz/presentation/widgets/default_button.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../theme.dart';
import 'order_details.dart';

class PointsScreen extends StatelessWidget {
  const PointsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      //  backgroundColor: AppTheme.background,
      body: SafeArea(
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
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Text(
                      LocaleKeys.my_points.tr(),
                      style: TextStyle(
                        fontSize: size.width * .06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(width: 60,),
                  ],
                ),
              ),
          BlocBuilder<PointsCubit, PointsBlocState>(
            builder: (context, state) {
              if (state is PointsLoading) {
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
    if(state is PointsLoaded){
      PointsCubit pointsState = context.read<PointsCubit>();
    return  Column(
        children: [
          SizedBox(
            height: size.height * .03,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
              LocaleKeys.my_balance_is.tr(),
                style: TextStyle(
                  fontSize: size.width * .05,
                  color: Colors.black
                ),
              ),
              Text(
                " ${state.points.balance} ${LocaleKeys.kwd.tr()}",
                style: TextStyle(
                    fontSize: size.width * .05,
                    color: Colors.green
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * .03,
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: size.height * .25,
                height: size.height * .25,
                decoration: BoxDecoration(
                    color:  int.parse( state.points.pointsSum.toString()) >= int.parse(state.points.limit.toString())?Colors.green.withOpacity(.25):AppTheme.secondary.withOpacity(0.25),
                    // border color
                    shape: BoxShape.circle,
                    border:
                    Border.all(width: 2, color: int.parse( state.points.pointsSum.toString()) >= int.parse(state.points.limit.toString())?Colors.green: AppTheme.secondary)),
                child: Padding(
                  padding: EdgeInsets.all(size.height * .02),
                  // border width
                  child: Container(
                    // or ClipRRect if you need to clip the content
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color:  int.parse( state.points.pointsSum.toString()) >= int.parse(state.points.limit.toString())?Colors.green.withOpacity(.25):AppTheme.secondary.withOpacity(0.25),
                        border: Border.all(
                            width: 5, color: int.parse( state.points.pointsSum.toString()) >= int.parse(state.points.limit.toString())?Colors.green: AppTheme.secondary)),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            state.points.pointsSum.toString(),
                            style: TextStyle(
                                fontSize: size.width * .08,
                                height: size.height * .0024,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.grey),
                          ),
                          Text(
                            LocaleKeys.points.tr(),
                            style: TextStyle(
                                fontSize: size.width * .06,
                                height: size.height * .001,
                                color: AppTheme.grey
                              //   fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ), // inner content
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: DefaultButton(
                  textColor: Colors.white,
                  color: int.parse( state.points.pointsSum.toString()) >= int.parse(state.points.limit.toString())?Colors.green: AppTheme.secondary,
                  title:  LocaleKeys.convert.tr(),
                  radius: size.width * .4,
                  height: size.height * .06,
                  width: size.width * .45,
                  function: () {
                    if(int.parse(state.points.pointsSum.toString()) >= int.parse(state.points.limit.toString()))
                    pointsState.convertPoints();
                    else
                      showTopSnackBar(
                          Overlay.of(context),
                          Card(
                            child: CustomSnackBar.success(
                              message: "${LocaleKeys.minimum_amount.tr()} ${state.points.limit} ${LocaleKeys.points.tr()}",
                              backgroundColor: Colors.white,
                              textStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.height * 0.02),
                            ),
                          ));
                  },
                  font: size.width * .048,
                ),
              ),
            ],
          ),
          SizedBox(
            height: size.height * .01,
          ),
          Text(
            "${LocaleKeys.minimum_amount.tr()} ${state.points.limit} ${LocaleKeys.points.tr()}",
            style: TextStyle(
                fontSize: size.width * .039,
                color:pointsState.pointOrders ==3? AppTheme.white:Colors.grey
              //   fontWeight: FontWeight.bold
            ),
          ),
          SizedBox(
            height: size.height * .02,
          ),
          Container(
            //  height: size.height * .3,
            width: size.width,
            decoration: BoxDecoration(
                color: AppTheme.white, // border color
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(15),
                    topLeft: Radius.circular(15))),
            child: Column(
              children: [
                Container(
                  width: size.width * .93,
                  height: size.height * .07,
                  decoration: BoxDecoration(
                      color: AppTheme.secondary.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(30)),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: (){
                          pointsState.switchPoints(1);
                        },
                        child: Container(
                          width: size.width * .31,
                          height: size.height * .08,
                          decoration: BoxDecoration(
                              color: pointsState.pointOrders ==1? AppTheme.secondary:Colors.transparent,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              LocaleKeys.all.tr(),
                              style: TextStyle(
                                  fontSize: size.width * .039,
                                  color:pointsState.pointOrders ==1? AppTheme.white:Colors.grey
                                //   fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          pointsState.switchPoints(2);
                        },
                        child: Container(
                          width: size.width * .31,
                          height: size.height * .08,
                          decoration: BoxDecoration(
                              color: pointsState.pointOrders ==2? AppTheme.secondary:Colors.transparent,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                                LocaleKeys.earned.tr(),
                              style: TextStyle(
                                  fontSize: size.width * .039,
                                  color:pointsState.pointOrders ==2? AppTheme.white:Colors.grey
                                //   fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          pointsState.switchPoints(3);
                        },
                        child: Container(
                          width: size.width * .31,
                          height: size.height * .08,
                          decoration: BoxDecoration(
                              color: pointsState.pointOrders ==3? AppTheme.secondary:Colors.transparent,
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                            child: Text(
                              LocaleKeys.converted.tr(),
                              style: TextStyle(
                                  fontSize: size.width * .039,
                                  color:pointsState.pointOrders ==3? AppTheme.white:Colors.grey
                                //   fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: state.points.points?.length ??0,
                    itemBuilder: (ctx, i) {
          return   pointsState.pointOrders ==2?
          state.points.points![i].isConverted ==0?
            InkWell(
              onTap: (){
                push(context,
                  BlocProvider<OrderDetailsCubit>(
                      create: (BuildContext context) => OrderDetailsCubit(OrderDetailsRepo(), state.points.points![i].orderId!),
                      child: OrderDetailsScreen()),
                );
              },
              child: Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 10, horizontal: 15),
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        height: size.height * .1,
                        decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(7)),
                        child: Row(
                          children: [
                            Container(
                              height: size.height * .06,
                              width: size.width * .012,
                              decoration: BoxDecoration(
                                  color:state.points.points![i].isConverted == 1?Colors.green:AppTheme.secondary,
                                  borderRadius:
                                  BorderRadius.circular(15)),
                              child: VerticalDivider(
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "${LocaleKeys.order.tr()} #"+state.points.points![i].orderId.toString(),
                                        style: TextStyle(
                                            fontSize: size.width * .034,
                                            height: size.height * .002,
                                            color: Colors.black
                                          //   fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      SizedBox(
                                        width: size.width * 0.04,
                                      ),
                                      Container(
                                        height: 2,
                                        width: size.width * 0.25,
                                        color: Colors.grey,
                                      ),
                                      SizedBox(
                                        width: size.width * 0.02,
                                      ),
                                      Text(
                                        "+ ${state.points.points![i].points}",
                                        style: TextStyle(
                                            fontSize: size.width * .04,
                                            height: size.height * .002,
                                            color: state.points.points![i].isConverted == 1?Colors.green:AppTheme.secondary,
                                            fontWeight: FontWeight.bold
                                        ),
                                      ),
                                      Text(
                                        "  ${LocaleKeys.points.tr()}",
                                        style: TextStyle(
                                            fontSize: size.width * .03,
                                            height: size.height * .002,
                                            color: Colors.grey
                                          //   fontWeight: FontWeight.bold
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: size.height * 0.005,
                                  ),
                                  Text(
                                    state.points.points![i].createdAt.toString(),
                                    style: TextStyle( height: size.height * .002,
                                        fontSize: size.width * .03,
                                        color: Colors.grey
                                      //   fontWeight: FontWeight.bold
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
            ):
          Container():
          pointsState.pointOrders ==3?
               state.points.points![i].isConverted ==1?
          InkWell(
            onTap: (){
              push(context,
                BlocProvider<OrderDetailsCubit>(
                    create: (BuildContext context) => OrderDetailsCubit(OrderDetailsRepo(), state.points.points![i].orderId!),
                    child: OrderDetailsScreen()),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: size.height * .1,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(7)),
              child: Row(
                children: [
                  Container(
                    height: size.height * .06,
                    width: size.width * .012,
                    decoration: BoxDecoration(
                        color:state.points.points![i].isConverted == 1?Colors.green:AppTheme.secondary,
                        borderRadius:
                        BorderRadius.circular(15)),
                    child: VerticalDivider(
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${LocaleKeys.order.tr()} #"+state.points.points![i].orderId.toString(),
                              style: TextStyle(
                                  height: size.height * .002,
                                  fontSize: size.width * .034,
                                  color: Colors.black
                                //   fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Container(
                              height: 2,
                              width: size.width * 0.25,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Text(
                              "+ ${state.points.points![i].points}",
                              style: TextStyle(
                                  height: size.height * .002,
                                  fontSize: size.width * .04,
                                  color: state.points.points![i].isConverted == 1?Colors.green:AppTheme.secondary,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "  ${LocaleKeys.points.tr()}",
                              style: TextStyle(
                                  height: size.height * .002,
                                  fontSize: size.width * .03,
                                  color: Colors.grey
                                //   fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.004,
                        ),
                        Text(
                          state.points.points![i].createdAt.toString(),
                          style: TextStyle(
                              height: size.height * .002,
                              fontSize: size.width * .03,
                              color: Colors.grey
                            //   fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ):
                   Container():
          InkWell(
            onTap: (){
              push(context,
                BlocProvider<OrderDetailsCubit>(
                    create: (BuildContext context) => OrderDetailsCubit(OrderDetailsRepo(), state.points.points![i].orderId!),
                    child: OrderDetailsScreen()),
              );
            },
            child: Container(
              margin: EdgeInsets.symmetric(
                  vertical: 10, horizontal: 15),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: size.height * .1,
              decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.25),
                  borderRadius: BorderRadius.circular(7)),
              child: Row(
                children: [
                  Container(
                    height: size.height * .06,
                    width: size.width * .012,
                    decoration: BoxDecoration(
                        color:state.points.points![i].isConverted == 1?Colors.green:AppTheme.secondary,
                        borderRadius:
                        BorderRadius.circular(15)),
                    child: VerticalDivider(
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Text(
                              "${LocaleKeys.order.tr()} #"+state.points.points![i].orderId.toString(),
                              style: TextStyle(
                                  height: size.height * .002,
                                  fontSize: size.width * .034,
                                  color: Colors.black
                                //   fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.04,
                            ),
                            Container(
                              height: 2,
                              width: size.width * 0.25,
                              color: Colors.grey,
                            ),
                            SizedBox(
                              width: size.width * 0.02,
                            ),
                            Text(
                              "+ ${state.points.points![i].points}",
                              style: TextStyle(
                                  height: size.height * .002,
                                  fontSize: size.width * .04,
                                  color: state.points.points![i].isConverted == 1?Colors.green:AppTheme.secondary,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            Text(
                              "  ${LocaleKeys.points.tr()}",
                              style: TextStyle(
                                  height: size.height * .002,
                                  fontSize: size.width * .03,
                                  color: Colors.grey
                                //   fontWeight: FontWeight.bold
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: size.height * 0.006,
                        ),
                        Text(
                          state.points.points![i].createdAt.toString(),
                          style: TextStyle(
                              height: size.height * .002,
                              fontSize: size.width * .03,
                              color: Colors.grey
                            //   fontWeight: FontWeight.bold
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
                    })

              ],
            ),
          )
        ],
      );
    }
    return SizedBox();

  }
          )],
          ),
        ),
      ),
    );
  }
}
