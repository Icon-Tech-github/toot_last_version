import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/theme.dart';

import '../bottom_nav.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({Key? key}) : super(key: key);

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
                  height: size.height * 0.12,
                  child: Row(
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        'Enter new password',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: size.height * 0.03,
                        ),
                      ),
                    ),

                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password *',
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
                            suffixIcon: Icon(Icons.visibility_off)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
                        width: size.width,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Confirm Password *',
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
                        decoration: InputDecoration(
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                            suffixIcon: Icon(Icons.visibility_off)
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.12,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
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
                                child: BottomNavBar(),
                              ),
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
                            'Confirm',
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
    );
  }
}
