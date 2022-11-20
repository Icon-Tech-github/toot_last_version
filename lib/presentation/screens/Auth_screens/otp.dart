import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:loz/bloc/branches_bloc/branches_cubit.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/data/ServerConstants.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/presentation/screens/Auth_screens/new_pass.dart';
import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../bottom_nav.dart';
import 'forget_password.dart';

class OTP extends StatelessWidget {

 String phoneNumber = '';
 bool? isResetPassword = false;
OTP({required this.phoneNumber,this.isResetPassword});
String ?otpCode;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ServerConstants.showDialog1(context, state.error,false,'');
          } else if (state is AuthSuccess && context.read<AuthCubit>().isResend == true) {

            Navigator.pop(context);
            showTopSnackBar(
                context,
                Card(
                  child: CustomSnackBar.success(
                    message:   LocaleKeys.resend_msg.tr(),
                    backgroundColor: Colors.white,
                    textStyle: TextStyle(
                        color: Colors.black, fontSize: size.height * 0.02),
                  ),
                ));
          } else if (state is AuthSuccess &&  context.read<AuthCubit>().isResend == false) {
            if(isResetPassword!) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_)=>
                  BlocProvider(
                      create: (BuildContext context) =>
                          AuthCubit(AuthRepo()),
                      child: NewPass())));
            }else {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) =>
                      MultiBlocProvider(
                        providers: [
                          BlocProvider<HomeAdCubit>(
                            create: (BuildContext context) =>
                                HomeAdCubit(GetHomeRepository()),
                          ),
                          BlocProvider<DepartmentsCubit>(
                            create: (BuildContext context) =>
                                DepartmentsCubit(GetHomeRepository(),false,context,context.locale.toString()),
                          ),
                        ],
                        child: BottomNavBar(branches: BranchesCubit.branches,),
                      ),
                ),
              );
            }
          }
          else if (state is AuthLoading) {
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
          ListView(
            children: [
              SizedBox(
                  height: size.height * 0.12,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                          child: Icon(
                            Icons.arrow_back,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                   //   Spacer(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
                        child: Text(
                          LocaleKeys.verification.tr(),
                          style: TextStyle(
                            height:  size.height * 0.002,
                            fontSize: size.height * 0.04,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Spacer(),
                    ],
                  )),
              Container(
                height: size.height * 0.85,
                width: size.width,
                decoration: BoxDecoration(
                    color: AppTheme.background,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(50),
                      topLeft: Radius.circular(50),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Center(
                      child: Text(
                        LocaleKeys.confirm_phone.tr(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: size.height * 0.025,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        '${LocaleKeys.enter_code.tr()} $phoneNumber',
                        style: TextStyle(
                          fontSize: size.height * 0.015,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(30.0),
                      child: PinCodeTextField(
                        length: 4,
                        appContext: context,

                        obscureText: false,
                        animationType: AnimationType.fade,

                        animationDuration: Duration(milliseconds: 300),
                        onChanged: (value) {
                          print(value);
                        //  setState(() {
                            otpCode = value;
                        //  });
                        },
                        validator: (v) {
                          if (v!.length < 3) {
                            return "not valid";
                          } else {
                            return null;
                          }
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                            borderRadius: BorderRadius.circular(7),

                          fieldHeight: 75,
                          fieldWidth: 70,
                          inactiveColor: AppTheme.orange.withOpacity(.5),
                          activeColor: AppTheme.orange,
                          selectedColor: AppTheme.orange
                        ),

                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.code_not_received.tr(),
                          style: TextStyle(color: Colors.black54, fontSize: 15),
                        ),

                        CountdownTimer(
                          endTime: DateTime.now().millisecondsSinceEpoch + 1000 * 90,
                          widgetBuilder: (_, time) {
                            if (time == null) {
                              return  GestureDetector(
                                  onTap: ()async{
                                    await BlocProvider.of<AuthCubit>(context).forgotPass(
                                      phone: phoneNumber,
                                      isResendCode: true
                                    );
                                  },
                                  child: Center(child: Text(" ${LocaleKeys.resend.tr()}",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,color: AppTheme.secondary))));
                            }
                            return Center(
                              child: Text(
                                ' ${time.min??00}:${time.sec}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: AppTheme.secondary),),
                            );
                          },
                        ),
                      ],
                    ),

                    SizedBox(
                      height: size.height * 0.1,
                    ),

                    InkWell(
                      onTap: ()async {
if(isResetPassword == true){
  await BlocProvider.of<AuthCubit>(context).verifyForgetPassword(
    phone: phoneNumber,
    otp: otpCode,
  );
}else {
  await BlocProvider.of<AuthCubit>(context).verify(
    phone: phoneNumber,
    otp: otpCode,
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
                            isResetPassword!?
                            LocaleKeys.continuee.tr():
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
          )
        ],
      ),
      ) );
  }
}
