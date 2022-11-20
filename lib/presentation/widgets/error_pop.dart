
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/presentation/screens/Auth_screens/otp.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';

import 'helper.dart';



class ErrorPopUp extends StatelessWidget {
  final String message;
  final bool isActivate ;
  final String? phone;

  ErrorPopUp({ required this.message,this.isActivate=false,this.phone});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      title: Text(
        LocaleKeys.sorry_translate.tr(),
        style: TextStyle(height: 2),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 2.0),
          Container(
            child: Center(
              child: Text(
                "$message",
                textAlign:  TextAlign.center,
                style: TextStyle(height: 2),
              ),
            ),
          ),
          SizedBox(height: 8.0),
          InkWell(
            onTap: () {
if(isActivate == false) {
  Navigator.of(context).pop();
  Navigator.of(context).pop();
}else{
  Navigator.of(context).pop();
  pushReplacement(context,  BlocProvider(
      create: (BuildContext context) =>
          AuthCubit(AuthRepo()),
      child: OTP(phoneNumber: phone.toString(),isResetPassword: false,)));
}

          },

            child: Container(
              color: AppTheme.orange,
              child: Center(
                child: Text(
                  isActivate? LocaleKeys.verify.tr() : LocaleKeys.ok_translate.tr(),
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),

            ),
          ),
          SizedBox(height: 8.0),
        ],
      ),
    );
  }
}
