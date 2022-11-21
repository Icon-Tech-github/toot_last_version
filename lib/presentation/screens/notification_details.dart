
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:loz/data/models/notification.dart';
import 'package:loz/translations/locale_keys.g.dart';

import '../../theme.dart';


class NotificationDetails extends StatelessWidget {
  const NotificationDetails({Key? key, required this.notification}) : super(key: key);
  final  NotificationData notification;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Column(
        children: [
          SizedBox(height: size.height * .02,),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 9),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 28,
                      color: AppTheme.secondary,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 5, horizontal: 9),
                  child: Text(
                    LocaleKeys.notifications.tr(),
                    style: TextStyle(
                      fontSize: size.width * .07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // SizedBox(width: 60,),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: notification.image!=null?
              Image.network(
                notification.image.toString(),
                fit: BoxFit.fill,
                height: 250,
                width: double.infinity,
              ):
              Image.asset(
              "assets/images/toot.png",
              fit: BoxFit.fill,
              height: 250,
              width:
              double.infinity,
            ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Text(notification.title!.en.toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20
              ),
            ),
          ),
          Padding(
            padding:  EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(notification.description!.en.toString(),
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
