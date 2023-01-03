
import 'package:flutter/material.dart';
import 'package:loz/presentation/widgets/error_pop.dart';


class ServerConstants {
  static bool isValidResponse(int statusCode) {
    return statusCode >= 200 && statusCode <= 302;
  }

  static void showDialog1(BuildContext context, String s, bool? isActivate,String ? phone) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => ErrorPopUp(message: '$s',isActivate: isActivate!,phone: phone,),
    );
  }




  static const bool IS_DEBUG = true; // TODO: Close Debugging in Release.
  static const String API = "https://www.beta.toot.work/api";
  static const String categories ='${API}/categories';
  static const String recommend ='${API}/recommend';


  static const String slider ='${API}/slider';
  static const String products ='${API}/category';
  static const String details ='${API}/product';
  static const String filter ='${API}/products/filter';

  static const String favorite ='${API}/favourites/all';


  static const String login ='${API}/auth/login';
  static const String SIGNUP ='${API}/auth/register';
  static const String verify = '${API}/auth/verify';
  static const String forgetPassword = '${API}/auth/forgetPassword';
  static const String verifyForgetPass = '${API}/auth/verifyForgetPassword';
  static const String newPassword = '${API}/auth/newPassword';
  static const String deActivate   =  '${API}/client/deActivate';



  static const String orderMethods ='${API}/orderMethods';
  static const String paymentMethods ='${API}/paymentMethods';
  static const String cars ='${API}/car/all';
  static const String addresses ='${API}/address/homeAddress';
  static const String addressesGift ='${API}/address/giftAddress';

  static const String addCar ='${API}/car/store';
  static const String addAddress ='${API}/address/store-home-address';
  static const String editAddress ='${API}/address/update';

  static const String addAddressGift ='${API}/address/store-gift-address';


  static const String confirm ='${API}/orders';
  static const String favToggle ='${API}/favourites/toggle';
  static const String checkCoupon ='${API}/checkCoupon';
  static const String useBalance ='${API}/balance/all';


  static const String logout ='${API}/auth/logout';
  static const String lang ='${API}/lang/change';

  static const String terms ='${API}/terms';
  static const String contactUs ='${API}/contactUs';
  static const String branches = "${API}/branches";
  static const String about ='${API}/about';
  static const String contactData ='${API}/contactData';

  static const String notification ='${API}/notification/all';
  static const String unReadCount ='${API}/notification/unReadNotificationsCount';

  static const String read ='${API}/notification/read';

  static const String rate ='${API}/order/rate';


  static const String sendPhone = "${API}/user/resetPassword";
  static const String forgot = "${API}/user/resetPasswordConfirm";


  static const String orders = "${API}/orders";
  static const String track = "${API}/order";
  static const String availableOrderStatus = "${API}/availableOrderStatus";

  static const String points = "${API}/points/all";
  static const String days = "${API}/days";

  static const String covertPoints = "${API}/points/convert";
  static const String sendBalance = "${API}/balance/convert";
  static const String transactions = "${API}/balance/transactions";

  static const String statics = "${API}/client/statics";
  static const String makeDefault = "${API}/address/default";




















}
