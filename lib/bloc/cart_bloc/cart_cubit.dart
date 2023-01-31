import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loz/bloc/single_product_bloc/single_product_cubit.dart';
import 'package:loz/data/models/coupon_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/cart.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:meta/meta.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  List<ProductModel> products = [];
  List<double> itemPrices = [];
  final CartRepos cartRepo;
  double discount =0;
  double limit =0;
  int ?type ;
  double discountRest=0;
  double totalBeforeDis=0;
  double tax =0;
  bool apply = false;
  TextEditingController code = new TextEditingController();
  TextEditingController note = new TextEditingController();


  CartCubit(this.cartRepo) : super(CartInitial()) {
    discount = LocalStorage.getData(key: "discount")??0;
    limit = LocalStorage.getData(key: "limit")??0;
    type = LocalStorage.getData(key: "type")??0;
    note.text = LocalStorage.getData(key: "note")??"";
    getCart();


  }

  void getCart() {
    emit(CartLoading());
    if (LocalStorage.getList(key: 'cart') != null)
      products = List<ProductModel>.from(json
          .decode(LocalStorage.getList(key: 'cart').toString())
          .map((e) => ProductModel.fromJson(e)));
    if(products.length !=0){
      tax = products[0].tax! / 100.0;
      print(tax);
    }
    // products.forEach((element) {itemPrices.add(element.t)});});
    print(json.encode(products));
    emit(CartLoaded(products: products));
  }

  void removeItem(int i,context) {
    emit(CartInitial());
    Size size =MediaQuery.of(context).size;
    showTopSnackBar(
        context,
        Card(
          child: CustomSnackBar.success(
            message: LocaleKeys.remove_success.tr(),
            backgroundColor: Colors.white,
            textStyle: TextStyle(
                color: Colors.black,
                fontSize: size.height * 0.025),
          ),
        ));
    List<String> data = [];
    print(i);
    products.removeAt(i);
if(products.length ==0)
  {
    discount =0;
    LocalStorage.removeData(key: 'discount');
    LocalStorage.removeData(key: 'limit');
    LocalStorage.removeData(key: 'type');
    LocalStorage.removeData(key: "coupon");
    LocalStorage.removeData(key: "useBalance");

  }
    for (int j = 0; j < products.length; j++) {
      data.add(jsonEncode(products[j].toJson()));
    }

    LocalStorage.saveList(key: 'cart', value: data);
    getCartCount();
    emit(CartLoaded(products: products));
  }
///////////////////////////////////
  addCoupon() async {
    emit(AddCouponLoading());
    bool valid = true;
    for (int j = 0; j < products.length; j++) {
    if(products[j].denyCoupon ==1){
      valid = false;
      break;
    }
    }
    if(valid == true){
    var data =  await cartRepo
        .addCoupon(code.text);
    final  coupon = CouponModel.fromJson(data);
    if(coupon.data == null){

      emit(AddCouponFailure(error: LocaleKeys.not_valid.tr()));
    }else {
      discount = coupon.data!.value;
      limit = coupon.data!.limit;
      type = coupon.data!.type;
      LocalStorage.saveData(key: "coupon", value: code.text);

      LocalStorage.saveData(key: "discount", value: discount);
      LocalStorage.saveData(key: "limit", value: limit);
      LocalStorage.saveData(key: "type", value: type);
      emit(AddCouponSuccess(coupon: coupon));
    }}else{
      emit(AddCouponFailure(error: LocaleKeys.empty_fav.tr()));

    }

  }

  deleteCoupon(){
    emit(CartInitial());
    discount =0;
    LocalStorage.removeData(key: 'discount');
    LocalStorage.removeData(key: 'limit');
    LocalStorage.removeData(key: 'type');
    LocalStorage.removeData(key: "coupon");
    emit(CartLoaded(products: products));
  }

  //////////////////////////
  useBalance() async {
    emit(UseBalanceLoading());
    var data =  await cartRepo
        .usePoints();
    if(data == null){

      emit(UseBalanceFailure(error: LocaleKeys.not_valid.tr()));
    }else {
      discount = double.parse(data['data'].toString());
      LocalStorage.saveData(key: "discount", value: discount);
      LocalStorage.saveData(key: "useBalance", value: 1);
      type = 3;
      LocalStorage.saveData(key: "type", value: 3);
      emit(UseBalanceSuccess(balance: discount.toString()));
    }

  }

  countIncrementAdnDecrement(String function, int i) {
    emit(CartInitial());
    products[i].total =
    (products[i].total! / products[i].count!);
    if (function == '+') {
      products[i].count = products[i].count! + 1;
    }
    if (function == '-') {
      if (products[i].count! > 1) {
        products[i].count = products[i].count! - 1;
      } else {
        products.removeAt(i);
      }
    }

    products[i].total =
        products[i].total! *
            double.parse(products[i].count.toString());
    calculateTotal();
    calculateTax();
    calculateAmount();

    List<String> data = [];
    for (int j = 0; j < products.length; j++) {
      data.add(jsonEncode(products[j].toJson()));
    }
    LocalStorage.saveList(key: 'cart', value: data);

    emit(CartLoaded(products: products));
  }

  double calculateTotal() {
    double total = 0;
    products.forEach((element) {
      total = (total + element.total!);
    });
     //total = total + calculateTax();
    if(discount !=0){
      if(type == 1 || type == 3){
        print('osama');
        if(total<discount){
          totalBeforeDis=total;
          discountRest = discount - total;
          print(discountRest);
          total=0;
        }else {
          total = total - discount;
        }
      }else{
        print('osamaaaaa');
        double dis=(total * discount)/100;
        print(discount);
        if(discount < limit){
          //discount = discount;
          total = total -dis;
        }else{
          dis = limit;
          total = total - limit;
        }

        if(total<dis){
          totalBeforeDis=total;
          discountRest =  discount - total;
          print(discountRest);
          total=0;
        }
      }
    }
    return total ;
  }
  double calculatePrices() {
    double total = 0;
    products.forEach((element) {
      total = (total + element.total!);
    });
    return total;
  }

  double calculateTax() {
    return calculatePrices() * tax;
  }
  String calculateDiscount(){
    double dis;
    if(type == 2){
      if(discount > limit){
        dis = (((calculatePrices()+calculateTax()) * limit)/100);
      }else
      dis = (((calculatePrices()+calculateTax()) * discount)/100);
    }else{
      if( calculateTotal()  ==0)
               dis= totalBeforeDis;
      else
        dis = discount;
    }
  //  if(dis > calculatePrices() + calculateTax())
    //  return (calculatePrices() + calculateTax()).toStringAsFixed(2);
  //  else
      return dis.toStringAsFixed(2);
}
  int calculateAmount() {
    int amount = 0;
    products.forEach((element) {
      amount = amount + element.count!;
    });

    return amount;
  }
  void setNote(String notes) {
    LocalStorage.saveData(key: "note", value: notes);

  }

  void applySwitch(String value){
    if (value != "")
      apply = true;
    else
      apply = false;
  }

  void getCartCount() {
    List<String> cart = LocalStorage.getList(key: 'cart') ?? [];
    SingleProductCubit.cartCount = cart.length;
  }
}
