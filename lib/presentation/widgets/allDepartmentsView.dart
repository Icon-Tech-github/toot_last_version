
import 'package:flutter/material.dart';
import 'package:loz/bloc/products_bloc/products_cubit.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/presentation/widgets/single_dep_all.dart';

import 'package:loz/presentation/widgets/single_product.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc/home/departments_bloc/departments_cubit.dart';
import '../../theme.dart';



class AllDepView extends StatefulWidget {
  const AllDepView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation,this.startColor,this.endColor,this.depState,this.depId,this.depName,this.departments})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  final String? startColor;
  final String? endColor;
  final DepartmentsCubit? depState;
  final int ? depId ;
  final String ?depName;
  final List<CategoryModel> ? departments;


  @override
  _AllDepViewState createState() => _AllDepViewState();
}

class _AllDepViewState extends State<AllDepView>
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
      child: SmartRefresher(
        header: WaterDropHeader(),

        controller: widget.depState!.controller,
        onLoading: (){
          widget.depState!.onLoad();
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
                        itemCount: widget.departments!.length,
                        scrollDirection: Axis.vertical,
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

                          return Center(
                            child: SingleDepAllWidget(
                              animation: animation,
                              startColor: widget.startColor,
                              endColor: widget.endColor,
                              animationController: animationController!,
                              category: widget.departments![index],

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


