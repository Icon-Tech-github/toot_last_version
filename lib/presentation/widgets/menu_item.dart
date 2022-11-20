
import 'package:flutter/material.dart';

import '../../local_storage.dart';
import '../../theme.dart';


class MenuWidget extends StatelessWidget {
  const MenuWidget({
    Key? key,
    required this.text,
    required this.image,
    required this.press,
  }) : super(key: key);

  final String text;
  final String image;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Container(
        height: MediaQuery.of(context).size.height * .15,
        width:  MediaQuery.of(context).size.width * .45,
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          boxShadow: <BoxShadow>[
            BoxShadow(
                color: Colors.black
                    .withOpacity(0.2),
                offset: const Offset(1.1, 2.0),
                blurRadius: 8.0),
          ],
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        //color: Colors.white,
        child: InkWell(
          onTap:press,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                image,
                height:  MediaQuery.of(context).size.height * .05,
              ),
              SizedBox(height: 20),
              Text(text,style: TextStyle(fontSize: MediaQuery.of(context).size.height * .022, height:   MediaQuery.of(context).size.height*0.0015,fontWeight: FontWeight.bold),),
            ],

          ),
        ),
      ),
    );
  }
}
