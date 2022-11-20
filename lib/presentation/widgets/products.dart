
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/products_bloc/products_cubit.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/models/products.dart';

import 'package:loz/presentation/widgets/single_product.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc/auth_bloc/auth_cubit.dart';
import '../../bloc/home/departments_bloc/departments_cubit.dart';
import '../../data/repositories/auth_repo.dart';
import '../../local_storage.dart';
import '../../theme.dart';
import '../screens/Auth_screens/login.dart';
import 'helper.dart';



class ProductsListView extends StatefulWidget {
  const ProductsListView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation,this.startColor,this.endColor,required this.products,this.productState,this.depId,this.depName,this.departments})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? startColor;
  final String? endColor;
 final List<ProductModel> products;
 final ProductsCubit? productState;
 final int ? depId ;
  final String ?depName;
  final List<CategoryModel> ? departments;


  @override
  _ProductsListViewState createState() => _ProductsListViewState();
}

class _ProductsListViewState extends State<ProductsListView>
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
    var lang = context.locale.toString();

    Size size =MediaQuery.of(context).size;
    return SafeArea(
      child: SmartRefresher(
        header: WaterDropHeader(),

        controller: widget.productState!.controller,
        onLoading: (){
          widget.productState!.onLoad(widget.depId!,context,lang);
        },
        enablePullUp: true,
        enablePullDown: false,
        child: ListView(
            shrinkWrap: true,
          children: [

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5, horizontal: 9),
                    child: IconButton(
                      icon:  Icon(
                        Icons.arrow_back_ios,
                        size: size.width * .08,
                        color: AppTheme.secondary,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  Text(
                    widget.depName.toString(),
                    style: TextStyle(
                      fontSize:  size.width * .07,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  // SizedBox(width: 60,),
                ],
              ),
            ),
            SizedBox(height:size.height * 0.01 ,),
            Container(
              height: size.height * 0.11,
              child: ListView.builder(
                  shrinkWrap: true,
                  // physics: NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(
                      top: 0, bottom: 20, right: 8, left: 18),
                  itemCount: widget.departments!.length> 6?6 :  widget.departments!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int index) {
                    final int count =
                    widget.departments!.length > 10 ? 10 : widget.departments!.length;
                    final Animation<double> animation =
                    Tween<double>(begin: 0.0, end: 1.0).animate(
                        CurvedAnimation(
                            parent: animationController!,
                            curve: Interval((1 / count) * index, 1.0,
                                curve: Curves.fastOutSlowIn)));
                    animationController?.forward();
                    return InkWell(
                      onTap: (){
                       setState(() {
                         DepartmentsCubit.activeId = widget.departments![index].id;
      widget.productState!.onLoad(widget.departments![index].id!,context,lang);
                       });
                      },
                      child: Container(
                        height: size.height * 0.09,
                        width: size.width * 0.22,
                        margin: EdgeInsets.symmetric(horizontal: 5),
                        decoration: BoxDecoration(
                          color:  DepartmentsCubit.activeId! == widget.departments![index].id?AppTheme.secondary: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey
                                    .withOpacity(0.3),
                                offset: const Offset(1.1, 4.0),
                                blurRadius: 8.0),
                          ],
                          // gradient: LinearGradient(
                          //   colors: <HexColor>[
                          //     HexColor(startColor!),
                          //     HexColor(endColor!),
                          //   ],
                          //   begin: Alignment.topLeft,
                          //   end: Alignment.bottomRight,
                          // ),
                          borderRadius:  BorderRadius.circular(15),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 30,
                              height: 30,
                              child: Hero(
                                  tag: widget.departments![index].id!,
                                  child: Image.network(widget.departments?[index].image??"",fit: BoxFit.fill,)),
                            ),
                            SizedBox(
                              width: size.width * .2,
                              child: Text(
                                widget.departments![index].title!.en.toString(),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(

                                  fontWeight: FontWeight.bold,
                                  fontSize: size.height*0.015,
                                  letterSpacing: 0.4,
                                  height:  size.height*0.003,
                                  color:  DepartmentsCubit.activeId! == widget.departments![index].id? Colors.white :AppTheme.nearlyBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } ),
            ),
            AnimatedBuilder(
            animation: widget.mainScreenAnimationController!,
            builder: (BuildContext context, Widget? child) {
              return FadeTransition(
                opacity: widget.mainScreenAnimation!,
                child: Transform(
                  transform: Matrix4.translationValues(
                      0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, childAspectRatio: 0.65),
                    padding: const EdgeInsets.only(
                        top: 0, bottom: 0, right: 16, left: 16),
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
                        child: SingleProductWidget(
                          animation: animation,
                          startColor: widget.startColor,
                          endColor: widget.endColor,
                          animationController: animationController!,
                          product: widget.products[index],
                          favToggle: (){
                            if(LocalStorage.getData(key: "token") != null)
                             widget.productState!.favToggle(widget.products[index].id!,index);
                            else
                              push(context,
                                  BlocProvider(
                                      create: (BuildContext context) =>
                                          AuthCubit(AuthRepo()),
                                      child: Login()));
                          },

                        ),
                      );
                    },
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


