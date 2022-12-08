import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:loz/payment_vars/network_helper.dart';
import 'package:loz/theme.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:http/http.dart' as http;
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import 'package:webview_flutter/webview_flutter.dart';
// import 'package:webview_flutter/webview_flutter.dart';
import 'package:xml/xml.dart';

import '../../bloc/single_product_bloc/single_product_cubit.dart';
import '../../data/models/confirm_order_model.dart';
import '../../data/models/products.dart';
import '../../data/repositories/confirm_order_repo.dart';
import '../../local_storage.dart';
import '../../payment_vars/constants_payment.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/helper.dart';
import 'faild_order.dart';
import 'order_success.dart';




class WebViewScreen extends StatefulWidget {
  final url;
  final code;
  // final String link;

  final String codee;
  List<ProductModel> products;
  WebViewScreen({@required this.url, @required this.code,required this.products,required this.codee});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  String _url = '';
  String _code = '';
  bool _showLoader = false;
  bool _showedOnce = false;

  // String cardToken = "";
  // String token = "";
  // String lan = '';
  // String note = '';

   ConfirmRepo ?repo = ConfirmRepo();
  // Future getDataFromSharedPrfs() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   // final _cardToken = prefs.getString("cardToken");
  //   final _token = prefs.getString("token");
  //   final _note = prefs.getString("order_note");
  //   final _translateLanguage = prefs.getInt('translateLanguage');
  //   setState(() {
  //     _translateLanguage == 0 ? lan = 'en' : lan = 'ar';
  //     // cardToken = _cardToken!;
  //     token = _token!;
  //     note = _note!;
  //   });
  //   // print(token);
  // }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
     if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    _url = widget.url;
    _code = widget.code;

  }



  void complete(XmlDocument xml) async{
    setState(() {
      _showLoader = true;
    });
    NetworkHelper _networkHelper = NetworkHelper();
    var response = await _networkHelper.completed(xml);
    if(response == 'failed' || response == null){
      alertShow('Failed. Please try again', false);
      setState(() {
        _showLoader = false;
      });
    }
    else{
      final doc = XmlDocument.parse(response);
      final message = doc.findAllElements('message').map((node) => node.text);
      print(message.toString() +"kkk");
      if(message.toString().length>2){
        String msg = message.toString();
        msg =  msg.replaceAll('(', '');
        msg = msg.replaceAll(')', '');
        setState(() {
          _showLoader = false;

        });

        if(msg != "Authorised"){
          push(context, OrderFailed());
          // Navigator.pop(context);
          // Navigator.pop(context);
          //
          // showTopSnackBar(
          //     context,
          //     Card(
          //       child: CustomSnackBar.success(
          //         message:   LocaleKeys.payment_failed.tr(),
          //         backgroundColor: Colors.white,
          //         textStyle: TextStyle(
          //             color: Colors.black, fontSize: MediaQuery.of(context).size.height * 0.02),
          //       ),
          //     ));
        }else{
          _showedOnce = true;
          confirmOrder(context);
        }
        ////////////////////////////////////////////////////////////////////////////////
        if(!_showedOnce) {
        }
        //////////////////////////////////////////////////////////////////////////////
        if(!_showedOnce) {
          _showedOnce = true;

        }
        // https://secure.telr.com/gateway/webview_start.html?code=a8caa483fe7260ace06a255cc32e
      }
    }
  }

  void alertShow(String text, bool pop) {
    //flutterWebviewPlugin.close();
    showPlatformDialog(
      context: context,
      builder: (_) => BasicDialogAlert(
        title: Text('$text', style: TextStyle(fontSize: 15),),
        // content: Text('$text Please try again.'),
        actions: <Widget>[
          BasicDialogAction(
              title: Text('Ok'),
              onPressed: () {


                if(pop){

                  Navigator.pop(context);
                  // Navigator.popAndPushNamed(context, HomeScreen.id);
                }
                else{
                  Navigator.pop(context);
                }
              }),
        ],
      ),
    );
  }

  void createXml(){
    final builder = XmlBuilder();
    builder.processing('xml', 'version="1.0"');
    builder.element('mobile', nest: () {
      builder.element('store', nest: (){
        builder.text(GlobalUtils.storeId);
      });
      builder.element('key', nest: (){
        builder.text(GlobalUtils.key);
      });
      builder.element('complete', nest: (){
        builder.text(_code);
      });

    });

    final bookshelfXml = builder.buildDocument();
    complete(bookshelfXml);
  }

  String _token = '';
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  final flutterWebviewPlugin = new WebView();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(

        children: [
          SizedBox(
            height: size.height * .025,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    size: size.width * .08,
                    color: AppTheme.secondary,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(vertical: 5, horizontal: 9),
                  child: Text(
                    LocaleKeys.payment.tr(),
                    style: TextStyle(
                      fontSize: size.width * .07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // SizedBox(width: 60,),
              ],
            ),
          ),

           Expanded(
             child: WebView(
              initialUrl: _url,


              javascriptMode: JavascriptMode.unrestricted,
              onWebViewCreated: (WebViewController webViewController) {
                _controller.complete(webViewController);
              },
              onPageStarted: (String url) {

                _showedOnce = false;
                if (url.contains('close')) {

                }
                if (url.contains('abort')) {

                }
              },

              onPageFinished: (String url) {


                if (url.contains('close')) {
                  setState(() {
                    loading = true;
                  });


                  createXml();

                }
                if (url.contains('abort')) {

                }
                if (url.contains('telr://internal?payment_token=')) {

                  String finalurl = url;

                  _token = finalurl.replaceAll('telr://internal?payment_token=', '');
                }
                else {
                  _token = '';
                  
                }

              },
              gestureNavigationEnabled: true,

          ),
           ),
        ],
      ),

    );
  }

  confirmOrder(context) async {

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



    for(int i =0 ; i< widget.products.length;i++) {
      attributes.add([]);
      addons.add([]);
      // if (element.attributes != null) {
      for(int j =0 ; j<widget.products[i].attributes!.length;j++){
        widget.products[i].attributes![j].values!.forEach((el) {
          attributes[i].add(el.id.toString());
        });

      }

      for(int k =0 ; k<widget.products[i].addons!.length;k++){
        widget.products[i].addons![k].values!.forEach((ele) {

          addons[i].add(ele.id.toString());
        });

      }
      //   }

      details.add(Details(
          id: widget.products[i].id,
          quantity:widget.products[i].count,
          notes: widget.products[i].notes??"",
          attributes: attributes[i],
          addons: addons[i]
      ).toJson());
    };

    Map map =  orderMethodId ==3?{
      "payment_method_id": paymentMethodId,
      "order_method_id": orderMethodId,
      "branch_id": 1,
      "coupon":coupon,
      "notes":note,
      "points_discount":useBalance,
      //  "car_id": carId,
      "address_id": addressId,
      "details": details
    }:orderMethodId ==2?{
      "notes":note,
      "coupon":coupon,
      "payment_method_id": paymentMethodId,
      "order_method_id": orderMethodId,
      "branch_id": LocalStorage.getData(key: "branchId"),
      "points_discount":useBalance,
      "car_id": carId,
      // "address_id": addressId,
      "details": details
    }:{
      "notes":note,
      "coupon":coupon,
      "payment_method_id": paymentMethodId,
      "order_method_id": orderMethodId,
      "branch_id": LocalStorage.getData(key: "branchId"),
      "points_discount":useBalance,
      "details": details
    };
    await repo!
        .confirm(map: map,token: token)
        .then((data) async {
      if(data == null){
        // emit(ConfirmFailure(error: "not found"));
      }
      else {

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
        LocalStorage.removeData(key: 'addressId');
        LocalStorage.removeData(key: 'carId');
        LocalStorage.removeData(key: 'addressTitle');
        LocalStorage.removeData(key: 'carTitle');


        List<String> cart = LocalStorage.getList(key: 'cart') ?? [];
        SingleProductCubit.cartCount = cart.length;

      }
    });
  }



  void displayToastMessage(var toastMessage) {
    showSimpleNotification(
        Container(
          height: 60,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              toastMessage,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Tajawal',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        background: AppTheme.secondary);
  }
}



