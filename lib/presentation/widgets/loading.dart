import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../../theme.dart';



class LoadingWidget extends StatelessWidget {
  final Indicator indicator;
//  final Color color;

  const LoadingWidget({
    this.indicator = Indicator.ballClipRotateMultiple,
 //   this.color = kColorPrimary,
  });

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        width: 150,
        height: 150,
        child: Image.asset(
          "assets/images/logo.png",
        ),

//todo
//         LoadingIndicator(sss
// //          indicatorType: indicator,
//           indicatorType: indicator,
//           color: Color(0xFF0081B0),
// //          color: Colors.red,
//         ),
      ),
    );
  }
}

class LoadingScreen {
  LoadingScreen._();

  static show(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 50,
                  width: 100,
                  child:LoadingIndicator(
                    indicatorType: Indicator.ballPulse,
                    colors: const [AppTheme.nearlyDarkBlue,
                      AppTheme.secondary,
                      AppTheme.nearlyBlue,
                    ],
                    strokeWidth: 3,
                    backgroundColor: Colors.transparent,
                    pathBackgroundColor: Colors.white  ,

                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
