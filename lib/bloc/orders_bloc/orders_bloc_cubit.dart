
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loz/data/models/orders_model.dart';
import 'package:loz/data/repositories/orders_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../translations/locale_keys.g.dart';

part 'orders_bloc_state.dart';

class OrdersBlocCubit extends Cubit<OrdersBlocState> {
  final OrdersRepository ordersRepo ;
  List<Orders> orders = [];
  List<Orders> currentOrders = [];
  List<Orders> acceptedOrders = [];
  List<Orders> historyOrders = [];
  OrdersBlocCubit(this.ordersRepo) : super(OrdersInitial()){

    onLoad();
  }
int page =1;
  RefreshController controller = RefreshController();
  int status=1;
  bool emptyCurrent = false;
  bool emptyAccepted = false;
  bool emptyHistory = false;





  var currentTimeZone;

  void onLoad()async{
    // currentOrders = [];
    // acceptedOrders = [];
    // historyOrders = [];
    if (state is OrdersLoading) return;

    final currentState = state;

    var oldOrders = <Orders>[];
    var oldCurrentOrders = <Orders>[];
    var oldAcceptedOrders = <Orders>[];
    var oldHistoryOrders = <Orders>[];

    if (currentState is OrdersLoaded) {
      oldOrders = currentState.orders;
      oldCurrentOrders = currentState.currentOrders;
      oldAcceptedOrders = currentState.acceptedOrders;
      oldHistoryOrders = currentState.historyOrders;

    }
    emit(OrdersLoading(oldOrders,oldCurrentOrders,oldAcceptedOrders,oldHistoryOrders, isFirstFetch: page == 1));
    if(LocalStorage.getData(key: 'token') == null) {
      orders = [];
      emit(OrdersLoaded(orders: orders,currentOrders: currentOrders,historyOrders: historyOrders,acceptedOrders: acceptedOrders));
    }else {
      var data = await ordersRepo.fetchOrders(LocalStorage.getData(key: 'token'),page);
      List<Orders> orders2 = List<Orders>.from(
          data.map((dep) => Orders.fromJson(dep)));
      page++;

      final products = (state as OrdersLoading).OldOrders;
      final currentProducts = (state as OrdersLoading).oldCurrentOrders;
      final acceptProducts = (state as OrdersLoading).oldAcceptedOrders;
      final historyProducts = (state as OrdersLoading).oldHistoryOrders;


      products.addAll(orders2);
      orders = products;
      currentOrders = currentProducts;
      acceptedOrders = acceptProducts;
      historyOrders = historyProducts;
      for(int i =0; i< orders2.length ; i++){
        if(orders2[i].orderStatusId ==1)
          currentProducts.add(orders2[i]);
        else if(orders2[i].orderStatusId !=1 && orders2[i].orderStatusId !=7)
          acceptProducts.add(orders2[i]);
        else  if(orders2[i].orderStatusId ==7)
          historyProducts.add(orders2[i]);
      }
      // if(currentOrders.length ==0)
      //   emptyCurrent = true;
      // else if(acceptedOrders.length ==0)
      //   emptyAccepted =true;
      // else if(historyOrders.length ==0)
      //   emptyHistory = true;
      print(currentOrders.length);
      controller.loadComplete();
      emit(OrdersLoaded(orders: products,currentOrders: currentProducts,historyOrders: historyProducts,acceptedOrders: acceptProducts));
    }

  }

  String convertTime(String timer) {


     timer = timer.substring( 0, timer.length-3).trim();
    currentTimeZone = DateTime.now().timeZoneOffset;
    currentTimeZone = currentTimeZone.toString()[0];
      DateTime timeFormat = DateTime.parse( "${timer}:00.000");
     // print(timeFormat);
     Intl.defaultLocale = 'en';
      var time = timeFormat.add(Duration(hours:  int.parse(currentTimeZone)));
    DateFormat   format = DateFormat("hh:mm a");
   //   String timee= '${time.hour}:${time.minute.toString().length == 1 ? '0${time.minute}' : time.minute}';
     // final format = DateFormat.jm();
      //print(timee);
     return format.format(time);

  }
  void removeOrder(int id,context)async{
    emit(OrdersLoading(orders,currentOrders,acceptedOrders,historyOrders));
    Size size = MediaQuery.of(context).size;
    ordersRepo.removeOrder(LocalStorage.getData(key: "token"),id).then((data) {
      if( data != null) {
        showTopSnackBar(
            context,
            Card(
              child: CustomSnackBar.success(
                message: LocaleKeys.remove_success.tr(),
                backgroundColor: Colors.white,
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: size.height * 0.04),
              ),
            ));
        for(int n =0; n< orders.length; n++) {
          if(orders[n].id == id){
            orders.removeAt(n);
            break;
          }
        }
        emit(OrdersLoaded(orders: orders,currentOrders: currentOrders,acceptedOrders: acceptedOrders,historyOrders: historyOrders));
      }else{
        print("llllkkkkkkll");

      }});
  }

  void switchStatus(int statusId){
    emit(OrdersInitial());
    status = statusId;
    emit(OrdersLoaded(orders: orders,currentOrders: currentOrders,acceptedOrders: acceptedOrders,historyOrders: historyOrders));
  }
}
