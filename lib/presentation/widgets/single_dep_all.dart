import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/single_product_bloc/single_product_cubit.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/single_product_repo.dart';
import 'package:loz/presentation/screens/product_details.dart';
import 'package:simple_shadow/simple_shadow.dart';


import '../../bloc/home/departments_bloc/departments_cubit.dart';
import '../../bloc/products_bloc/products_cubit.dart';
import '../../data/repositories/products_repo.dart';
import '../../theme.dart';
import '../screens/products.dart';
import 'helper.dart';

class SingleDepAllWidget extends StatelessWidget {
  const SingleDepAllWidget(
      {Key? key,this.category, this.animationController, this.animation,this.favScreen,this.startColor,this.endColor,this.categories,this.productsAnimationController,required this.depIndex})
      : super(key: key);

  final CategoryModel ?category;
  final List<CategoryModel> ?categories;
  final AnimationController? animationController;
  final AnimationController ?productsAnimationController;
  final int depIndex;
  final Animation<double>? animation;

  final String? startColor;
  final String? endColor;
  final bool ? favScreen;

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
                DepartmentsCubit.activeId = category!.id;
                push(
                    context,
                    BlocProvider(
                        create: (BuildContext context) =>
                            ProductsCubit(ProductsRepo(),category!.id!,context,lang),
                        child: ProductScreen(animationController: productsAnimationController,id: category!.id,depName: category!.title!.en,departments: categories,keyIndex: DepartmentsCubit.formKeyList[depIndex!],)));
              },
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        top: 0, left: 0, right: 0, bottom: 0),
                    margin: EdgeInsets.only(top: 20),
                    child: Container(
                      width: size.width*0.38,
                      height: size.height * .5,
                      decoration: BoxDecoration(
                        color: AppTheme.white,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey
                                  .withOpacity(0.3),
                              offset: const Offset(1.1, 4.0),
                              blurRadius: 8.0),
                        ],

                        borderRadius:  BorderRadius.circular(20),
                      ),
                      child: Padding(
                        padding:  EdgeInsets.only(
                            top: 5, left: 10, right: 10, bottom: 0),
                        child: Column(
                          //   mainAxisAlignment: MainAxisAlignment.center,
                           crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              width: size.width * .33,
                            //  padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:  BorderRadius.circular(20),
                              ),
                              child: ClipRRect(
                                borderRadius:  BorderRadius.circular(20),
                                child: Hero(
                                    tag:category!.id.toString(),
                                    //product!.id!,
                                    child:
                                    Image.network(category!.image!.isNotEmpty?category!.image.toString():'',
                                    //  height: size.width * .33,
                                    //  width: size.width * .32,
                                    )),
                              ),
                            ),
                            SizedBox(height: size.height *.01,),
                            SizedBox(
                              width: size.width * .32,
                              child: Text(category!.title!.en!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  height:  size.height*0.002,
                                  fontWeight: FontWeight.bold,
                                  fontSize: size.width * .044,
                                  letterSpacing: 0.2,
                                  color: AppTheme.nearlyBlack,
                                ),
                              ),
                            ),


                          ],
                        ),
                      ),
                    ),
                  ),
                  // Positioned(
                  //   top: 0,
                  //   child: Container(
                  //     width: size.width * .32,
                  //     child: Hero(
                  //         tag:category!.id.toString(),
                  //         //product!.id!,
                  //         child:
                  //         SimpleShadow(
                  //           opacity: 0.4, // Default: 0.5
                  //           color: Colors.black, // Default: Black
                  //           offset: Offset(10, 10), // Default: Offset(2, 2)
                  //           sigma: 8, // Default: 2
                  //           child: Image.network(category!.image!.isNotEmpty?category!.image.toString():''
                  //           ),
                  //         )),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}