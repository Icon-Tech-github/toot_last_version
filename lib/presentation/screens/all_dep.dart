

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/products_bloc/products_cubit.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/home_repo.dart';

import 'package:loz/data/repositories/products_repo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc/home/departments_bloc/departments_cubit.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/single_dep_all.dart';
import '../widgets/single_product.dart';



class AllDeptScreen extends StatefulWidget {

  const AllDeptScreen({Key? key, this.animationController,this.id,this.endColor,this.startColor,this.depName,}) : super(key: key);
  final AnimationController? animationController;
  final int ? id;
  final  String? startColor;
  final String ? endColor;
  final String ? depName;


  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<AllDeptScreen>
    with TickerProviderStateMixin {
  AnimationController? productsAnimationController;


  @override
  void initState() {

    productsAnimationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }



  @override
  void dispose() {

    productsAnimationController?.dispose();
    super.dispose();
  }


  // this.endColor,this.startColor

  // void addAllListData() {
  //   const int count = 9;
  //
  //
  //   listViews.add(
  //     ProductsListView(
  //       startColor: widget.startColor,
  //       endColor: widget.endColor,
  //       mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
  //           CurvedAnimation(
  //               parent: widget.animationController!,
  //               curve: Interval((1 / count) * 3, 1.0,
  //                   curve: Curves.fastOutSlowIn))),
  //       mainScreenAnimationController: widget.animationController,
  //     ),
  //   );
  //
  // }

  @override
  Widget build(BuildContext context) {

    return Container(
     // color: AppTheme.background,
      child: Scaffold(
          backgroundColor: Colors.transparent,
          body:
          // Container(
          //     height: MediaQuery.of(context).size.height,
          //     width: MediaQuery.of(context).size.width,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //           image: AssetImage("assets/images/background.jpg",),
          //           fit: BoxFit.fill
          //       ),),
          //     child:
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
              child: GetAppBarUi(animationController: productsAnimationController,id: widget.id,startColor: widget.startColor,endColor: widget.endColor,depName: widget.depName,))),
      // ),
    );
  }

}


class GetAppBarUi extends StatefulWidget {
  const GetAppBarUi({Key? key, this.animationController,this.id,this.startColor,this.endColor,this.depName,}) : super(key: key);
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

  @override
  void initState() {

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
    var size = MediaQuery.of(context).size;
    String lang = context.locale.toString();
    return Stack(
      children: [


        // ListView.builder(
        //   controller: scrollController,
        //   padding: EdgeInsets.only(
        //     top: AppBar().preferredSize.height +
        //         MediaQuery.of(context).padding.top +
        //         24,
        //     bottom: 62 + MediaQuery.of(context).padding.bottom,
        //   ),
        //   itemCount: listViews.length,
        //   scrollDirection: Axis.vertical,
        //   itemBuilder: (BuildContext context, int index) {
        //     widget.animationController?.forward();
        //     return BlocProvider<ProductsCubit>(
        //         create: (BuildContext context) => ProductsCubit(ProductsRepo()),
        //         child: ProductsList(animationController:widget.animationController ,));
        //   },
        // ),

        // ListView(
        //   controller: scrollController,
        //   // padding: EdgeInsets.only(
        //   //   top: AppBar().preferredSize.height +
        //   //       MediaQuery.of(context).padding.top +
        //   //       24,
        //   //   bottom: 62 + MediaQuery.of(context).padding.bottom,
        //   // ),
        //
        //   children: [



        BlocProvider<DepartmentsCubit>(
            create: (BuildContext context) => DepartmentsCubit(GetHomeRepository(),true,context,lang),
            child: ProductsList(animationController:widget.animationController ,startColor: widget.startColor,endColor: widget.endColor,id: widget.id,depName: widget.depName,
              mainScreenAnimationController:  Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                      parent: widget.animationController!,
                      curve: Interval((1 / 5) * 3, 1.0,
                          curve: Curves.fastOutSlowIn))),
            ))

      ],
    );
  }
}

class ProductsList extends StatefulWidget {
  const ProductsList({Key? key, this.animationController,this.endColor,this.startColor,this.id,this.depName,this.departments,this.mainScreenAnimationController}) : super(key: key);
  final AnimationController? animationController;
  final  String? startColor;
  final String ? endColor;
  final int ? id;
  final String ?depName;
  final  Animation<double>? mainScreenAnimationController;
  final List<CategoryModel> ?departments;
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList>
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


