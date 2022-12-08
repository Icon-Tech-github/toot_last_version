import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/data/ServerConstants.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/presentation/screens/Auth_screens/register.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';

import '../bottom_nav.dart';
import 'otp.dart';

class ForgotPassword extends StatefulWidget {
  ForgotPassword({Key? key}) : super(key: key);
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ForgotPassword> {

  String? phone, password;
  bool isPassword = true;

  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {
              ServerConstants.showDialog1(context, state.error,false,"");
            } else if (state is AuthSuccess) {
              pushReplacement(context,  BlocProvider(
                  create: (BuildContext context) =>
                      AuthCubit(AuthRepo()),
                  child: OTP(phoneNumber: phone.toString(),isResetPassword: true,)));
            } else if (state is AuthLoading) {
              LoadingScreen.show(context);
            }
          },


          builder: (context, state) =>
              Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    color: AppTheme.secondary,
                  ),
                  Form(
                    key: _formKey,
                    child: ListView(
                      children: [
                        SizedBox(
                            height: size.height * 0.4,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: (){
                                        Navigator.pop(context);
                                      },
                                      child: const Padding(
                                        padding: EdgeInsets.fromLTRB(15, 30, 15, 0),
                                        child: Icon(
                                          Icons.arrow_back,
                                          size: 30,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    //  Spacer(),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                                      child: Text(
                                        LocaleKeys.forget_password.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height: size.height *.002,
                                          fontSize: size.height * 0.03,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Spacer(),
                                  ],
                                ),
                                SizedBox(height: 30,),
                                Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40.0),
                                  ),
                                  elevation: 5,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(40),
                                    child: Image.asset('assets/images/toot.png',
                                        height: size.height*0.2,
                                        fit: BoxFit.contain),
                                  ),
                                )
                              ],
                            )),
                         Container(
                           height: size.height*0.6,

                          width: size.width,
                          decoration: BoxDecoration(
                              color: AppTheme.background,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(50),
                                topLeft: Radius.circular(50),
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  LocaleKeys.enter_num.tr(),
                                  style: TextStyle(
                                    height: size.height *.002,
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.height * 0.03,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                child: Text(
                                  LocaleKeys.enter_pass_title.tr(),
                                  style: TextStyle(
                                      fontSize: size.height * 0.018,
                                    color: Colors.grey
                                      ),
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.07,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  width: size.width,
                                  //  alignment: Alignment.centerLeft,
                                  child: Text(
                                    LocaleKeys.phone.tr(),
                                    style: TextStyle(
                                      height: size.height * 0.002,
                                      color: Colors.grey,
                                      fontSize: size.height * 0.02,
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "(+965)",
                                      style: TextStyle(
                                        height: size.height * 0.002,
                                        color: Colors.black,
                                        fontSize: size.height * 0.019,
                                      ),),
                                    SizedBox(
                                        width: size.width * .03),
                                    SizedBox(
                                      width: size.width * .63,
                                      child: TextFormField(
                                        cursorColor: Colors.black,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          focusedBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(color: Colors.grey),
                                          ),
                                        ),
                                        validator: (val) {
                                          if (val!.length != 10) {
                                            return LocaleKeys.phone_valid.tr();
                                          }
                                        },
                                        onSaved: (val) {
                                          phone = val!;
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.12,
                              ),
                              InkWell(
                                onTap: () async{
                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  _formKey.currentState!.save();
                                  await BlocProvider.of<AuthCubit>(context).forgotPass(
                                    phone: phone,
                                  );
                                },
                                child: Container(
                                  height: size.height * 0.065,
                                  width: size.width * 0.5,
                                  decoration: BoxDecoration(
                                      color: AppTheme.secondary,
                                      borderRadius: BorderRadius.circular(40)),
                                  child: Center(
                                    child: Text(
                                      LocaleKeys.confirm.tr(),
                                      style: TextStyle(
                                        fontSize: size.height * 0.022,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                              SizedBox(
                                height: 50,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
        ));
  }
}
