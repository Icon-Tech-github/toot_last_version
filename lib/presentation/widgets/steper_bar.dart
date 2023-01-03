import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loz/data/models/status.dart';
import 'package:loz/theme.dart';
import 'package:loz/translations/locale_keys.g.dart';


class StepsNavBar extends StatelessWidget {
  List<StatusDataModel> statusData;
  List<int> status;
  StepsNavBar({required this.statusData,required this.status});

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
              SizedBox(
                width: size.width * .6,

                child: Text(
                 statusData[0].title!.en.toString(),
                  style: TextStyle(fontSize: size.width * .05, color: Colors.black,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
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
              SizedBox(
                width: size.width * .6,
                child: Text(
                  statusData[1].title!.en.toString(),
                  style: TextStyle(fontSize: size.width * .05, color: Colors.black,fontWeight: FontWeight.bold,height: size.height * .002),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20),

            height:  size.width * 0.09,
            width:2,
            color: status.contains(3) ||  status.contains(5)? AppTheme.secondary : Colors.black12,
          ),
          ///////////////////////////////////////
          Row(
            children: [
              Container(
                height: size.height * .06,
                width: size.height * .06,
                decoration: BoxDecoration(
                  color: status.contains(3) ||  status.contains(5)? AppTheme.secondary : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  border: Border.all(width: 0.5, color: Colors.white),
                ),
                  child: Center(
                    child:statusData[2].id == 5? Image.asset("assets/images/way.png",height: size.height * .034,color:status.contains(3) ||  status.contains(5)?Colors.white:AppTheme.secondary,)
                        :Image.asset("assets/images/bagg.png",height: size.height * .034,color:status.contains(3) ||  status.contains(5)?Colors.white:AppTheme.secondary,)
                  ),
              ),
              SizedBox(width: size.width * .04,),
              SizedBox(
                width: size.width * .6,
                child: Text(
                  statusData[2].title!.en.toString(),
                  style: TextStyle(fontSize: size.width * .05, color: Colors.black,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
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
              SizedBox(
                width: size.width * .6,

                child: Text(
                  statusData[3].title!.en.toString(),
                  style: TextStyle(fontSize: size.width * .05, color: Colors.black,fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
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
