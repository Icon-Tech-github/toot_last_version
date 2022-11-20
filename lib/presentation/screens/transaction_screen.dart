import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/transaction_bloc/transaction_cubit.dart';
import 'package:loz/data/models/transaction_model.dart';
import 'package:lottie/lottie.dart'as lottie;
import 'package:loz/presentation/screens/send_palance.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc/send_balance_bloc/balance_cubit.dart';
import '../../data/repositories/points_repo.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/helper.dart';

class TransactionScreen extends StatelessWidget {
  const TransactionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SmartRefresher(
        controller: context.read<TransactionCubit>().controller,
        onLoading: (){
          context.read<TransactionCubit>().onLoad();
        },
        enablePullUp: true,
        enablePullDown: false,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
             children: [
               SizedBox(height:size.height * 0.02 ,),
               Padding(
                 padding: const EdgeInsets.symmetric(horizontal: 10.0),
                 child: Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Row(
                       children: [
                         Container(
                           padding: const EdgeInsets.symmetric(
                               vertical: 5, horizontal: 7),
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
                           LocaleKeys.my_balance.tr(),
                           style: TextStyle(
                             fontSize: size.width * .06,
                             fontWeight: FontWeight.bold,
                           ),
                         ),
                         // SizedBox(width: 60,),
                       ],
                     ),
                     InkWell(
                       onTap: (){
                         push(
                           context,
                           BlocProvider<BalanceCubit>(
                               create: (BuildContext context) =>
                                   BalanceCubit(PointsRepo()),
                               child: SendBalanceScreen()),
                         );
                       },
                       child: Container(
                       //  width: size.width * .18,
                         //height: size.height * .0,
                          padding: EdgeInsets.symmetric(horizontal: 12),
                         decoration: BoxDecoration(
                             color: AppTheme.secondary,
                             borderRadius: BorderRadius.circular(10)
                         ),
                         child: Center(
                           child: Text(
                               LocaleKeys.send_balance.tr(),
                               style: TextStyle(
                                   fontSize: size.width * .04,
                                   //height: size.height * .002,
                                   color:AppTheme.white,
                                   fontWeight: FontWeight.bold
                               )),
                         ),
                       ),
                     ),
                   ],
                 ),
               ),
               SizedBox(height: size.height * .02,),
    BlocBuilder<TransactionCubit, TransactionState>(

    builder: (context, state) {
        if (state is TransactionLoading && state.isFirstFetch) {
          return Center(
            child: SafeArea(
              child: Column(
                children: [

                  Container(
                    //   height: size.height * 0.4,
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
        List<TransactionDataModel> products = [];
        bool isLoading = false;

        if (state is TransactionLoading) {
          products = state.OldProducts;
          isLoading = true;
        } else if (state is TransactionLoaded) {
          products = state.products;
        }

        TransactionCubit transactionState = context.read<TransactionCubit>();

        return products.length == 0 ?
        Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: size.height * .21,),
              lottie.Lottie.asset(
                  'assets/images/search.json',
                  height: size.height * .3,
                  width: 400),
              SizedBox(height: size.height * .02,),
              Text(
                LocaleKeys.no_results.tr(),
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * .03,
                    color: Colors.white),
              )
            ],
          ),
        ) :
        Column(
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
                      transactionState.switchTrans(0);
                    },
                    child: Container(
                      width: size.width * .31,
                      height: size.height * .08,
                      decoration: BoxDecoration(
                          color: transactionState.trans ==0? AppTheme.secondary:Colors.transparent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          LocaleKeys.all.tr(),
                          style: TextStyle(
                              fontSize: size.width * .039,
                             color:transactionState.trans ==0? AppTheme.white:Colors.grey
                            //   fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      transactionState.switchTrans(1);
                    },
                    child: Container(
                      width: size.width * .31,
                      height: size.height * .08,
                      decoration: BoxDecoration(
                          color:transactionState.trans ==1? AppTheme.secondary:Colors.transparent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          LocaleKeys.sent.tr(),
                          style: TextStyle(
                              fontSize: size.width * .039,
                              color:transactionState.trans ==1? AppTheme.white:Colors.grey
                            //   fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                      transactionState.switchTrans(2);
                    },
                    child: Container(
                      width: size.width * .31,
                      height: size.height * .08,
                      decoration: BoxDecoration(
                         color:transactionState.trans ==2? AppTheme.secondary:Colors.transparent,
                          borderRadius: BorderRadius.circular(30)),
                      child: Center(
                        child: Text(
                          LocaleKeys.received.tr(),
                          style: TextStyle(
                              fontSize: size.width * .039,
                              color:transactionState.trans ==2? AppTheme.white:Colors.grey
                            //   fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
            SizedBox(height: size.height * .01,),
            ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: products.length ,
                itemBuilder: (ctx, i) {
                  return

            transactionState.trans ==1?
products[i].toClient != transactionState.id?
Container(
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
                color: AppTheme.orange,
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
                      "${LocaleKeys.to.tr()} ",
                      style: TextStyle(
                          fontSize: size.width * .04,
                          height: size.height * .002,
                          color: AppTheme.nearlyBlack,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    SizedBox(
                      width: size.width * .29,

                      child: Text(
                        products[i].reciever!.name.toString(),
                        style: TextStyle(
                            fontSize: size.width * .04,
                            height: size.height * .002,
                            color: Colors.black
                          //   fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    SizedBox(
                      width: size.width * 0.04,
                    ),
                    Container(
                      height: 2,
                      width: size.width * 0.2,
                      color: Colors.grey,
                    ),
                    SizedBox(
                      width: size.width * 0.02,
                    ),
                    Text(
                      products[i].amount.toString(),
                      style: TextStyle(
                          fontSize: size.width * .04,
                          height: size.height * .002,
                          color: AppTheme.orange,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Text(
                      "  ${LocaleKeys.kwd.tr()}",
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
                    products[i].createdAt.toString(),
                  style: TextStyle( height: size.height * .002,
                      fontSize: size.width * .035,
                      color: Colors.grey
                    //   fontWeight: FontWeight.bold
                  ),
                ),
              ],
            ),
          )
        ],
  ),
):
        Container():
          transactionState.trans ==2?
          products[i].toClient == transactionState.id?

          Container(
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
                     color:Colors.green,
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
                          "${LocaleKeys.from.tr()} ",
                            style: TextStyle(
                                fontSize: size.width * .04,
                                height: size.height * .002,
                                color: AppTheme.nearlyBlack,
                                 fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(
                            width: size.width * .29,
                            child: Text(
                              products[i].sender != null ? products[i].sender!.name.toString() :"${LocaleKeys.app_admin.tr()}",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: size.width * .04,
                                  height: size.height * .002,
                                  color: Colors.black
                                //   fontWeight: FontWeight.bold
                              ),
                            ),
                          ),
                          SizedBox(
                            width: size.width * 0.04,
                          ),
                          Container(
                            height: 2,
                            width: size.width * 0.2,
                            color: Colors.grey,
                          ),
                          SizedBox(
                            width: size.width * 0.02,
                          ),
                          Text(
                            products[i].amount.toString(),
                            style: TextStyle(
                                fontSize: size.width * .04,
                                height: size.height * .002,
                                   color: Colors.green,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          Text(
                            "  ${LocaleKeys.kwd.tr()}",
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
                        products[i].createdAt.toString(),
                        style: TextStyle( height: size.height * .002,
                            fontSize: size.width * .035,
                            color: Colors.grey
                          //   fontWeight: FontWeight.bold
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ):
          Container():

          Container(
            margin: EdgeInsets.symmetric(
                vertical: 10, horizontal: 15),
            padding: EdgeInsets.symmetric(horizontal: 10),
            height: size.height * .1,
            decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.25),
                borderRadius: BorderRadius.circular(7)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: size.height * .06,
                      width: size.width * .012,
                      decoration: BoxDecoration(
                         color:products[i].toClient == transactionState.id?Colors.green:AppTheme.orange,
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
                              SizedBox(
                                width: size.width * .23,
                                child: Text(
                      products[i].toClient != transactionState.id?
                                  products[i].reciever!.name.toString():
                                  products[i].sender == null? "${LocaleKeys.app_admin.tr()}" : products[i].sender!.name.toString(),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: size.width * .038,
                                      height: size.height * .002,
                                      color: Colors.black
                                    //   fontWeight: FontWeight.bold
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: size.width * 0.04,
                              ),
                              Container(
                                height: 2,
                                width: size.width * 0.17,
                                color: Colors.grey,
                              ),
                              SizedBox(
                                width: size.width * 0.02,
                              ),
                              Text(
                                products[i].amount.toString(),
                                style: TextStyle(
                                    fontSize: size.width * .04,
                                    height: size.height * .002,
                                    //   color: state.points.points![i].isConverted == 1?Colors.green:AppTheme.secondary,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              Text(
                                "  ${LocaleKeys.kwd.tr()}",
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
                            products[i].createdAt.toString(),
                            style: TextStyle( height: size.height * .002,
                                fontSize: size.width * .035,
                                color: Colors.grey
                              //   fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
                  Container(
                    width: size.width * .18,
                   height: size.height * .05,
                   // padding: EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      color:  products[i].toClient == transactionState.id? Colors.green :AppTheme.orange,
                      borderRadius: BorderRadius.circular(10)
                    ),
                    child: Center(
                      child: Text(
                          products[i].toClient == transactionState.id?
                              "${LocaleKeys.received.tr()}":
                      "${LocaleKeys.sent.tr()}",
                      style: TextStyle(
                      fontSize: size.width * .035,
                      //height: size.height * .002,
                      color: products[i].toClient == transactionState.id? Colors.white:AppTheme.white,
                         fontWeight: FontWeight.bold
                      )),
                    ),
                  ),
              ],
            ),
          );
                })
          ],
        );
    })
             ],
            ),
          ),
        ),
      ),
    );
  }
}
