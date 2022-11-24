import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/presentation/screens/Auth_screens/otp.dart';
import 'package:loz/presentation/screens/Auth_screens/register.dart';
import 'package:loz/theme.dart';

import '../bottom_nav.dart';

class ForgetPassword extends StatelessWidget {
  const ForgetPassword({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            color: AppTheme.secondary,
          ),
          ListView(
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
                             child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                              child: Icon(
                                Icons.arrow_back,
                                size: 30,
                                color: Colors.white,
                              ),
                          ),
                           ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 30, 40, 0),
                            child: Text(
                              'Reset Password',
                              style: TextStyle(
                                fontSize: size.height * 0.032,
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
                    SizedBox(height: size.height*0.1,),
                    Center(
                      child: Text(
                        'Let${"'"}s sign you in',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: size.height * 0.038,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.15,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Phone',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: size.height * 0.015,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: TextField(
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.2,
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => OTP(phoneNumber: '123456789',isResetPassword: true,),
                            ));
                      },
                      child: Container(
                        height: size.height * 0.065,
                        width: size.width * 0.5,
                        decoration: BoxDecoration(
                            color: AppTheme.secondary,
                            borderRadius: BorderRadius.circular(40)),
                        child: Center(
                          child: Text(
                            'Continue',
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
                      height: 30,
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (_)=>Register()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Don${"'"}t have an account ? ',
                            style: TextStyle(
                              color: Colors.grey, ),
                          ),
                          Text(
                            'Sign Up',
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
          )
        ],
      ),
    );
  }
}
