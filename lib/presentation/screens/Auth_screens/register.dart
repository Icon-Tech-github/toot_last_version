import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/bloc/terms_bloc/terms_cubit.dart';
import 'package:loz/data/ServerConstants.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/data/repositories/terms_repo.dart';
import 'package:loz/presentation/screens/Auth_screens/otp.dart';
import 'package:loz/presentation/screens/terms.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/translations/locale_keys.g.dart';

import '../../../theme.dart';
import '../bottom_nav.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<Register> {

  String? phone, password, name;
  bool isPassword = true;
  bool checkedValue = true;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body:
        BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthFailure) {

              ServerConstants.showDialog1(context, state.error,false,'');
            } else if (state is AuthSuccess) {
            pushReplacement(context,  BlocProvider(
                create: (BuildContext context) =>
                    AuthCubit(AuthRepo()),
                child: OTP(phoneNumber: phone.toString(),isResetPassword: false,)));
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
                    height: size.height * 0.1,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 30, 20, 0),
                            child: Icon(
                              Icons.arrow_back,
                              size: 30,
                              color: Colors.white,
                            ),
                          ),
                        ),
                     //   Spacer(),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
                          child: Text(
                            LocaleKeys.sign_up.tr(),
                            style: TextStyle(
                              fontSize: size.height * 0.03,
                              height: size.height * 0.002,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Spacer(),
                      ],
                    )),
                Container(
                  height: size.height * 0.98,
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
                  LocaleKeys.lets_sign_you_up.tr(),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            height: size.height * 0.003,
                            fontSize: size.height * 0.033,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          LocaleKeys.welcome_we_are_excited_you_are_here.tr(),
                          style: TextStyle(
                            height: size.height * 0.002,
                            fontSize: size.height * 0.018,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.04,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          width: size.width,
                          //alignment: Alignment.centerLeft,
                          child: Text(
                            LocaleKeys.phone.tr(),
                            style: TextStyle(
                              color: Colors.grey,
                              height: size.height * 0.002,
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
                              "(+966)",
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
                                  if ( val!.length != 10) {
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
                        height: 20,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          width: size.width,
                         // alignment: Alignment.centerLeft,
                          child: Text(
                            LocaleKeys.name.tr(),
                            style: TextStyle(
                              color: Colors.grey,
                              height: size.height * 0.002,
                              fontSize: size.height * 0.02,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),

                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.Required.tr();
                            }
                            return null;
                          },
                          onSaved: (val) {
                            name = val!;
                          },
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Container(
                          width: size.width,
                         // alignment: Alignment.centerLeft,
                          child: Text(
                            LocaleKeys.password.tr(),
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
                        child:  TextFormField(
                          obscureText: isPassword,
                          cursorColor: Colors.black,
                          decoration: InputDecoration(
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            suffixIcon:  IconButton(
                              icon: isPassword ?  Icon(Icons.visibility_off,color: Colors.grey,): Icon(Icons.visibility,color: Colors.grey,) ,
                              onPressed: () => setState(() => isPassword = !isPassword ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return LocaleKeys.Required.tr();
                            } else if (value.length < 6) {
                              return LocaleKeys.phone_valid.tr();
                            }
                            return null;
                          },
                          onSaved: (val) {
                            password = val!;
                          },
                        ),
                      ),
                      SizedBox(
                        height: size.height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0.0, vertical: 8),
                        child: CheckboxListTile(
                          activeColor: AppTheme.secondary,
                          title: GestureDetector(
                              onTap: () {},
                              child: Row(
                                children: [
                                  Text(
                                    LocaleKeys.accept.tr()+" ",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        // Navigator.pushReplacement(
                                        //   context,
                                        //   MaterialPageRoute(
                                        //     builder: (context) {
                                        //       return const TermsScreen();
                                        //     },
                                        //   ),
                                        // );
                                      },
                                      child: GestureDetector(
                                        onTap: (){
                                          push(
                                            context,
                                            BlocProvider<TermsCubit>(
                                                create: (BuildContext
                                                context) =>
                                                    TermsCubit(
                                                        TermsRepo()),
                                                child:
                                                TermsScreen()),
                                          );
                                        },
                                        child: Text(
                                          LocaleKeys.terms.tr(),
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppTheme.secondary,
                                            decoration: TextDecoration.underline,
                                          ),
                                        ),
                                      )),
                                ],
                              )),
                          value: checkedValue,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue!;
                            });
                          },
                          controlAffinity: ListTileControlAffinity
                              .leading, //  <-- leading Checkbox
                        ),
                      ),
                      InkWell(
                        onTap: () async{
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          _formKey.currentState!.save();
                          if(checkedValue) {
                            await BlocProvider.of<AuthCubit>(context).signUp(
                                phone: phone,
                                password: password,
                                name: name
                            );
                          }
                        },
                        child: Container(
                          height: size.height * 0.065,
                          width: size.width * 0.5,
                          decoration: BoxDecoration(
                              color: AppTheme.secondary,
                              borderRadius: BorderRadius.circular(40)),
                          child: Center(
                            child: Text(
                              LocaleKeys.sign_up.tr(),
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
                        height: 10,
                      ),
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              LocaleKeys.already_have_an_account.tr() +' ',
                              style: TextStyle(
                                color: Colors.grey, ),
                            ),
                            Text(
                              LocaleKeys.login.tr(),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
        )
    );
  }
}
