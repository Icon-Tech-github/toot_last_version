import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/products_bloc/products_cubit.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/repositories/products_repo.dart';
import 'package:loz/presentation/screens/products.dart';

import '../../theme.dart';
import 'helper.dart';
import 'hex_color.dart';

class SingleDepartmentWidget extends StatelessWidget {
   SingleDepartmentWidget(
      {Key? key,this.department, this.animationController, this.animation,this.favScreen,this.colors,this.depIndex,this.productsAnimationController, this.departments})
      : super(key: key);

  final CategoryModel ?department;
  final List<CategoryModel> ?departments;
  final AnimationController? animationController;
  final AnimationController ?productsAnimationController;
  final Animation<double>? animation;
  final bool ? favScreen;
  List<List<String>> ?colors;
  int? depIndex;


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
                DepartmentsCubit.activeId = department!.id;
                push(
                    context,
                    BlocProvider(
                        create: (BuildContext context) =>
                            ProductsCubit(ProductsRepo(),department!.id!,context,lang),
                        child: ProductScreen(animationController: productsAnimationController,id: department!.id,startColor: colors![depIndex!][0],endColor: colors![depIndex!][1],depName: department!.title!.en,departments: departments,)));
              },
              child: Column(
                children: [
                  Container(
                  //  color: depIndex ==1? Colors.yellow:Colors.green,
             width: size.width * .3,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        //shape: BoxShape.circle,
                        // image: new DecorationImage(
                        //   fit: BoxFit.cover,
                        //   image: AssetImage("assets/images/food3.jpg"),
                        // ),
                        borderRadius: BorderRadius.circular(7),
                        // border: Border.all(
                        //     color: AppTheme.white,width: 3)
                    ),
                    padding: const EdgeInsets.only(
                        top: 0, left: 0, right: 0, bottom: 0),
                    margin: const EdgeInsets.only(
                        top: 10, left: 6, right: 6, bottom: 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          width: size.width * .3,
                        height: 100,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(7),
                            child: Hero(
                                tag: department!.id!,
                                child: Image.network(
                                 department?.image??"",
                                  fit: BoxFit.fill,)),
                          ),
                        ),
                     //  SizedBox(height: size.height * .02,),



                      ],
                    ),
                  ),
                  SizedBox(height: size.height * .01,),
                  SizedBox(
                    width: size.width * .2,
                    child: Text(
                      department!.title!.en.toString(),
                      textAlign: TextAlign.center,
                     // overflow: TextOverflow.ellipsis,
                      style: TextStyle(

                        fontWeight: FontWeight.bold,
                        fontSize: size.height*0.017,
                        letterSpacing: 0.4,
                        height:  size.height*0.0014,
                        color: AppTheme.white,
                      ),
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