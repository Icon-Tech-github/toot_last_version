import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/fav_bloc/fav_cubit.dart';
import 'package:loz/bloc/single_product_bloc/single_product_cubit.dart';
import 'package:loz/data/models/fav_model.dart';
import 'package:loz/data/repositories/single_product_repo.dart';
import 'package:loz/presentation/screens/product_details.dart';
import 'package:loz/presentation/screens/product_details1.dart';
import 'package:simple_shadow/simple_shadow.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import 'helper.dart';

class SingleFavWidget extends StatelessWidget {
  const SingleFavWidget(
      {Key? key,this.product, this.animationController, this.animation,this.startColor = "c31432",this.endColor="240b36",this.productState,this.colors,this.productIndex})
      : super(key: key);

  final FavoriteModel ?product;
  final AnimationController? animationController;
  final Animation<double>? animation;
  final FavoriteCubit? productState;
  final String? startColor ;
  final String? endColor ;
 final List<List<String>> ?colors;
 final int? productIndex;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    var lang = context.locale.toString();

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
                        create: (BuildContext context) => SingleProductCubit(SingleProductRepo(),product!.productId!,context,lang),
                        child: ProductDetails1(animationController: animationController,)));
              },
              child:    Stack(
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
                            SizedBox(height: size.height * .02,),
                            SizedBox(
                              width: size.width * .32,
                              child: Text( product?.product!.title!.en??'',
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
                            //    if(product!.description?.en != null)
                            //       Padding(
                            //         padding:
                            //         const EdgeInsets.only(top: 5, bottom: 8),
                            //         child: Container(
                            //           width: size.width * .31,
                            //           child: Text(product!.description!.en.toString(),
                            //             overflow: TextOverflow.ellipsis,
                            //             style: TextStyle(
                            //               height:  size.height*0.0016,
                            //               fontWeight: FontWeight.w500,
                            //               fontSize: size.width * .032,
                            //               letterSpacing: 0.2,
                            //               color: AppTheme.grey,
                            //             ),
                            //           ),
                            //         ),
                            //       ),
                            //   if(product!.description?.en == null)
                            SizedBox(height: 6,),
                            Text(
                               "${LocaleKeys.PER.tr()}  ${product!.product!.unit!.title!.en}",
                              style: TextStyle(
                                fontSize: size.width * .035,
                                height: size.height * .001,
                                color: AppTheme.orange,
                                //   letterSpacing: 5
                              ),
                            ),
                            SizedBox(height: 6,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  children: [
                                    SizedBox(
                                      // width: size.width * .2,
                                      child: Text(
                                        product!.product!.newPrice!=0?
                                        product!.product!.newPrice!.toStringAsFixed(2)+' '+LocaleKeys.kwd.tr() :
                                        product!.product!.price!=0?  product!.product!.price!.toStringAsFixed(2)+' ' +LocaleKeys.kwd.tr():LocaleKeys.depends_on.tr(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          height:  size.height*0.001,
                                          fontWeight: FontWeight.bold,
                                          fontSize:   product!.product!.price!=0? size.width*0.037 : size.width*0.026,
                                          letterSpacing: 0.2,
                                          color: AppTheme.nearlyBlack,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: size.height * .006,),
                                    if( product!.product!.newPrice!=0)
                                      SizedBox(
                                        //   width: size.width * .2,
                                        child: Text(
                                          product!.product!.price!.toStringAsFixed(2)+' '+LocaleKeys.kwd.tr() ,
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
                                    productState!.favToggle(product!.productId!,context);
                                  },
                                  child: Container(
                                    width:  size.width * .1,
                                    height:  size.width * .1,
                                    decoration: BoxDecoration(
                                      color: AppTheme.nearlyWhite,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(product!.product!.inFavourite==1 ?Icons.favorite: Icons.favorite_border,size:  size.width * .06,color: product!.product!.inFavourite==1 ? AppTheme.secondary : Colors.black,),
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
                                  product!.product!.images != null?product!.product!.images!.image.toString():'',
                                  height: size.height * .16,
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
        //Stack(
//                 alignment: Alignment.center,
//
//                 children: <Widget>[
//                   Container(
//                     padding: const EdgeInsets.only(
//                         top: 23, left: 8, right: 8, bottom: 16),
//                     margin: EdgeInsets.only(top: 35),
//                     child: Container(
//                       width: size.width*0.4,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         boxShadow: <BoxShadow>[
//                           BoxShadow(
//                               color: Colors.grey
//                                   .withOpacity(0.3),
//                               offset: const Offset(1.1, 4.0),
//                               blurRadius: 8.0),
//                         ],
//
//                         borderRadius:  BorderRadius.circular(20),
//                       ),
//                       child: Padding(
//                         padding:  EdgeInsets.only(
//                             top: 90, left: 10, right: 10, bottom: 8),
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: <Widget>[
//                             //SizedBox(height: size.height * .01,),
//                             Text(
//                               product?.product!.title!.en??'',
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: size.width * .05,
//                                 height: size.height * .002,
//                                 letterSpacing: 0.2,
//                                 color: AppTheme.nearlyBlack,
//                               ),
//                             ),
//
//                             //  SizedBox(height: size.height * .01,),
// Spacer(),
//                               InkWell(
//                                 onTap: (){
//                                   productState!.favToggle(product!.productId!,context);
//                                 },
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                       color: AppTheme.secondary,
//                                       shape: BoxShape.circle,
//                                       boxShadow: <BoxShadow>[
//                                         BoxShadow(
//                                             color: AppTheme.nearlyBlack.withOpacity(.4),
//                                             offset:Offset(8.0,8.0),
//                                             blurRadius: 8
//                                         )
//                                       ]
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(6.0),
//                                     child: Icon(
//                                       Icons.star,
//                                       color: AppTheme.white,
//                                       size: 24,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             SizedBox(height: size.height * .005,),
//
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   Positioned(
//                     top: 0,
//                     child: Container(
//                       width: size.width * .32,
//                       child: Hero(
//                           tag:"1",
//                           //product!.id!,
//                           child:
//                           SimpleShadow(
//                             opacity: 0.4, // Default: 0.5
//                             color: Colors.black, // Default: Black
//                             offset: Offset(8, 8), // Default: Offset(2, 2)
//                             sigma: 8, // Default: 2
//                             child: Image.network(product!.product!.images!.image != null?product!.product!.images!.image.toString():''
//                             ),
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//
            ),
          ),
        );
      },
    );
  }
}