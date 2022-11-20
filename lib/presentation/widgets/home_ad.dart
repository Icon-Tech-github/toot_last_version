import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/single_product_bloc/single_product_cubit.dart';
import 'package:loz/data/models/home_ad_model.dart';
import 'package:loz/data/repositories/single_product_repo.dart';
import 'package:loz/presentation/screens/product_details.dart';
import 'package:skeletons/skeletons.dart';

import '../../theme.dart';
import '../screens/product_details1.dart';
import 'helper.dart';

class HomeAd extends StatelessWidget {

  final AnimationController? animationController;
  final Animation<double>? animation;
  List<HomeAdModel> ?ads;

   HomeAd({Key? key,
     this.animationController, this.animation,
     this.ads})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    Size size =MediaQuery.of(context).size;
    var lang = context.locale.toString();

    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child:  Transform(
            transform: new Matrix4.translationValues(
                0.0, 30 * (1.0 - animation!.value), 0.0),
            child: InkWell(
              child: CarouselSlider(
                  items: ads!.map((e) {
                    return InkWell(
                      onTap: (){
                        push(context,
                            BlocProvider(
                                create: (BuildContext context) => SingleProductCubit(SingleProductRepo(),e.id!,context,lang),
                                child: ProductDetails1(animationController: animationController)));
                      },
                      child: Container(
                        width: size.width*0.85,
                        child: Card(
                       elevation: 0,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(color: Colors.transparent, width: 1),
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child:  ClipRRect(
                            borderRadius:  BorderRadius.circular(10),
                            child:   CachedNetworkImage(
                              imageUrl: e.image.toString(),
                              fit: BoxFit.fill,
                            //  height: size.height * .18,
                              //width: double.infinity,
                              placeholder: (context, url) => SkeletonAvatar(
                                style:  SkeletonAvatarStyle(
                                 // width: size.width *.65,
                                  //height: size.height * .18,
                                  borderRadius:  BorderRadius.circular(10),
                                  // padding:  const EdgeInsets.symmetric(
                                  //     vertical: 5.0, horizontal: 5),
                                ),
                              ),
                            ),
                          ),
                        ),
                  ),
                      ),
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: size.height*0.22,
                    initialPage: 0,
                    enableInfiniteScroll: true,
                    reverse: false,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: 5),
                    autoPlayAnimationDuration: Duration(seconds: 1),
                    autoPlayCurve: Curves.fastOutSlowIn,
                    enlargeCenterPage: true,
                    scrollDirection: Axis.horizontal,
                  )


              ),
            ),
          ),
        );
      },
    );
  }
}
