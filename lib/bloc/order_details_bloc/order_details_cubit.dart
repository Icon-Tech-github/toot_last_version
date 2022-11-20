import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:loz/data/repositories/Order_details_repo.dart';
import 'package:loz/data/repositories/orders_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:meta/meta.dart';

import '../../data/models/orders_model.dart';

part 'order_details_state.dart';

class OrderDetailsCubit extends Cubit<OrderDetailsState> {
 final OrderDetailsRepository orderDetailsRepository;
 int id;
  OrderDetailsCubit(this.orderDetailsRepository,this.id) : super(OrderDetailsInitial()){
    getOrder();
  }
 Orders? order ;

 Future getOrder()async{
   emit(OrderDetailsLoading());
   orderDetailsRepository.fetchOrder(LocalStorage.getData(key: 'token'), id).then((value) {
      log(value.toString());
      order = Orders.fromJson(value);
     emit(OrderDetailsLoaded(order: order!));
   });
 }

}
