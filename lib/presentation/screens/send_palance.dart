import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/contact_bloc/contact_cubit.dart';
import 'package:loz/bloc/send_balance_bloc/balance_cubit.dart';

import 'package:loz/data/ServerConstants.dart';

import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../../theme.dart';

class SendBalanceScreen extends StatefulWidget {
  const SendBalanceScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<SendBalanceScreen> {

  String? phone, balance, name;
  bool isPassword = true;
  bool checkedValue = true;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body:
        BlocConsumer<BalanceCubit, BalanceState>(
            listener: (context, state) {
              if (state is BalanceFailure) {
                ServerConstants.showDialog1(context, state.error,false,'');
              } else if (state is BalanceSuccess) {
                Navigator.pop(context);
                context.read<BalanceCubit>().balance.clear();
                context.read<BalanceCubit>().phone.clear();
                showTopSnackBar(
                    context,
                    Card(
                      child: CustomSnackBar.success(
                        message:
                        " ${LocaleKeys.sent_success.tr()}",
                        backgroundColor: Colors.white,
                        textStyle: TextStyle(
                            color: Colors.black, fontSize: size.height * 0.025),
                      ),
                    ));
              } else if (state is ContactLoading) {
                LoadingScreen.show(context);
              }
            },

            builder: (context, state) {
              BalanceCubit balanceState = context.read<BalanceCubit>();


              return    Stack(
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
                                    LocaleKeys.send_balance.tr(),
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
                          height: size.height * 0.87,
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
                                  LocaleKeys.balance_txt.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.height * 0.032,
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  LocaleKeys.must_be_member.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: size.height * 0.015,
                                    color: Colors.black38
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              // Center(
                              //   child: Text(
                              //     LocaleKeys.welcome_we_are_excited_you_are_here.tr(),
                              //     style: TextStyle(
                              //       height: size.height * 0.002,
                              //       fontSize: size.height * 0.018,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  width: size.width,
                                  //alignment: Alignment.centerLeft,
                                  child: Text(
                                    LocaleKeys.phone_sender.tr(),
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
                                  controller: balanceState.phone,
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
                              SizedBox(
                                height: 20,
                              ),



                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  width: size.width,
                                  // alignment: Alignment.centerLeft,
                                  child: Text(
                                    LocaleKeys.amount.tr(),
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
                                  //  maxLines: 2,
                                  controller: balanceState.balance,
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
                                    balance = val!;
                                  },
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.05,
                              ),

                              InkWell(
                                onTap: () async{
                                  FocusScope.of(context).requestFocus(FocusNode());

                                  if (!_formKey.currentState!.validate()) {
                                    return;
                                  }

                                  _formKey.currentState!.save();

                                    await BlocProvider.of<BalanceCubit>(context).sendBalance(
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
                                height: 10,
                              ),

                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              );}
        )
    );
  }
}
