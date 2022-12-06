
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
  OrdersBlocCubit(this.ordersRepo) : super(OrdersInitial()){

    onLoad();
  }
int page =1;
  RefreshController controller = RefreshController();
  int status=1;


  var currentTimeZone;

  void onLoad()async{
    for (int i = 3; i > -1; i--) {
      print(i);
    }
    if (state is OrdersLoading) return;

    final currentState = state;

    var oldOrders = <Orders>[];
    if (currentState is OrdersLoaded) {
      oldOrders = currentState.orders;
    }
    emit(OrdersLoading(oldOrders, isFirstFetch: page == 1));
    if(LocalStorage.getData(key: 'token') == null) {
      orders = [];
      emit(OrdersLoaded(orders: orders));
    }else {
      var data = await ordersRepo.fetchOrders(LocalStorage.getData(key: 'token'),page);
      List<Orders> orders2 = List<Orders>.from(
          data.map((dep) => Orders.fromJson(dep)));
      page++;

      final products = (state as OrdersLoading).OldOrders;
      products.addAll(orders2);
      orders = products;
      controller.loadComplete();
      emit(OrdersLoaded(orders: products));
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
    emit(OrdersLoading(orders));
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
        emit(OrdersLoaded(orders: orders));
      }else{
        print("llllkkkkkkll");

      }});
  }

  void switchStatus(int statusId){
    emit(OrdersInitial());
    status = statusId;
    emit(OrdersLoaded(orders: orders));  }
}
