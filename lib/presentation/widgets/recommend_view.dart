
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/bloc/home/recomendation_bloc/recomend_cubit.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:loz/presentation/widgets/single_department.dart';
import 'package:loz/presentation/widgets/single_product.dart';

import '../../bloc/auth_bloc/auth_cubit.dart';
import '../../data/repositories/auth_repo.dart';
import '../../local_storage.dart';
import '../screens/Auth_screens/login.dart';

class RecommendView extends StatefulWidget {
  RecommendView(
      {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation,this.recommends,this.colors,this.recommendState})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  List<ProductModel> ?recommends;
  final RecommendCubit ?recommendState;
  List<List<String>> ?colors;


  @override
  _RecommendViewState createState() => _RecommendViewState();
}

class _RecommendViewState extends State<RecommendView>
    with TickerProviderStateMixin {
  AnimationController? animationController;
  AnimationController? productsAnimationController;


  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    productsAnimationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController?.dispose();
    productsAnimationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: Container(
               height: MediaQuery.of(context).size.height * .33,
              width: double.infinity,
              child: ListView.builder(
                // shrinkWrap: true,
                // physics: NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 4, left: 4),
                itemCount: widget.recommends!.length> 6?6 :  widget.recommends!.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                  widget.recommends!.length > 10 ? 10 : widget.recommends!.length;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return Center(
                    child: SingleProductWidget(
                      product: widget.recommends![index],
                    //  AnimationController: productsAnimationController,
                      animation: animation,
                      animationController: animationController!,
                      favToggle: (){
                        if(LocalStorage.getData(key: "token") != null)
                         widget.recommendState!.favToggle( widget.recommends![index].id!,index);
                        else
                          push(context,
                              BlocProvider(
                                  create: (BuildContext context) =>
                                      AuthCubit(AuthRepo()),
                                  child: Login()));
                      },
                      // department: widget.departments![index],
                      // colors: widget.colors,
                      // depIndex: index,

                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}




