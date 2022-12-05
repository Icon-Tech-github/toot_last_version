import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loz/bloc/single_product_bloc/single_product_cubit.dart';
import 'package:loz/data/models/confirm_order_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/confirm_order_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/screens/order_success.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:meta/meta.dart';
import 'package:xml/xml.dart';

import '../../data/models/coupon_model.dart';
import '../../payment_vars/network_helper.dart';
import '../../presentation/screens/teller_webview.dart';
import '../../translations/locale_keys.g.dart';
part 'confirm_order_state.dart';

class ConfirmOrderCubit extends Cubit<ConfirmOrderState> {
  List<ProductModel> products =[];
  final ConfirmRepo repo;
  double discount=0.0;
  double tax =0;
  double limit =0;
  int ?type ;
  double totalBeforeDis=0;
  double deliveryFee =0;
  double discountRest=0;
  double percentageDiscount=0;
  var _url = '';
  String? deviceId ;
  TextEditingController code = new TextEditingController();
  bool checkedValue = false;
  bool apply = false;


  void getDeviceId ()async{
    deviceId = await _getId();
  }
  Future<String?> _getId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) { // import 'dart:io'
      var iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if(Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }




  ConfirmOrderCubit(this.repo) : super(ConfirmOrderInitial()){
    discount = LocalStorage.getData(key: "discount")??0.0;
    limit = LocalStorage.getData(key: "limit")??0;
    type = LocalStorage.getData(key: "type")??0;
    getCart();
    getDeviceId();
  }


  void _launchURL(String url, String code_pay,context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => WebViewScreen(
              products: products,
              codee: code_pay,
              url : url,
              code: code_pay,
            )));
  }


  void getCart(){
    emit(ConfirmOrderLoading());

    products = List<ProductModel>.from(json
        .decode(LocalStorage.getList(key: 'cart').toString())
        .map((e) => ProductModel.fromJson(e)));
    if(products.length !=0){
      tax = products[0].tax! / 100.0;
      print(tax);
    }
    emit(ConfirmOrderLoaded(products: products));
  }

  String convertTime(String timer) {

    DateTime now = DateTime.now();
    String date = now.toString().substring(0,10);
    DateTime timeFormat = DateTime.parse( "$date ${timer}.000");

    DateFormat   format = DateFormat("hh:mm a");

    return format.format(timeFormat);

  }


  double calculateTotal() {
    double total = 0;
    products.forEach((element) {
      total = (total + element.total!);
    });
    print(total.toString()+"[[[kkkk");

    total = total + calculateTax();
    deliveryFee = LocalStorage.getData(key: "deliveryFee") +(double.parse(LocalStorage.getData(key: "fast_amount")??"0"));
total = total + deliveryFee;

print(deliveryFee.toString()+"[[[kkkkk]]]");
    if(discount !=0){
      if(type == 1 || type == 3){
        if(total<discount){
          totalBeforeDis = total;
          discountRest = discount - total;
          total=0;
        }else {
          total = total - discount;
        }
      }else{
        percentageDiscount = total * discount/100;
        print(discount.toString()+"hhhh");
        print(limit);
        if(percentageDiscount < limit){
          if(total<percentageDiscount){
            totalBeforeDis = total;
            total=0;
          }else {
            total = total - percentageDiscount;
          }
        }else{
          if(total<limit){
            totalBeforeDis = total;
            discountRest = discount - total;
            total=0;
          }else {
            percentageDiscount = limit;
            total = total - limit;
          }
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

  int calculateItems(){
    int amount = 0;
    products.forEach((element) {
      amount = amount + element.count!;
    });

    return amount;
  }
  double calculateAmount(){
    return calculateTax() + calculateTotal();
  }
  String calculateDiscount(){
    double dis;
    print(totalBeforeDis.toString()+"nnnnnnnn");
    if(type == 2){
      if(calculateTotal() ==0)
        dis = totalBeforeDis;
      else
        dis= percentageDiscount;
    }else{
      if(calculateTotal() ==0)
        dis = totalBeforeDis;
      else
      dis= discount;
    }
    // if(dis > calculatePrices() + calculateTax())
    //   return (calculatePrices() + calculateTax()).toStringAsFixed(2);
    // else
      return dis.toStringAsFixed(2);
  }
  void getCartCount() {
    List<String> cart = LocalStorage.getList(key: 'cart') ?? [];
    SingleProductCubit.cartCount = cart.length;
  }
  confirmOrder(context) async {
    emit(ConfirmLoading());
    List<Map> details = [];
    List<List<String>>? attributes = [];
    List<List<String>>? addons = [];


    int paymentMethodId = LocalStorage.getData(key: "payment_method_id");
    int  orderMethodId= LocalStorage.getData(key: "order_method_id");
    dynamic  carId= LocalStorage.getData(key: "carId")??"";
    dynamic  addressId= LocalStorage.getData(key: "addressId")??'';
    String  token= LocalStorage.getData(key: "token")??"";
    int useBalance = LocalStorage.getData(key: "useBalance")??0;
    String coupon =  LocalStorage.getData(key: "coupon")??"";
    String note =  LocalStorage.getData(key: "note")??"";
    String deliveryDate =  LocalStorage.getData(key: "deliveryDate")??"";
    String deliveryTime =  LocalStorage.getData(key: "deliveryTime")??"";


if(deliveryTime == "")
  deliveryDate='';


    for(int i =0 ; i< products.length;i++) {
      attributes.add([]);
      addons.add([]);
      // if (element.attributes != null) {
      for(int j =0 ; j<products[i].attributes!.length;j++){
        products[i].attributes![j].values!.forEach((el) {
          attributes[i].add(el.id.toString());
        });

      }
      print(json.encode(products));
      for(int k =0 ; k<products[i].addons!.length;k++){
        products[i].addons![k].values!.forEach((ele) {
          print(ele.id);
          addons[i].add(ele.id.toString());
        });

      }
      //   }
      print(attributes);
      details.add(Details(
          id: products[i].id,
          quantity:products[i].count,
          notes: products[i].notes??"",
          attributes: attributes[i],
        addons: addons[i]
      ).toJson());
    };
    print(attributes);
    Map map =  orderMethodId ==3 ||  orderMethodId ==4?{
      "payment_method_id": paymentMethodId,
      "order_method_id": orderMethodId,
      "branch_id": 1,
      "coupon":coupon,
      "notes":note,
      "delivery_date":deliveryDate,
      "delivery_time":deliveryTime,
      "points_discount":useBalance,
      //  "car_id": carId,
      "address_id": addressId,
      "details": details
    }:orderMethodId ==2?{  
      "notes":note,
      "coupon":coupon,
      "payment_method_id": paymentMethodId,
      "order_method_id": orderMethodId,
      "branch_id": 1,
      "delivery_date":deliveryDate,
      "delivery_time":deliveryTime,
      "points_discount":useBalance,
      "car_id": carId,
      // "address_id": addressId,
      "details": details
    }:{
      "notes":note,
      "coupon":coupon,
      "payment_method_id": paymentMethodId,
      "order_method_id": orderMethodId,
      "delivery_date":deliveryDate,
      "delivery_time":deliveryTime,
      "branch_id": 1,
      "points_discount":useBalance,
      "details": details
    };
    await repo
        .confirm(map: map,token: token)
        .then((data) async {
      if(data == null){
        emit(ConfirmFailure(error: "not found"));
      }else {
        print(data.toString());
        pushReplacement(context, OrderSuccess(orderNum: data['data']['uuid'].toString(),orderId: data['data']['id'],methodId: orderMethodId,));
        LocalStorage.removeData(key: 'cart');
        LocalStorage.removeData(key: 'order_method_id');
        LocalStorage.removeData(key: 'payment_method_id');
        LocalStorage.removeData(key: 'discount');
        LocalStorage.removeData(key: 'limit');
        LocalStorage.removeData(key: 'type');
        LocalStorage.removeData(key: 'useBalance');
        LocalStorage.removeData(key: 'coupon');
        LocalStorage.removeData(key: 'note');
        // LocalStorage.removeData(key: 'addressId');
        LocalStorage.removeData(key: 'carId');
        LocalStorage.removeData(key: 'addressTitle');
        LocalStorage.removeData(key: 'carTitle');
        LocalStorage.removeData(key: 'deliveryDate');
        LocalStorage.removeData(key: 'deliveryTime');


getCartCount();

        emit(ConfirmSuccess());
      }
    });
  }
  void pay(XmlDocument xml,context)async{

    NetworkHelper _networkHelper = NetworkHelper();
    var response =  await _networkHelper.pay(xml);
    print(response);
    final doc = XmlDocument.parse(response);
    print('$response');
    final message = doc.findAllElements('status').map((node) => node.text);
    String msg = message.toString();
    msg =  msg.replaceAll('(', '');
    msg = msg.replaceAll(')', '');
    print(msg.toString()+"llllll");
    if(msg != '' ){
      print(msg);
      Navigator.pop(context);
      //  displayToastMessage(translate('lan.payment'));

      // failed
      // alertShow('Failed');
    }
    else
    {
      final doc = XmlDocument.parse(response);
      final url = doc.findAllElements('start').map((node) => node.text);
      final code = doc.findAllElements('code').map((node) => node.text);
      print(url);
      _url = url.toString();
      String _code = code.toString();
      if(_url.length>2){
        _url =  _url.replaceAll('(', '');
        _url = _url.replaceAll(')', '');
        _code = _code.replaceAll('(', '');
        _code = _code.replaceAll(')', '');
        _launchURL(_url,_code,context);
      }
      print(_url);
      final message = doc.findAllElements('message').map((node) => node.text);
      print('Message =  $message');
      if(message.toString().length>2){
        String msg = message.toString();
        msg = msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        //  alertShow(msg);
      }
    }
  }


  addCoupon(String promoCode) async {
    emit(AddCouponLoading());
    bool valid = true;
    for (int j = 0; j < products.length; j++) {
      if(products[j].denyCoupon ==1){
        valid = false;
        break;
      }
    }
    if(valid == true){
      var data =  await repo
          .addCoupon(promoCode);
      final  coupon = CouponModel.fromJson(data);
      if(coupon.data == null){

        emit(AddCouponFailure(error: LocaleKeys.not_valid.tr()));
      }else {
        discount = coupon.data!.value;
        limit = coupon.data!.limit;
        type = coupon.data!.type;
        LocalStorage.saveData(key: "coupon", value: promoCode);

        LocalStorage.saveData(key: "discount", value: discount);
        LocalStorage.saveData(key: "limit", value: limit);
        LocalStorage.saveData(key: "type", value: type);
        emit(AddCouponSuccess(coupon: coupon));
      }}else{
      emit(AddCouponFailure(error: LocaleKeys.empty_fav.tr()));

    }

  }

  useBalance() async {
    emit(UseBalanceLoading());
    var data =  await repo
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
  switchCoupon(){
    checkedValue = !checkedValue;
    emit(AddCouponLoading());
  }
  showApply(bool check){
    apply = check;
    emit(AddCouponLoading());
  }


}
