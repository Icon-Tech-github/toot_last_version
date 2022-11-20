import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/data/models/address_model.dart';
import 'package:loz/data/models/cars_model.dart';
import 'package:loz/data/models/order_method_model.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:meta/meta.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../data/repositories/order_method_repo.dart';
import '../../presentation/widgets/helper.dart';

part 'order_method_state.dart';

class OrderMethodCubit extends Cubit<OrderMethodState> {
  final OrderMethodRepo repo;
  List<OrderMethodModel> allOrderMethods =[];
  List<AddressModel> allAddresses =[];
  List<CarsModel> allCars =[];
  List<OrderMethodModel> allPaymentMethods =[];

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();
   bool gift = false;


  TextEditingController carModel = TextEditingController();
  TextEditingController carNumber = TextEditingController();
  TextEditingController carColor = TextEditingController();
  TextEditingController address = TextEditingController();



  OrderMethodCubit(this.repo,context,lang) : super(OrderMethodInitial()){
    getOrderMethods(context,lang);
  //  getPaymentMethods();
  }



  void getOrderMethods(context,lang)async{
    emit(OrderMethodLoading());
    emit(PaymentMethodLoading());

    var data = await repo.fetchOrderMethod();


      final orderMethods = List<OrderMethodModel>.from(
          data.map((method) => OrderMethodModel.fromJson(method)));
      if(LocalStorage.getData(key: "order_method_id") !=null){
        for(int i =0; i< orderMethods.length; i++){
          if(LocalStorage.getData(key: "order_method_id") == orderMethods[i].id)
          {
            if(orderMethods[i].id ==4)
              {
                gift = true;
              }
            orderMethods[i].chosen=true;
          }
        }}
      allOrderMethods = orderMethods;

    var data2 = await repo.fetchPaymentMethod();
    final payments = List<OrderMethodModel>.from(
        data2.map((method) => OrderMethodModel.fromJson(method)));
    if(LocalStorage.getData(key: "payment_method_id") !=null){
      for(int i =0; i< payments.length; i++){
        if(LocalStorage.getData(key: "payment_method_id") == payments[i].id)
        {
          payments[i].chosen=true;
        }
      }}
    allPaymentMethods = payments;
      emit(OrderMethodLoaded(orderMethods: orderMethods,paymentMethods: payments));
    emit(PaymentMethodLoaded(paymentMethods: payments));



  }


  switchOrderMethod(List<OrderMethodModel> orderMethod, int i){
    emit(OrderMethodInitial());
    if (orderMethod[i].chosen == null) orderMethod[i].chosen = false;
    for (var element in orderMethod) {
      element.chosen = false;
    }
    LocalStorage.saveData(key: "order_method_id", value: orderMethod[i].id);
    LocalStorage.saveData(key: "order_method_name", value: orderMethod[i].title!.en);

    orderMethod[i].chosen=true;
    if( orderMethod[i].id ==4) {
      gift = true;
      if(LocalStorage.getData(key: "payment_method_id") ==1){
        LocalStorage.removeData(key: "payment_method_id");
        for (var element in allPaymentMethods) {
          element.chosen = false;
        }
      }
    }
    else
      gift = false;
    emit(OrderMethodLoaded(orderMethods: allOrderMethods,paymentMethods: allPaymentMethods));
    emit(PaymentMethodLoaded(paymentMethods: allPaymentMethods));

  }
  chooseAddress(List<AddressModel> address, int i,context) {
    emit(OrderMethodInitial());
    if (allAddresses[i].chosen == null) allAddresses[i].chosen = false;
    for (var element in allAddresses) {
      element.chosen = false;
    }
    allAddresses[i].chosen = true;
    if (allAddresses[i].deliveryFee == 0) {
      showTopSnackBar(
          context,
          Card(
            child: CustomSnackBar.success(
              message: LocaleKeys.out_of_range.tr(),
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: MediaQuery
                      .of(context)
                      .size
                      .height * 0.02),
            ),
          ));
      LocalStorage.removeData(key: "addressId");
      LocalStorage.removeData(key: "addressTitle");
      emit(OrderMethodLoaded(orderMethods: allOrderMethods,paymentMethods: allPaymentMethods));
    } else{
      LocalStorage.saveData(key: "addressId", value: address[i].id!);
    LocalStorage.saveData(key: "addressTitle", value: address[i].title!);
      emit(OrderMethodLoaded(orderMethods: allOrderMethods,paymentMethods: allPaymentMethods));
  }

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
    if( paymentList[i].id !=1) {
      if (paymentList[i].chosen == null) paymentList[i].chosen = false;
      for (var element in paymentList) {
        element.chosen = false;
      }

      LocalStorage.saveData(key: "payment_method_id", value: paymentList[i].id);
      LocalStorage.saveData(
          key: "payment_method_name", value: paymentList[i].title!.en);

      paymentList[i].chosen = true;
    }else{
      if(gift == false){
        if (paymentList[i].chosen == null) paymentList[i].chosen = false;
        for (var element in paymentList) {
          element.chosen = false;
        }

        LocalStorage.saveData(key: "payment_method_id", value: paymentList[i].id);
        LocalStorage.saveData(
            key: "payment_method_name", value: paymentList[i].title!.en);

        paymentList[i].chosen = true;
      }
    }
    emit(PaymentMethodLoaded(paymentMethods:allPaymentMethods ));
  }
}
