import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';


class StepsNavBar extends StatelessWidget {
  int? index;
  List<int> status;
  StepsNavBar({this.index,required this.status});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Row(
           children: [
              Container(
                height: size.height * .06,
                width: size.height * .06,
                decoration: BoxDecoration(
                  color: status.contains(1) ? AppTheme.secondary : Colors.grey,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.white),
                ),
                child:  Center(
                    child: Image.asset("assets/images/sent.png",height: size.height * .034,color:status.contains(1) ?Colors.white:AppTheme.secondary,
                )),
              ),
              SizedBox(width: size.width * .04,),
              Text(
                LocaleKeys.order_sent.tr(),
                style: TextStyle(fontSize: size.width * .05, color: Colors.black,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height: size.width * 0.09,
            width: 2,
            color:status.contains(2) ? AppTheme.secondary: Colors.black12,
          ),
          ////////////////////////////////////
          Row(
            children: [
              Container(
                  height: size.height * .06,
                  width: size.height * .06,
                decoration: BoxDecoration(
                  color: status.contains(2) ? AppTheme.secondary : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.white),
                ),
                child: Center(
                    child: Image.asset("assets/images/bag.png",height: size.height * .034,color: status.contains(2) ?Colors.white:AppTheme.secondary,

    )) ),
              SizedBox(width: size.width * .04,),
              Text(
                LocaleKeys.order_accept.tr(),
                style: TextStyle(fontSize: size.width * .05, color: Colors.black,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),

            height:  size.width * 0.09,
            width:2,
            color: status.contains(3)? AppTheme.secondary : Colors.black12,
          ),
          ///////////////////////////////////////
          Row(
            children: [
              Container(
                height: size.height * .06,
                width: size.height * .06,
                decoration: BoxDecoration(
                  color: status.contains(3) ? AppTheme.secondary : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.white),
                ),
                  child: Center(
                    child: Image.asset("assets/images/bagg.png",height: size.height * .034,color:status.contains(3) ?Colors.white:AppTheme.secondary,

                      ),
                  ),
              ),
              SizedBox(width: size.width * .04,),
              Text(
                LocaleKeys.on_the_way.tr(),
                style: TextStyle(fontSize: size.width * .05, color: Colors.black,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),
            height:  size.width * 0.09,
            width:2,
            color:status.contains(7) ? AppTheme.secondary : Colors.black12,
          ),
          ///////////////////////////////////////
          Row(
            children: [
              Container(
                height:  size.height * .06,
                width:  size.height * .06,
                decoration: BoxDecoration(
                  color: status.contains(7)? AppTheme.secondary : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.white),
                ),
                child: Center(
                    child: Image.asset("assets/images/success.png",height: size.height * .034,color: status.contains(7) ?Colors.white:AppTheme.secondary,
                    )),
              ),
              SizedBox(width: size.width * .04,),
              Text(
                LocaleKeys.Done.tr(),
                style: TextStyle(fontSize: size.width * .05, color: Colors.black,fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          // Container(
          //   height: 2,
          //   width: size.width * 0.1,
          //   color: index! >= 5 ? AppTheme.orange : Colors.black12,
          // ),
          ///////////////////////////////////////
          // Container(
          //   height: 40,
          //   width: 40,
          //   decoration: BoxDecoration(
          //     color: index == 5 ? AppTheme.orange : Colors.white,
          //     shape: BoxShape.circle,
          //     border: Border.all(width: 0.5, color: Colors.white),
          //   ),
          //   child: Center(
          //     child: Image.asset("assets/images/food-serving.png",height: size.height * .04,color: index! >= 3 ?Colors.white:AppTheme.orange,
          //     )),
          // ),
        ],
      ),
    );
  }
}