  @override
  void dispose() {
    animationController?.dispose();
    productsAnimationController?.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<DepartmentsCubit, DepartmentsState>(

        builder: (context, state) {
          if (state is DepartmentLoading && state.isFirstFetch) {
            return Center(
              child: SafeArea(
                child: Column(
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
                                color: AppTheme.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Text(
                            LocaleKeys.categories.tr(),
                            style: TextStyle(
                              fontSize:  size.width * .07,
                              fontWeight: FontWeight.bold,
                              color: Colors.white
                            ),
                          ),
                          // SizedBox(width: 60,),
                        ],
                      ),
                    ),
                    SizedBox(height:size.height * 0.01 ,),
                    Container(
                      //   height: size.height * 0.4,
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
          List<CategoryModel> departments = [];
          bool isLoading = false;

          if (state is DepartmentLoading) {
            departments = state.oldDeps;
            isLoading = true;
          } else if (state is DepartmentLoaded) {
            departments = state.departments;
          }

          DepartmentsCubit depState = context.read<DepartmentsCubit>();

          return SafeArea(
            child: SmartRefresher(
              header: WaterDropHeader(),

              controller: depState.controller,
              onLoading: (){
                depState.onLoad();
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
                                color: AppTheme.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          Text(
                            LocaleKeys.categories.tr(),
                            style: TextStyle(
                              fontSize:  size.width * .07,
                              fontWeight: FontWeight.bold,
                              color: AppTheme.white
                            ),
                          ),
                          // SizedBox(width: 60,),
                        ],
                      ),
                    ),
                 //   SizedBox(height:size.height * 0.01 ,),
                    AnimatedBuilder(
                      animation:   widget.mainScreenAnimationController!,
                      builder: (BuildContext context, Widget? child) {
                        return FadeTransition(
                          opacity:   widget.mainScreenAnimationController!,
                          child: Transform(
                            transform: Matrix4.translationValues(
                                0.0, 30 * (1.0 -   widget.mainScreenAnimationController!.value), 0.0),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2, childAspectRatio: 0.89),
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 0, right: 18, left: 18),
                              itemCount: departments.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final int count =
                                departments.length > 10 ? 10 : departments.length;
                                final Animation<double> animation =
                                Tween<double>(begin: 0.0, end: 1.0).animate(
                                    CurvedAnimation(
                                        parent: animationController!,
                                        curve: Interval((1 / count) * index, 1.0,
                                            curve: Curves.fastOutSlowIn)));
                                animationController?.forward();

                                return Center(
                                  child: SingleDepAllWidget(
                                    productsAnimationController: productsAnimationController,
                                    animation: animation,
                                    categories: departments,
                                    startColor:   widget.startColor,
                                    endColor:   widget.endColor,
                                    animationController: animationController!,
                                    category: departments[index],

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


          return SizedBox();
        }
    );
  }
}















// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:loz/bloc/products_bloc/products_cubit.dart';
// import 'package:loz/data/models/department_model.dart';
// import 'package:loz/data/models/products.dart';
// import 'package:loz/data/repositories/home_repo.dart';
//
// import 'package:loz/data/repositories/products_repo.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
//
// import '../../bloc/home/departments_bloc/departments_cubit.dart';
// import '../../theme.dart';
// import '../widgets/allDepartmentsView.dart';
// import '../widgets/dep.dart';
// import '../widgets/single_product.dart';
//
//
//
// class AllDeptScreen extends StatefulWidget {
//
//   const AllDeptScreen({Key? key, this.animationController,this.id,this.endColor,this.startColor,this.depName, this.departments}) : super(key: key);
//   final AnimationController? animationController;
//   final int ? id;
//   final  String? startColor;
//   final String ? endColor;
//   final String ? depName;
//   final List<CategoryModel> ?departments;
//
//
//   @override
//   _ProductState createState() => _ProductState();
// }
//
// class _ProductState extends State<AllDeptScreen>
//     with TickerProviderStateMixin {
//   AnimationController? DepAnimationController;
//
//
//   @override
//   void initState() {
//
//     DepAnimationController = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//     super.initState();
//   }
//
//
//
//   @override
//   void dispose() {
//
//     DepAnimationController?.dispose();
//     super.dispose();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//
//     return Container(
//       color: AppTheme.background,
//       child: Scaffold(
//         //   backgroundColor:AppTheme.white,
//           body:
//
//                 BlocProvider<DepartmentsCubit>(
//                   create: (BuildContext context) =>
//                       DepartmentsCubit(GetHomeRepository()),
//
//               child: AllDepartments(
//                 animationController: DepAnimationController,
//               )))
//         //   ),
//
//       );
//   }
//
//
// }
//
// class AllDepartments extends StatelessWidget {
//   final AnimationController? animationController;
//
//   AllDepartments({this.animationController});
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return BlocBuilder<DepartmentsCubit, DepartmentsState>(
//       builder: (context, state) {
//
//         List<CategoryModel> departments = [];
//         bool isLoading = false;
//
//         if (state is DepartmentLoading) {
//           departments = state.oldDeps;
//           isLoading = true;
//         } else if (state is DepartmentLoaded) {
//           departments = state.departments;
//         }
//
//
//         if (state is DepartmentLoading  && state.isFirstFetch) {
//           return Center(
//             child: Container(
//               height: size.height * 0.25,
//               width: size.width * 0.5,
//               alignment: Alignment.bottomCenter,
//               child: LoadingIndicator(
//                 indicatorType: Indicator.ballPulse,
//                 colors: const [
//                   AppTheme.nearlyDarkBlue,
//                   AppTheme.secondary,
//                   AppTheme.nearlyBlue,
//                 ],
//                 strokeWidth: 3,
//                 backgroundColor: Colors.transparent,
//                 pathBackgroundColor: Colors.white,
//               ),
//             ),
//           );
//         }
//
//           DepartmentsCubit homeState = context.read<DepartmentsCubit>();
//
//           return AllDepView(
//             mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
//                 CurvedAnimation(
//                     parent: animationController!,
//                     curve: Interval((1 / 5) * 3, 1.0,
//                         curve: Curves.fastOutSlowIn))),
//             mainScreenAnimationController: animationController,
//             departments: departments,
//             depState: homeState,
//             // index:random.nextInt( homeState.colors.length);
//           );
//
//
//       },
//     );
//   }
// }
//
