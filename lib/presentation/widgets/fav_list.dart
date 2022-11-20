
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/auth_bloc/auth_cubit.dart';
import 'package:lottie/lottie.dart'as lottie;

import 'package:loz/bloc/fav_bloc/fav_cubit.dart';
import 'package:loz/bloc/products_bloc/products_cubit.dart';
import 'package:loz/data/models/fav_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/auth_repo.dart';
import 'package:loz/presentation/screens/Auth_screens/login.dart';
import 'package:loz/presentation/widgets/single_fav.dart';

import 'package:loz/presentation/widgets/single_product.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../local_storage.dart';
import '../../theme.dart';
import 'default_button.dart';
import 'helper.dart';



class FavListView extends StatefulWidget {
  const FavListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation,this.startColor,this.endColor,required this.products,this.productState,this.depId,this.depName,this.colors})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? startColor;
  final String? endColor;
  final List<FavoriteModel> products;
  final FavoriteCubit? productState;
  final int ? depId ;
  final String ?depName;
 final List<List<String>> ?colors;


  @override
  _FavListViewState createState() => _FavListViewState();
}

class _FavListViewState extends State<FavListView>
    with TickerProviderStateMixin {
  AnimationController? animationController;


  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }


  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child:
      SmartRefresher(
        header: WaterDropHeader(),

        controller: widget.productState!.controller,
        onLoading: (){
          widget.productState!.onLoad();
        },
        enablePullUp: true,
        enablePullDown: false,
        child: ListView(
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
                    //     icon:  Icon(
                    //       Icons.arrow_back_ios,
                    //       size: size.width * .08,
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
              LocalStorage.getData(key: 'token')== null?
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height *.3,),
                    Text(
                      LocaleKeys.sign_in_to_make.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        //  fontWeight: FontWeight.bold,
                          fontSize: size.height *.033,
                          height:  size.height*0.002,
                          color: Colors.white),
                    ),
                    SizedBox(height: size.height *.02,),
                    DefaultButton(
                      height: size.height * .07,
                      font: size.width * .055, radius: 15,
                      title: LocaleKeys.sign_in.tr(),
                      color: AppTheme.orange,
                      textColor: Colors.white,
                      width: size.width * .5,
                      function: (){
                        push(context,  BlocProvider(
                            create: (BuildContext context) =>
                                AuthCubit(AuthRepo()),
                            child: Login()));
                      },
                    )
                  ],
                ),
              ):
              widget.products.length ==0?
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: size.height *.11,),
                    lottie.Lottie.asset(
                        'assets/images/fav.json',
                        height: size.height *.3,
                        width: 400),
                    SizedBox(height: size.height *.02,),
                    Text(
                      LocaleKeys.empty_fav.tr(),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: size.height *.033,
                          color: Colors.white),
                    )
                  ],
                ),
              ):
              AnimatedBuilder(
                animation: widget.mainScreenAnimationController!,
                builder: (BuildContext context, Widget? child) {
                  return FadeTransition(
                    opacity: widget.mainScreenAnimation!,
                    child: Transform(
                      transform: Matrix4.translationValues(
                          0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                      child: Container(
                        //  height: 400,
                        width: double.infinity,
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 0.7),
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 0, right: 4, left: 4),
                          itemCount: widget.products.length,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (BuildContext context, int index) {
                            final int count =
                            widget.products.length > 10 ? 10 : widget.products.length;
                            final Animation<double> animation =
                            Tween<double>(begin: 0.0, end: 1.0).animate(
                                CurvedAnimation(
                                    parent: animationController!,
                                    curve: Interval((1 / count) * index, 1.0,
                                        curve: Curves.fastOutSlowIn)));
                            animationController?.forward();

                            return Center(
                              child: SingleFavWidget(
                                colors: widget.colors,
                                productIndex: index,
                                animation: animation,
                                startColor: "c31432",
                                endColor: "240b36",
                                animationController: animationController!,
                                product: widget.products[index],
                                productState: widget.productState,

                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ]
        ),
      ),
    );
  }
}


