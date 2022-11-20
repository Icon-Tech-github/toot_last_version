
import 'package:flutter/material.dart';

import '../../local_storage.dart';
import '../../theme.dart';


class Menu extends StatelessWidget {
  const Menu({
    Key? key,
    required this.text,
    required this.icon,
    required this.press,
  }) : super(key: key);

  final String text;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        height: MediaQuery.of(context).size.height * .08,
        padding: EdgeInsets.all(20),
       decoration: BoxDecoration(
        color: Colors.white,
         borderRadius: BorderRadius.circular(10),
       ),
        //color: Colors.white,
        child: InkWell(
          onTap:press,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: AppTheme.secondary,
                    size: 22,
                  ),
                  SizedBox(width: 20),
                  Text(text,style: TextStyle(fontSize: MediaQuery.of(context).size.height * .023, height:   MediaQuery.of(context).size.height*0.002),),
                ],

              ),
              Icon(
                Icons.arrow_forward_ios,
                color: AppTheme.secondary,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
