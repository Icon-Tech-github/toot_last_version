import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/time_bloc/time_cubit.dart';
import 'package:loz/local_storage.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/default_button.dart';
import '../widgets/helper.dart';
import 'confirm_order.dart';

class DeliveryTimeScreen extends StatefulWidget {
  const DeliveryTimeScreen({Key? key,this.freeToday,this.discount,this.delivery_fee}) : super(key: key);
  final double? delivery_fee;
  final double? discount;
  final bool? freeToday ;
  @override
  _DeliveryTimeScreenState createState() => _DeliveryTimeScreenState();
}

class _DeliveryTimeScreenState extends State<DeliveryTimeScreen> {
  int deliveryOption=0;
@override
  void initState() {
    // TODO: implement initState
  LocalStorage.saveData(key: 'fast_amount',value: LocalStorage.getData(key: "fast_delivery"));

  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
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
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          LocaleKeys.time_of_delivery.tr(),
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
                  SizedBox(height: size.height * .02,),
                  Text(
                    LocaleKeys.delivery_options.tr(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: size.height * 0.024,
                        height: size.height * 0.0025,
                        fontWeight: FontWeight.bold),
                  ),
                  GestureDetector(
                    onTap: (){
                      LocalStorage.removeData(key: 'deliveryTime');
                      LocalStorage.saveData(key: 'fast_amount',value: LocalStorage.getData(key: "fast_delivery"));

                      for (var element in context.read<TimeBlocCubit>().allTimes) {
                       // element.chosen = false;
                        for (var ele in element.daysTimes!) {
                          ele.chosen = false;
                        }
                      }
                      setState(() {
                        deliveryOption =0;
                      });
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              //   width: 23,
                              height: 25,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: deliveryOption==0
                                      ? AppTheme.orange
                                      : Colors.white,
                                  border: Border.all(
                                      color: deliveryOption==0
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
                            SizedBox(width: size.width * .04,),

                            Row(
                              children: [
                                Text(
                                  LocaleKeys.delivery_now.tr(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: size.height * 0.024,
                                      height: size.height * 0.0025,
                                      fontWeight: FontWeight.bold),
                                ),

                              ],
                            ),
                          ],
                        ),
                        Text(
                          "  (${LocaleKeys.fast_cost.tr()} ${LocalStorage.getData(key: "fast_delivery")} ${LocaleKeys.kwd.tr()})",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.024,
                              height: size.height * 0.0025,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .02,),

                  GestureDetector(
                    onTap: (){


                      setState(() {
                        LocalStorage.saveData(key: 'fast_amount',value: "0");
                        deliveryOption =1;

                      });
                    },
                    child: Row(
                      children: [
                        Container(
                          //   width: 23,
                          height: 25,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: deliveryOption==1
                                  ? AppTheme.orange
                                  : Colors.white,
                              border: Border.all(
                                  color: deliveryOption==1
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
                        SizedBox(width: size.width * .04,),

                        Text(
                            LocaleKeys.delivery_later.tr(),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: size.height * 0.024,
                              height: size.height * 0.0025,
                              fontWeight: FontWeight.bold),
                        ),
                        // Text(
                        //   LocaleKeys.fast_cost.tr()+LocalStorage.getData(key: "fast_delivery")+LocaleKeys.kwd.tr(),
                        //   style: TextStyle(
                        //       color: Colors.white,
                        //       fontSize: size.height * 0.024,
                        //       height: size.height * 0.0025,
                        //       fontWeight: FontWeight.bold),
                        // ),
                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .05,),
    Visibility(
      visible: deliveryOption ==1,
      child: BlocBuilder<TimeBlocCubit, TimeState>(
      builder: (context, state) {
              if (state is TimeLoading) {
                return Center(
                  child: SafeArea(
                    child: Column(
                      children: [
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
      if (state is TimeLoaded) {
        TimeBlocCubit timeState = context.read<TimeBlocCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              Text(
                LocaleKeys.delivery_days.tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.024,
                    height: size.height * 0.0025,
                    fontWeight: FontWeight.bold),
              ),
      Container(
      height: MediaQuery.of(context).size.height * .1,
      width: double.infinity,
      child: ListView.builder(
      // shrinkWrap: true,
      // physics: NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.only(
      top: 0, bottom: 0, right: 4, left: 4),
      itemCount: state.timeData.length ,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) =>
          InkWell(
              onTap: (){
                context.read<TimeBlocCubit>().chooseDay(index);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                padding: EdgeInsets.symmetric(horizontal: 10),

                width: size.width * .25,
                height: size.height *.1,
                decoration: BoxDecoration(
                  color: state.timeData[index].chosen == true?AppTheme.orange:AppTheme.white,
                  border: Border.all(color: AppTheme.secondary),
                  borderRadius: BorderRadius.circular(7)
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      timeState.checkToday( state.timeData[index].date.toString()) !=""? timeState.checkToday( state.timeData[index].date.toString()):
                      state.timeData[index].date.toString().substring(5,state.timeData[index].date!.length).replaceAll("-", "/"),
                      style: TextStyle(
                          color:state.timeData[index].chosen == true? Colors.white:Colors.black,
                          fontSize: size.height * 0.02,
                          height: size.height * 0.002,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                    LocalStorage.getData(key: "lang") == 'en'? state.timeData[index].title.toString(): state.timeData[index].display.toString(),
                      style: TextStyle(
                          color:state.timeData[index].chosen == true?Colors.white: Colors.black,
                          fontSize: size.height * 0.015,
                          height: size.height * 0.0015,
                          fontWeight: FontWeight.bold),
                    ),

                  ],
                ),
              ),
          )
        )),
              SizedBox(height: size.height * .04,),
              Text(
                LocaleKeys.delivery_times.tr(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: size.height * 0.024,
                    height: size.height * 0.0025,
                    fontWeight: FontWeight.bold),
              ),
                ListView.builder(
        shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.only(
        top: 0, bottom: 0, right: 4, left: 4),
        itemCount: state.timeData[timeState.daySelected].daysTimes!.length ,
       // scrollDirection: Axis.v,
        itemBuilder: (BuildContext context, int index) =>
              InkWell(
                onTap: (){
                  timeState.chooseTime(index);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 18,vertical: 10),
                  margin: EdgeInsets.symmetric(vertical: 5),
                  decoration: BoxDecoration(
                      color: timeState.checkToday(state.timeData[timeState.daySelected].date.toString()) == LocaleKeys.today.tr() ?timeState.calculateValidTime(state.timeData[timeState.daySelected].daysTimes![index].fromTime.toString(), state.timeData[timeState.daySelected].daysTimes![index].toTime.toString(),state.timeData[timeState.daySelected].date.toString())== false? Colors.grey.shade400: state.timeData[timeState.daySelected].daysTimes![index].chosen == true?AppTheme.orange:AppTheme.white:state.timeData[timeState.daySelected].daysTimes![index].chosen == true?AppTheme.orange:AppTheme.white,
                      border: Border.all(color: AppTheme.secondary),
                      borderRadius: BorderRadius.circular(7)
                  ),
                  child:  Text(
                    "${LocaleKeys.from.tr()} ${timeState.convertTime(state.timeData[timeState.daySelected].daysTimes![index].fromTime.toString())} ${LocaleKeys.to.tr()} ${timeState.convertTime(state.timeData[timeState.daySelected].daysTimes![index].toTime.toString())}",
                    style: TextStyle(
                      decoration:timeState.checkToday(state.timeData[timeState.daySelected].date.toString()) == LocaleKeys.today.tr() ?timeState.calculateValidTime(state.timeData[timeState.daySelected].daysTimes![index].fromTime.toString(), state.timeData[timeState.daySelected].daysTimes![index].toTime.toString(),state.timeData[timeState.daySelected].date.toString())== false? TextDecoration.lineThrough:TextDecoration.none:TextDecoration.none,
                        color:state.timeData[timeState.daySelected].daysTimes![index].chosen == true? Colors.white:Colors.black,
                        fontSize: size.height * 0.022,
                        height: size.height * 0.002,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
                ),
              SizedBox(height: size.height * .07,),

          ],
        );

      }
              return SizedBox();
      }),
    ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Center(
                      child: DefaultButton(
                        function: () {
                          if(deliveryOption ==0){
                            LocalStorage.removeData(key: "deliveryDate");
                            LocalStorage.removeData(key: "deliveryTime");
                            push(
                                context,
                                ConfirmOrderScreen(
                                  //    discount: descount,
                                    delivery_fee: widget.delivery_fee,

                                    freeToday: widget.freeToday
                                ));
                          }else{

                          if(LocalStorage.getData(key: "deliveryTime") != null) {
                            push(
                                context,
                                ConfirmOrderScreen(
                                  //    discount: descount,
                                    delivery_fee: widget.delivery_fee,

                                    freeToday: widget.freeToday
                                ));
                          }else{
                            showTopSnackBar(
                                Overlay.of(context),
                                Card(
                                  child: CustomSnackBar.success(
                                    message: LocaleKeys.add_delivery_time_please.tr(),
                                    backgroundColor: Colors.white,
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: size.height * 0.02),
                                  ),
                                ));
                          }}
                        },
                        title: LocaleKeys.next.tr(),
                        color: AppTheme.orange,
                        radius: 10,
                        textColor: AppTheme.white,
                        font: size.width * .05,
                        width: size.width * .5,
                      ),
                    ),
                  ),
                  SizedBox(height: 50,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
