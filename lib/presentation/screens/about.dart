import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/about_bloc/about_cubit.dart';
import 'package:loz/translations/locale_keys.g.dart';

import '../../theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: AppTheme.background,
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: size.height * .01,
              ),
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
                    Text(
                      LocaleKeys.about.tr(),
                      style: TextStyle(
                        fontSize: size.width * .06,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // SizedBox(width: 60,),
                  ],
                ),
              ),
              BlocBuilder<AboutCubit, AboutState>(builder: (context, state) {
                if (state is AboutLoading) {
                  return Center(
                    child: Container(
                      height: size.height * 0.4,
                      width: size.width * 0.5,
                      alignment: Alignment.bottomCenter,
                      child: const LoadingIndicator(
                        indicatorType: Indicator.ballPulse,
                        colors: const [
                          AppTheme.nearlyDarkBlue,
                          AppTheme.secondary,
                          AppTheme.nearlyBlue,
                        ],
                        strokeWidth: 3,
                        backgroundColor: Colors.transparent,
                        pathBackgroundColor: Colors.white,
                      ),
                    ),
                  );
                }
                if (state is AboutLoaded) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0),
                    child: Html(data: state.about.data),
                  );
                }
                return SizedBox();
              }),
            ],
          ),
        ));
  }
}
