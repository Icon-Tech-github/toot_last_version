import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/widgets/default_button.dart';

import '../../bloc/branches_bloc/branches_cubit.dart';
import '../../bloc/home/departments_bloc/departments_cubit.dart';
import '../../bloc/home/home_ad_bloc/home_ad_cubit.dart';
import '../../bloc/single_product_bloc/single_product_cubit.dart';
import '../../data/models/branch_model.dart';
import '../../data/repositories/branch_repo.dart';
import '../../data/repositories/home_repo.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../screens/bottom_nav.dart';
import '../screens/location_activate.dart';

String? validateName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "الاسم مطلوب";
   }
    // else if (!regExp.hasMatch(value ?? '')) {
  //   return "Name must be a-z and A-Z";
  // }
  return null;
}
String? validateStoreName(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "اسم المحل مطلوب";
  }
  // else if (!regExp.hasMatch(value ?? '')) {
  //   return "Name must be a-z and A-Z";
  // }
  return null;
}
String? validateStoreAddress(String? value) {
  String pattern = r'(^[a-zA-Z ]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "عنوان المحل مطلوب";
  }
  // else if (!regExp.hasMatch(value ?? '')) {
  //   return "Name must be a-z and A-Z";
  // }
  return null;
}
String? validateMobile(String? value) {
  String pattern = r'(^\+?[0-9]*$)';
  RegExp regExp = RegExp(pattern);
  if (value?.isEmpty ?? true) {
    return "الموبايل مطلوب";
  } else if (!regExp.hasMatch(value ?? '')) {
    return "الموبايل يحتوي علي ارقام فقط";
  }
  return null;
}

String? validatePassword(String? value) {
  if ((value?.length ?? 0) < 6) {
    return 'كلمة المرور اكبر من 5 ';
  } else {
    return null;
  }
}

String? validateEmail(String? value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = RegExp(pattern);
  if (!regex.hasMatch(value ?? '')) {
    return 'Enter Valid Email';
  } else {
    return null;
  }
}

String? validateConfirmPassword(String? password, String? confirmPassword) {
  if (password != confirmPassword) {
    return 'Password doesn\'t match';
  } else if (confirmPassword?.isEmpty ?? true) {
    return 'Confirm password is required';
  } else {
    return null;
  }
}

//helper method to show progress
// late ProgressDialog progressDialog;
//
// showProgress(BuildContext context, String message, bool isDismissible) async {
//   progressDialog = ProgressDialog(context,
//       type: ProgressDialogType.Normal, isDismissible: isDismissible);
//   progressDialog.style(
//       message: message,
//       borderRadius: 10.0,
//       backgroundColor: kColorPrimary,
//       progressWidget: Container(
//         padding: const EdgeInsets.all(8.0),
//         child: const CircularProgressIndicator(
//           backgroundColor: Colors.white,
//           valueColor: AlwaysStoppedAnimation(kColorPrimary),
//         ),
//       ),
//       elevation: 10.0,
//       insetAnimCurve: Curves.easeInOut,
//       messageTextStyle: const TextStyle(
//           color: Colors.white, fontSize: 19.0, fontWeight: FontWeight.w600));
//   await progressDialog.show();
// }

// updateProgress(String message) {
//   progressDialog.update(message: message);
// }

// hideProgress() async {
//   await progressDialog.hide();
// }

//helper method to show alert dialog
showAlertDialog(BuildContext context, String title, String content) {
  // set up the AlertDialog
  Widget okButton = TextButton(
    child: const Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  AlertDialog alert = AlertDialog(
    title: Text(title),
    content: Text(content),
    actions: [
      okButton,
    ],
  );

  // show the dialog
  // showDialog(
  //   context: context,
  //   builder: (BuildContext context) {
  //     return alert;
  //   },
  // );
}

pushReplacement(BuildContext context, Widget destination) {
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => destination));
}

push(BuildContext context, Widget destination) {
  Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => destination));
}

pushAndRemoveUntil(BuildContext context, Widget destination, bool predict) {
  Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => destination),
          (Route<dynamic> route) => predict);
}

Widget displayCircleImage(String picUrl, double size, hasBorder) =>
    CachedNetworkImage(
        imageBuilder: (context, imageProvider) =>
            _getCircularImageProvider(imageProvider, size, false),
        imageUrl: picUrl,
        placeholder: (context, url) =>
            _getPlaceholderOrErrorImage(size, hasBorder),
        errorWidget: (context, url, error) =>
            _getPlaceholderOrErrorImage(size, hasBorder));

Widget _getPlaceholderOrErrorImage(double size, hasBorder) => Container(
  width: size,
  height: size,
  decoration: BoxDecoration(
    color: const Color(0xff7c94b6),
    borderRadius: BorderRadius.all(Radius.circular(size / 2)),
    border: Border.all(
      color: Colors.white,
      width: hasBorder ? 2.0 : 0.0,
    ),
  ),
  child: ClipOval(
      child: Image.asset(
        'assets/images/placeholder.jpg',
        fit: BoxFit.cover,
        height: size,
        width: size,
      )),
);

