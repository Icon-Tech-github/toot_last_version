import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/single_product_bloc/single_product_cubit.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/single_product_repo.dart';
import 'package:loz/presentation/screens/product_details.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:simple_shadow/simple_shadow.dart';

import '../../theme.dart';
import '../screens/product_details1.dart';
import 'helper.dart';
import 'hex_color.dart';

class SingleProductWidget extends StatelessWidget {
  const SingleProductWidget(
      {Key? key,this.product, this.animationController, this.animation,this.favScreen,this.startColor,this.endColor,required this.favToggle})
      : super(key: key);

  final ProductModel ?product;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final Function favToggle;

  final String? startColor;
  final String? endColor;
  final bool ? favScreen;

  @override
  Widget build(BuildContext context) {
    var lang = context.locale.toString();

    var size = MediaQuery.of(context).size;
    return AnimatedBuilder(
      animation: animationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: animation!,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation!.value), 0.0, 0.0),
            child: GestureDetector(
              onTap: (){
                push(context,
                    BlocProvider(
                        create: (BuildContext context) => SingleProductCubit(SingleProductRepo(),product!.id!,context,lang),
                        child: ProductDetails1(animationController: animationController,)));
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        top: 55, left: 8, right: 8, bottom: 16),
                    margin: EdgeInsets.only(top: 35),
                    child: Container(
                      width: size.width*0.42,
                    //  height: size.height * .5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                       boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.3),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],

                        borderRadius:  BorderRadius.only(
                          bottomRight: Radius.circular(7),
                          bottomLeft: Radius.circular(7),
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                            ),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            top: 56, left: 10, right: 10, bottom: 8),
                        child: Column(
                       //   mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[

                            SizedBox(
                              width: size.width * .32,
                              child: Text(product!.title!.en!,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  height:  size.height*0.0015,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * .041,
                                  letterSpacing: 0.2,
                                  color: AppTheme.secondary,
                                ),
                              ),
                            ),
                            SizedBox(height: 8,),
                            Text(
                              "${product!.unit!.title!.en}",
                              style: TextStyle(
                                fontSize: size.width * .035,
                                height: size.height * .001,
                                color: AppTheme.orange,
                                //   letterSpacing: 5
                              ),
                            ),
SizedBox(height: 5,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             // crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  children: [
                                    SizedBox(
                                    //  width: size.width * .2,
                                      child: Text(
                                        product!.newPrice!=0?
                                       product!.newPrice!.toStringAsFixed(2)+' '+LocaleKeys.kwd.tr() :
         product!.price!=0?  product!.price.toStringAsFixed(2)+' ' +LocaleKeys.kwd.tr():LocaleKeys.depends_on.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height:  size.height*0.002,
                                          fontWeight: FontWeight.bold,
                                          fontSize:   product!.price!=0? size.width*0.037 : size.width*0.026,
                                         // letterSpacing: 0.2,
                                          color: AppTheme.nearlyBlack,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * .006,),
                                    if( product!.newPrice!=0)
                                    SizedBox(
                                   //   width: size.width * .2,
                                      child: Text(
                                        product!.price!.toStringAsFixed(2)+' '+LocaleKeys.kwd.tr() ,
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          height:  size.height*0.001,
                                          fontWeight: FontWeight.bold,
                                          fontSize: size.width*0.03 ,
                                          letterSpacing: 0.2,
                                          color: AppTheme.orange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                           //     Spacer(),
                                GestureDetector(
                                  onTap: (){
                                    return favToggle();
                                  },
                                  child: Container(
                                    width:  size.width * .1,
                                    height:  size.width * .1,
                                    decoration: BoxDecoration(
                                      color: AppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(product!.inFavourite==1 ?Icons.favorite: Icons.favorite_border,size:  size.width * .06,color: product!.inFavourite==1 ? AppTheme.secondary : Colors.black,),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          height:  size.height * .14,
                          width: size.width * .42,
                          margin: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Color(0xffe3dceb),
                            borderRadius:  BorderRadius.only(
                              topLeft: Radius.circular(size.width * .32),
                              topRight: Radius.circular(size.width * .32),
                            ),
                          ),
                        ),
                        Center(
                          child: Hero(
                              tag: product!.id.toString(),
                              child:
                              SimpleShadow(
                                opacity: 0.4, // Default: 0.5
                                color: Colors.black, // Default: Black
                                offset: Offset(8, 8), // Default: Offset(2, 2)
                                sigma: 8, // Default: 2
                                child: Image.network(
                                  //"assets/fitness_app/foood.png",
                                    product!.images != null?product!.images!.image.toString():'',
                                  height: size.height * .16,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}