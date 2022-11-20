import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:loz/data/repositories/order_method_repo.dart';

import '../../../data/models/order_method_model.dart';
import '../../../local_storage.dart';
part 'payment_method_state.dart';

class PaymentMethodCubit extends Cubit<PaymentMethodState> {
  final OrderMethodRepo repo;
 List<OrderMethodModel> allPaymentMethods =[];

  PaymentMethodCubit(this.repo) : super(PaymentMethodInitial(),){
    getPaymentMethods();
  }



  void getPaymentMethods()async{
    emit(PaymentMethodLoading());
    var data = await repo.fetchPaymentMethod();
    final payments = List<OrderMethodModel>.from(
        data.map((method) => OrderMethodModel.fromJson(method)));
    if(LocalStorage.getData(key: "payment_method_id") !=null){
      for(int i =0; i< payments.length; i++){
        if(LocalStorage.getData(key: "payment_method_id") == payments[i].id)
        {
          payments[i].chosen=true;
        }
      }}
    allPaymentMethods = payments;
    emit(PaymentMethodLoaded(paymentMethods: payments));
  }

  switchPaymentMethod(List<OrderMethodModel> paymentList, int i){
    emit(PaymentMethodInitial());
    if (paymentList[i].chosen == null) paymentList[i].chosen = false;
    for (var element in paymentList) {
      element.chosen = false;
    }
    LocalStorage.saveData(key: "payment_method_id", value: paymentList[i].id);
    LocalStorage.saveData(key: "payment_method_name", value: paymentList[i].title!.en);

    paymentList[i].chosen=true;
    emit(PaymentMethodLoaded(paymentMethods:allPaymentMethods ));
  }


}