Widget _getCircularImageProvider(
    ImageProvider provider, double size, bool hasBorder) {
  return ClipOval(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(size / 2)),
            border: Border.all(
              color: Colors.white,
              style: hasBorder ? BorderStyle.solid : BorderStyle.none,
              width: 1.0,
            ),
            image: DecorationImage(
              image: provider,
              fit: BoxFit.cover,
            )),
      ));
}

bool isDarkMode(BuildContext context) {
  if (Theme.of(context).brightness == Brightness.light) {
    return false;
  } else {
    return true;
  }
}

InputDecoration getInputDecoration(
    {required String hint, required bool darkMode, required Color errorColor}) {
  return InputDecoration(
    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
    fillColor: darkMode ? Colors.black54 : Colors.white,
    hintText: hint,
    focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25.0),
        borderSide: const BorderSide(color: AppTheme.secondary, width: 2.0)),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius: BorderRadius.circular(25.0),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: errorColor),
      borderRadius: BorderRadius.circular(25.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey.shade200),
      borderRadius: BorderRadius.circular(25.0),
    ),
  );
}

showSnackBar(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
}

Widget homeTitle(String title,GestureTapCallback press,context){
  var we = MediaQuery.of(context).size.width;
  var he = MediaQuery.of(context).size.height;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 18.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              title,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: we * .055,
                color: Colors.white
              ),
            ),
            SizedBox(width:  we * .01,),
           // Image.asset("assets/images/food-delivery.png",height: he *.03,)
          ],
        ),

        GestureDetector(
          onTap: press,
          child: Text(
            LocaleKeys.see_all.tr(),
            style: TextStyle(color: AppTheme.white, fontSize: we * .04,fontWeight: FontWeight.bold,),
          ),
        ),
      ],
    ),
  );
}
Future showDialogBranch(context,String title,bool fromHome,homeContext,  List<BranchModel> branches) async {
  await showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      var we = MediaQuery.of(context).size.width;
      var he = MediaQuery.of(context).size.height;
      return AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: he*.02,),
                  Text( title,
                    style: TextStyle(
                      color: AppTheme.nearlyBlack,
                      fontSize: we * .06,
                      height: he *.002,
                      fontWeight:
                      FontWeight.bold,
                    ),),
                  SizedBox(height: he*.02,),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:
                  branches.map((e) {
                      return  InkWell(
                        onTap: (){
                          if(LocalStorage.getData(key: "branchId") != e.id){
                            LocalStorage.removeData(key: "cart");
                            SingleProductCubit.cartCount =0;
                          }

                          if(e.statusNo ==1){

                            LocalStorage.saveData(key: "branchId", value: e.id);
                            LocalStorage.saveData(key: "branchLat", value: e.lat);
                            LocalStorage.saveData(key: "branchLong", value: e.long);
                          if(!fromHome){
                            pushReplacement(context,
                              BottomNavBar(branches: branches,fromSplash: true,),
                            );
                          }else{
                            Navigator.pop(context);
                            BlocProvider.of<DepartmentsCubit>(homeContext).getDepartments(context,context.locale.toString());
                            BlocProvider.of<HomeAdCubit>(homeContext).getAds();
                          }}else{
                            showDialogBranchClosed(context, context.locale.toString() == 'ar'?e.statusAr.toString() : e.statusEn.toString(),false);
                          }

                          // )
                        },
                        child: Container(
                          //height:  he *.08,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical:  he *.02,horizontal: 10),
                          color:e.id == LocalStorage.getData(key: "branchId")?AppTheme.secondary.withOpacity(.5) : Colors.transparent,
                          child: Center(
                            child: Text( e.title!.en.toString(),
                              style: TextStyle(
                                color: AppTheme.nearlyBlack,
                                fontSize: we * .05,
                                height: he *.002,
                               // fontWeight:
                               // FontWeight.bold,
                              ),),
                          ),
                        ),
                      );
                    }).toList()
                 //   ],
                  ),
              //    SizedBox(height: he*.02,),

                ],
              ),
            );
          },
        ),
      );
    },
  );
}


Future showDialogBranchClosed(context,String title,bool fromHome) async {
  await showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      var we = MediaQuery.of(context).size.width;
      var he = MediaQuery.of(context).size.height;
      return WillPopScope(
        onWillPop: (){
          return Future.value(false);
        },
        child: AlertDialog(
          scrollable: true,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      //SizedBox(height: he*.02,),
                      Image.asset("assets/images/sad.gif",height: he * .25,),
                      Text( title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppTheme.nearlyBlack,
                          fontSize: we * .05,
                          height: he *.002,
                          fontWeight:
                          FontWeight.bold,
                        ),),
                      SizedBox(height: he*.04,),
                      DefaultButton(
                        title: LocaleKeys.anther_branch.tr(),
                        font:   we * .05,
                        function: (){
                          if(fromHome == false)
                            {
                              Navigator.pop(context);
                              Navigator.pop(context);

                            }else{
                            pushReplacement(context,   BlocProvider(
                                create: (BuildContext context) =>
                                    BranchesCubit(GetBranchesRepository()),
                                child:LocationActivate()));
                          }

                                           },
                        color: Colors.red,
                        textColor: Colors.white,
                        height: he * .07,
                        radius: 15,
                      ),
                         SizedBox(height: he*.02,),

                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
    },
  );
}