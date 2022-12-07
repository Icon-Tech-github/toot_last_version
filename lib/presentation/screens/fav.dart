import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/fav_bloc/fav_cubit.dart';
import 'package:loz/data/models/fav_model.dart';
import 'package:loz/data/repositories/fav_reoo.dart';

import 'package:loz/presentation/widgets/fav_list.dart';
import 'package:loz/translations/locale_keys.g.dart';

import '../../theme.dart';



class FavoriteScreen extends StatelessWidget {

  const FavoriteScreen({Key? key, this.animationController,this.id,this.endColor,this.startColor,this.depName}) : super(key: key);
  final AnimationController? animationController;
  final int ? id;
  final  String? startColor;
  final String ? endColor;
  final String ? depName;


  @override
  Widget build(BuildContext context) {

    return Container(
     // color: AppTheme.background,
      child: Scaffold(
       // backgroundColor: Colors.transparent,
        body:
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.lightSec,
                  AppTheme.secondary,
                ],
                begin: Alignment.topCenter,
                end: Alignment.centerLeft,
              ),
            ),
            child:
            GetAppBarUi(animationController: animationController,id: id,startColor: startColor,endColor: endColor,depName: depName,)),
      ),
    );
  }


}


class GetAppBarUi extends StatefulWidget {
  const GetAppBarUi({Key? key, this.animationController,this.id,this.startColor,this.endColor,this.depName}) : super(key: key);
  final AnimationController? animationController;
  final int ? id;
  final  String? startColor;
  final String ? endColor;
  final String ? depName;

  @override
  _GetAppBarUiState createState() => _GetAppBarUiState();
}

class _GetAppBarUiState extends State<GetAppBarUi> {

  Animation<double>? topBarAnimation;

  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  bool ActiveConnection = true;
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;

        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });
    }
  }
  @override
  void initState() {
CheckUserConnection();
    widget.animationController?.forward();
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  ActiveConnection?
      Stack(
      children: [
        BlocProvider<FavoriteCubit>(
            create: (BuildContext context) => FavoriteCubit(FavoriteRepo()),
            child: FavoriteList(animationController:widget.animationController ,startColor: widget.startColor,endColor: widget.endColor,id: widget.id,depName: widget.depName,))
      ],
    )
        : Container(
      height: MediaQuery.of(context).size.height,
      width:  MediaQuery.of(context).size.width,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assets/images/off.gif"),
          Text(
            LocaleKeys.offline_translate.tr(),
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ],
      ),
    );
  }
}

class FavoriteList extends StatelessWidget {
  const FavoriteList({Key? key, this.animationController,this.endColor,this.startColor,this.id,this.depName}) : super(key: key);
  final AnimationController? animationController;
  final  String? startColor;
  final String ? endColor;
  final int ? id;
  final String ?depName;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return
      BlocBuilder<FavoriteCubit, FavoriteState>(

        builder: (context, state) {
          if (state is FavoriteLoading && state.isFirstFetch) {
            return Center(
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: size.height *.02,),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        children: [
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       vertical: 5, horizontal: 9),
                          //   child: IconButton(
                          //     icon: const Icon(
                          //       Icons.arrow_back_ios,
                          //       size: 28,
                          //       color: AppTheme.secondary,
                          //     ),
                          //     onPressed: () {
                          //       Navigator.of(context).pop();
                          //     },
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 9),
                            child: Text(
                              LocaleKeys.my_favourite.tr(),
                              style: TextStyle(
                                fontSize: size.width * .07,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                          // SizedBox(width: 60,),
                        ],
                      ),
                    ),
                    Container(
                      height: size.height * 0.4,
                      width: size.width * 0.5,
                      alignment: Alignment.bottomCenter,
                      child: LoadingIndicator(
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
                  ],
                ),
              ),
            );
          }
          List<FavoriteModel> products = [];
          bool isLoading = false;

          if (state is FavoriteLoading) {
            products = state.OldProducts;
            isLoading = true;
          } else if (state is FavoriteLoaded) {
            products = state.products;
          }

          FavoriteCubit productState = context.read<FavoriteCubit>();

          return FavListView(
            colors: productState.colors,
            // depName: depName,
            depId: id,
            productState: productState,
            startColor: startColor,
            endColor: endColor,
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: animationController!,
                    curve: Interval((1 / 5) * 3, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: animationController,
            products: products,

          );


          return SizedBox();
        }
    );

  }
}

