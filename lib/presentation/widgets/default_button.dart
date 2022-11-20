import 'package:flutter/material.dart';

class DefaultButton extends StatelessWidget {
  final String? title;
  final Function? function;
  final Color ?color;
  final Color ?textColor;
  final double  radius;
  final double font;
  final double? width;
  final double ? height;
  final Color ? borderColor;
  final bool ? isLoad;

  const DefaultButton(
      {Key? key,
        required this.font,
        this.title,
        this.function,
        this.color,
        this.textColor,
        this.height,
        this.width,
        this.borderColor,
        this.isLoad = false,
        required this.radius})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    return SizedBox(
      height: height ?? MediaQuery.of(context).size.height *.06,
      //height:  MediaQuery.of(context).size.height * 01,
      width:width?? MediaQuery.of(context).size.width *.8,
      child: TextButton(
        onPressed: () {
          return function!();
        },

        style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          primary: textColor,
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            side:  BorderSide(color: borderColor ?? Colors.transparent), //,
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child:
        isLoad!?
            CircularProgressIndicator(color: Colors.white,strokeWidth: 2,):
        Text(
          title!,
          style: TextStyle(
            height:  MediaQuery.of(context).size.height*0.001,
            //  fontWeight: FontWeight.bold,
            fontSize: font,),
        ),
      ),
    );
  }
}
