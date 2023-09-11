import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/contact_bloc/contact_cubit.dart';
import 'package:whatsapp/whatsapp.dart';
import 'package:loz/data/ServerConstants.dart';

import 'package:loz/presentation/widgets/loading.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';

import '../../../theme.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({Key? key}) : super(key: key);
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<ContactUsScreen> {

  String? phone, password, name;
  bool isPassword = true;
  bool checkedValue = true;
  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body:
        BlocConsumer<ContactCubit, ContactState>(
          listener: (context, state) {
            if (state is ContactFailure) {
              ServerConstants.showDialog1(context, state.error,false,'');
            } else if (state is ContactSuccess) {
              Navigator.pop(context);
              context.read<ContactCubit>().email.clear();
              context.read<ContactCubit>().phone.clear();
              context.read<ContactCubit>().massage.clear();
              showTopSnackBar(
                  Overlay.of(context),
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
            ContactCubit contactState = context.read<ContactCubit>();


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
                                    LocaleKeys.contact_us.tr(),
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
                          height: size.height * 0.9,
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
                              Text(
                                LocaleKeys.contact_us.tr(),
                               // textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  height: size.height * 0.002,
                                  fontSize: size.height * 0.032,
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.03,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 28.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                        onTap: (){
                                          if(contactState.data?.twitter != null)
                                          launch(contactState.data!.twitter.toString());

                                        },
                                        child: Image.asset("assets/images/twitter.png",height: size.height * .06,)),
                                    InkWell(
                                        onTap: (){
                                          if(contactState.data?.instagram != null)
                                          launch(contactState.data!.instagram.toString());

                                        },
                                        child: Image.asset("assets/images/instagram.png",height: size.height * .06,)),
                                    InkWell(
                                        onTap: (){

                                          var whatsappUrl =
                                          WhatsAppUnilink(
                                            phoneNumber: '${contactState.data!.whatsapp.toString()}',
                                            text: "",
                                          );
                                         //     "whatsapp://send?phone=${contactState.data!.whatsapp.toString()}";
                                          if(contactState.data?.whatsapp != null)
                                          launch('$whatsappUrl');
                                        },
                                        child: Image.asset("assets/images/whatsapp.png",height: size.height * .06,)),
                                    InkWell(
                                      onTap: (){
                                        if(contactState.data?.phone != null)
                                        launch("tel://${contactState.data!.phone.toString()}");

                                      },
                                        child: Image.asset("assets/images/phone.png",height: size.height * .06,))

                                  ],
                                ),
                              ),
                              SizedBox(
                                height: size.height * 0.04,
                              ),
                              Center(
                                child: Text(
                                  LocaleKeys.suggestion.tr(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    height: size.height * 0.002,
                                    fontSize: size.height * 0.032,
                                  ),
                                ),
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
                                child: TextFormField(
                                  controller: contactState.phone,
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
                                   ' ${LocaleKeys.email.tr()} (${LocaleKeys.optional.tr()})',
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
    keyboardType: TextInputType.emailAddress,
                                  controller: contactState.email,
                                  cursorColor: Colors.black,
                                  decoration: InputDecoration(
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.grey),
                                    ),

                                  ),
                                  validator: (val){
      if(val != "" && val != null)
      if( RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(val) == false){
        return LocaleKeys.phone_valid.tr();
      }
                                  },
                                  // onSaved: (val) {
                                  //   name = val!;
                                  // },
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
                                    LocaleKeys.message.tr(),
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
                                controller: contactState.massage,
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
                                    password = val!;
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
                                  if(checkedValue) {
                                    await BlocProvider.of<ContactCubit>(context).contact(
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
