import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../theme.dart';
import '../../translations/locale_keys.g.dart';

class BranchesScreen extends StatefulWidget {
  const BranchesScreen({Key? key}) : super(key: key);

  @override
  _BranchesScreenState createState() => _BranchesScreenState();
}

class _BranchesScreenState extends State<BranchesScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: [

              Text( LocaleKeys.share_location.tr(),
                // product!.title!.en!,
                style: TextStyle(
                  height:  size.height*0.002,
                  fontWeight: FontWeight.bold,
                  fontSize: size.width * .08,
                  letterSpacing: 0.2,
                  color: AppTheme.nearlyBlack,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
