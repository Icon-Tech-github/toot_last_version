import 'package:bloc/bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:loz/data/repositories/api_exeptions.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:meta/meta.dart';

import '../../local_storage.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepo authRepo;


  AuthCubit(this.authRepo) : super(AuthInitial()){
    check();
    statics();
  FirebaseMessaging.instance.getToken().then((value) {

  tokenFCM = value!;
  });
  // print(tokenFCM);
}
  String tokenFCM = '';
  bool ?status = true;
  String? balance ;

  String ? payLater ;
  String ?ordersCount;
  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      status = true;
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      status = true;
      return true;
    }
    status =false;
    print(status);
    return false;
  }
  login({String? phone, String? password}) async {
    emit(AuthLoading());
    LocalStorage.saveData(key: 'counter', value: 0);
   await authRepo
        .login(
      password: password,
      phone: phone,
     fcmToken: tokenFCM,
     lang: LocalStorage.getData(key: "lang")
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: LocaleKeys.not_found.tr()));
      }else  if (data ==  "307"){
        emit(AuthFailure(error: LocaleKeys.not_valid_number.tr()));
      }else  if (data ==  "401"){
        emit(AuthFailure(error: LocaleKeys.login_401.tr()));
      }else  if (data ==  "422"){
        emit(AuthFailure(error: LocaleKeys.login_422.tr()));
      }
      else{
        emit(AuthSuccess());
      }
    });
  }

  signUp({String? phone, String? password,String ? name}) async {
    emit(AuthLoading());
    try{

    await authRepo
        .signUp(
      password: password,
      phone: phone,
      name: name,

    )
        .then((data) async {

      if(data == null){
        emit(AuthFailure(error: LocaleKeys.not_found.tr()));
      }else  if (data ==  "422"){
        emit(AuthFailure(error: LocaleKeys.register_validate.tr()));
      }
      else{
        emit(AuthSuccess());
      }

    });}on ApiException catch (_) {
      print('ApiException');
      emit(AuthFailure(error: _.toString()));
    }
  }
  verify({String? phone, String? otp}) async {
    emit(AuthLoading());
    await authRepo
        .verify(
      otp: otp,
      phone: phone,
      fcmToken: tokenFCM,
        lang: LocalStorage.getData(key: "lang")
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: "wrong otp"));
      }else {
        isResend =false;
        emit(AuthSuccess());
      }
    });
  }
bool ? isResend = false;
  forgotPass({String? phone, bool? isResendCode}) async {
    emit(AuthLoading());
    await authRepo
        .forgetPassword(
      phone: phone,
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: LocaleKeys.not_found.tr() ));
      }else {
        isResend = isResendCode;
        emit(AuthSuccess());
      }
    });
  }


  verifyForgetPassword({String? phone, String? otp}) async {
    emit(AuthLoading());
    await authRepo
        .verifyForgetPassword(
      otp: otp,
      phone: phone,
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: "wrong otp"));
      }else {
        isResend =false;
        emit(AuthSuccess());
      }
    });
  }

  newPassword({String? phone, String? password}) async {
    emit(AuthLoading());
    await authRepo
        .newPassword(
      password: password,
      phone: phone,
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error:  LocaleKeys.not_found.tr()));
      }else {
        emit(AuthSuccess());
      }
    });
  }

  logout() async {
    emit(AuthLoading());
    await authRepo
        .logout(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: "not found"));
      }else {
        LocalStorage.removeData(key: "token");
        LocalStorage.removeData(key: "userName");
        LocalStorage.removeData(key: "phone");
        LocalStorage.removeData(key: "cart");


        emit(AuthSuccess());
      }
    });
  }
  statics() async {
    emit(StatsLoading());
    await authRepo
        .statics(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
       // emit(AuthFailure(error: "not found"));
      }else {
      balance =  data['balance'].toStringAsFixed(2);
      ordersCount = data['orders_count'].toString();
      payLater = data['pay_later_amount'].toStringAsFixed(2);

print(double.parse(payLater!));
      emit(StatsLoaded());
      }
    });
  }
  changeLang() async {
   // emit(AuthLoading());
    await authRepo
        .changeLang(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
       // emit(AuthFailure(error: "not found"));
      }else {
        // LocalStorage.removeData(key: "token");
        // LocalStorage.removeData(key: "userName");

     //   emit(AuthSuccess());
      }
    });
  }
  swichLag (context)async{
    emit(AuthInitial());
    if (context.locale.toString() == 'ar') {
      // SharedPreferences prefs =
      //     await SharedPreferences.getInstance();
      // prefs.setString("lang", "en");
      await context.setLocale(
        Locale("en"),
      );

    } else {
      // SharedPreferences prefs =
      //     await SharedPreferences.getInstance();
      // prefs.setString("lang", "ar");
      await context.setLocale(
        Locale("ar"),
      );

    }
  }
  deleteAcount() async {
    emit(AuthLoading());
    await authRepo
        .deleteAcount(LocalStorage.getData(key: "token")
    )
        .then((data) async {
      if(data == null){
        emit(AuthFailure(error: "not found"));
      }else {
        LocalStorage.removeData(key: "token");
        LocalStorage.removeData(key: "userName");
        LocalStorage.removeData(key: "phone");
        LocalStorage.removeData(key: "cart");

        emit(AuthSuccess());
      }
    });
  }
}
