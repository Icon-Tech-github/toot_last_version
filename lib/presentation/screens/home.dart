// import 'package:flutter/material.dart';
// import 'package:loz/presentation/widgets/dep.dart';
// import 'package:loz/presentation/widgets/home_ad.dart';
//
// import '../../theme.dart';
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen({Key? key, this.animationController}) : super(key: key);
//
//   final AnimationController? animationController;
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen>
//     with TickerProviderStateMixin {
//   Animation<double>? topBarAnimation;
//
//   List<Widget> listViews = <Widget>[];
//   final ScrollController scrollController = ScrollController();
//   double topBarOpacity = 0.0;
//
//   @override
//   void initState() {
//     topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//         CurvedAnimation(
//             parent: widget.animationController!,
//             curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));
//     addAllListData();
//
//     scrollController.addListener(() {
//       if (scrollController.offset >= 24) {
//         if (topBarOpacity != 1.0) {
//           setState(() {
//             topBarOpacity = 1.0;
//           });
//         }
//       } else if (scrollController.offset <= 24 &&
//           scrollController.offset >= 0) {
//         if (topBarOpacity != scrollController.offset / 24) {
//           setState(() {
//             topBarOpacity = scrollController.offset / 24;
//           });
//         }
//       } else if (scrollController.offset <= 0) {
//         if (topBarOpacity != 0.0) {
//           setState(() {
//             topBarOpacity = 0.0;
//           });
//         }
//       }
//     });
//     super.initState();
//   }
//
//   void addAllListData() {
//     const int count = 9;
//
//     // listViews.add(
//     //   TitleView(
//     //     titleTxt: 'Mediterranean diet',
//     //     subTxt: 'Details',
//     //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//     //         parent: widget.animationController!,
//     //         curve:
//     //         Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
//     //     animationController: widget.animationController!,
//     //   ),
//     // );
//     // listViews.add(
//     //   MediterranesnDietView(
//     //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//     //         parent: widget.animationController!,
//     //         curve:
//     //         Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
//     //     animationController: widget.animationController!,
//     //   ),
//     // );
//     // listViews.add(
//     //   TitleView(
//     //     titleTxt: 'Meals today',
//     //     subTxt: 'Customize',
//     //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//     //         parent: widget.animationController!,
//     //         curve:
//     //         Interval((1 / count) * 2, 1.0, curve: Curves.fastOutSlowIn))),
//     //     animationController: widget.animationController!,
//     //   ),
//     // );
//     //
//     listViews.add(
//       HomeAd(
//         animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//             parent: widget.animationController!,
//             curve:
//             Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
//         animationController: widget.animationController!,
//       ),
//     );
//     listViews.add(
//       MealsListView(
//         mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
//             CurvedAnimation(
//                 parent: widget.animationController!,
//                 curve: Interval((1 / count) * 3, 1.0,
//                     curve: Curves.fastOutSlowIn))),
//         mainScreenAnimationController: widget.animationController,
//       ),
//     );
//     //
//     // listViews.add(
//     //   TitleView(
//     //     titleTxt: 'Body measurement',
//     //     subTxt: 'Today',
//     //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//     //         parent: widget.animationController!,
//     //         curve:
//     //         Interval((1 / count) * 4, 1.0, curve: Curves.fastOutSlowIn))),
//     //     animationController: widget.animationController!,
//     //   ),
//     // );
//
//
//     // listViews.add(
//     //   TitleView(
//     //     titleTxt: 'Water',
//     //     subTxt: 'Aqua SmartBottle',
//     //     animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
//     //         parent: widget.animationController!,
//     //         curve:
//     //         Interval((1 / count) * 6, 1.0, curve: Curves.fastOutSlowIn))),
//     //     animationController: widget.animationController!,
//     //   ),
//     // );
//
//     // listViews.add(
//     //   WaterView(
//     //     mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
//     //         CurvedAnimation(
//     //             parent: widget.animationController!,
//     //             curve: Interval((1 / count) * 7, 1.0,
//     //                 curve: Curves.fastOutSlowIn))),
//     //     mainScreenAnimationController: widget.animationController!,
//     //   ),
//     // );
//     // listViews.add(
//     //   GlassView(
//     //       animation: Tween<double>(begin: 0.0, end: 1.0).animate(
//     //           CurvedAnimation(
//     //               parent: widget.animationController!,
//     //               curve: Interval((1 / count) * 8, 1.0,
//     //                   curve: Curves.fastOutSlowIn))),
//     //       animationController: widget.animationController!),
//     // );
//   }
//
//   Future<bool> getData() async {
//     await Future<dynamic>.delayed(const Duration(milliseconds: 50));
//     return true;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor:AppTheme.background,
//       body: Stack(
//         children: <Widget>[
//           getMainListViewUI(),
//           getAppBarUI(),
//           SizedBox(
//             height: MediaQuery.of(context).padding.bottom,
//           )
//         ],
//       ),
//     );
//   }
//
//   Widget getMainListViewUI() {
//     return FutureBuilder<bool>(
//       future: getData(),
//       builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
//         if (!snapshot.hasData) {
//           return const SizedBox();
//         } else {
//           return ListView.builder(
//             controller: scrollController,
//             padding: EdgeInsets.only(
//               top: AppBar().preferredSize.height +
//                   MediaQuery.of(context).padding.top +
//                   24,
//               bottom: 62 + MediaQuery.of(context).padding.bottom,
//             ),
//             itemCount: listViews.length,
//             scrollDirection: Axis.vertical,
//             itemBuilder: (BuildContext context, int index) {
//               widget.animationController?.forward();
//               return listViews[index];
//             },
//           );
//         }
//       },
//     );
//   }
//
//   Widget getAppBarUI() {
//     return Column(
//       children: <Widget>[
//         AnimatedBuilder(
//           animation: widget.animationController!,
//           builder: (BuildContext context, Widget? child) {
//             return FadeTransition(
//               opacity: topBarAnimation!,
//               child: Transform(
//                 transform: Matrix4.translationValues(
//                     0.0, 30 * (1.0 - topBarAnimation!.value), 0.0),
//                 child: Container(
//                   decoration: BoxDecoration(
//                     color: AppTheme.white.withOpacity(topBarOpacity),
//                     borderRadius: const BorderRadius.only(
//                       bottomLeft: Radius.circular(32.0),
//                     ),
//                     boxShadow: <BoxShadow>[
//                       BoxShadow(
//                           color: AppTheme.grey
//                               .withOpacity(0.4 * topBarOpacity),
//                           offset: const Offset(1.1, 1.1),
//                           blurRadius: 10.0),
//                     ],
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       SizedBox(
//                         height: MediaQuery.of(context).padding.top,
//                       ),
//                       Padding(
//                         padding: EdgeInsets.only(
//                             left: 16,
//                             right: 16,
//                             top: 16 - 8.0 * topBarOpacity,
//                             bottom: 12 - 8.0 * topBarOpacity),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: <Widget>[
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text(
//                                   'Loz&Moz',
//                                   textAlign: TextAlign.left,
//                                   style: TextStyle(
//                                     fontFamily: AppTheme.fontName,
//                                     fontWeight: FontWeight.w700,
//                                     fontSize: 22 + 6 - 6 * topBarOpacity,
//                                     letterSpacing: 1.2,
//                                     color: AppTheme.darkerText,
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//             );
//           },
//         )
//       ],
//     );
//   }
// }

import 'dart:io';

import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/home/departments_bloc/departments_cubit.dart';
import 'package:loz/bloc/home/home_ad_bloc/home_ad_cubit.dart';
import 'package:loz/bloc/search_bloc/search_cubit.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/local_storage.dart';

import 'package:loz/presentation/screens/search.dart';

import 'package:loz/presentation/widgets/dep.dart';
import 'package:loz/presentation/widgets/home_ad.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:open_store/open_store.dart';
import 'package:shimmer/shimmer.dart';
import 'package:update_available/update_available.dart';


import '../../bloc/home/recomendation_bloc/recomend_cubit.dart';

import '../../data/models/branch_model.dart';

import '../../theme.dart';
import '../widgets/helper.dart';
import '../widgets/recommend_view.dart';
import 'all_dep.dart';


class HomeScreen extends StatelessWidget {
  final AnimationController? animationController;
  final String? branchSelected;
  List<BranchModel>? branches;
  bool? fromSplash = false;

  HomeScreen(
      {this.animationController,
      this.branchSelected,
      this.branches,
      this.fromSplash});

  @override
  Widget build(BuildContext context) {
    var lang = context.locale.toString();
    return Scaffold(
          // backgroundColor:AppTheme.secondary,
        body:
        Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
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
              // decoration: BoxDecoration(
              //   image: DecorationImage(
              //       image: AssetImage("assets/images/18.jpg",),
              //       fit: BoxFit.fill
              //   ),),
              child: MultiBlocProvider(
                  providers: [
                BlocProvider<HomeAdCubit>(
                  create: (BuildContext context) => HomeAdCubit(GetHomeRepository()),
                ),
                BlocProvider<DepartmentsCubit>(
                  create: (BuildContext context) =>
                      DepartmentsCubit(GetHomeRepository(), false, context, lang),
                ),
                BlocProvider<RecommendCubit>(
                  create: (BuildContext context) =>
                      RecommendCubit(GetHomeRepository()),
                ),
              ],
                  child: AppBarUIAnimation(
                    animationController: animationController,
                    branches: branches,
                    fromSplash: fromSplash,
                  )),
            ),

        //   ),

        );
  }
}

class AppBarUIAnimation extends StatefulWidget {
  AppBarUIAnimation(
      {Key? key, this.animationController, this.branches, this.fromSplash})
      : super(key: key);
  final AnimationController? animationController;
  final List<BranchModel>? branches;
  bool? fromSplash = false;

  @override
  _AppBarUIAnimationState createState() => _AppBarUIAnimationState();
}

class _AppBarUIAnimationState extends State<AppBarUIAnimation>
    with TickerProviderStateMixin {
  Animation<double>? topBarAnimation;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  AnimationController? productsAnimationController;
  TextEditingController search = TextEditingController();
  bool ActiveConnection = true;
  Future CheckUserConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          ActiveConnection = true;

        });
      }
    } on SocketException catch (_) {
      setState(() {
        ActiveConnection = false;
      });
    }
  }

  void checkVersion(BuildContext context) async {
    final updateAvailability = await getUpdateAvailability();


    final text = updateAvailability.fold(
      available: () => "true",
      notAvailable: () => 'false',
      unknown: () => "It was not possible to determine if there is or not "
          "an update for your app.",
    );

    print(text);

    if(text=='true' && widget.fromSplash == true){
      showDialog(context: context,
          builder: (context){
            return AlertDialog(
              contentPadding: EdgeInsets.zero,
              title: Center(
                child: Text(LocaleKeys.update.tr(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22
                  ),),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 30,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(LocaleKeys.update_des.tr(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black38,
                          fontSize: 14
                      ),),
                  ),

                  SizedBox(height: 20,),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.black12,
                  ),
                  Container(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                widget.fromSplash = false;
                              });
                              Navigator.pop(context);
                            },
                            child: Center(
                              child: Text(
                               LocaleKeys.Maybe_later.tr(),
                                style: TextStyle(
                                    color: Colors.black38
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          width: 1,
                          color: Colors.black12,
                        ),
                        Expanded(
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                widget.fromSplash = false;
                              });
                              OpenStore.instance.open(
                                appStoreId: '1603425900', // AppStore id of your app for iOS
                                androidAppBundleId: 'com.icontds.toot', // Android app bundle package name
                              );
                            },
                            child:  Container(
                              color: AppTheme.secondary,
                              child: Center(
                                child: Text(
                                  LocaleKeys.Update_Now.tr(),
                                  style: TextStyle(
                                      color: Colors.white
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  )
                ],
              ),
            );
          });
    }

  }


  @override
  void initState() {

    CheckUserConnection();
    checkVersion(context);
    productsAnimationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController!,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = .5;
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
    widget.animationController?.forward();
    super.initState();
  }
bool connected = true;
  @override
  Widget build(BuildContext context) {
    var we = MediaQuery.of(context).size.width;
    var he = MediaQuery.of(context).size.height;
    var lang = context.locale.toString();

        return  ActiveConnection
            ? Stack(children: [
          ListView(
            controller: scrollController,
            // padding: EdgeInsets.only(
            //    top: AppBar().preferredSize.height +
            //        MediaQuery.of(context).padding.top +
            //        24,
            //    bottom: 62 + MediaQuery.of(context).padding.bottom,
            //  ),

            children: [
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 0),
                child: Text(
                  "${LocaleKeys.hello.tr()} , ${LocalStorage.getData(key: "userName")??LocaleKeys.Guest.tr()}",
                  //textAlign: TextAlign.r,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: we * .055,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  width: we * 0.9,
                  height: he * .07,
                  child: TextFormField(
                    cursorColor: AppTheme.secondary,
                    enableSuggestions: true,
                    controller: search,
                    textAlign: TextAlign.start,
//style:  TextStyle(fontSize: 15, color: AppTheme.grey,height: he * .002),
                    onFieldSubmitted: (value){
                      SearchCubit.filterWord = search.text;
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (context) => SearchScreen(animationController: productsAnimationController,search: search.text,))).then((value) => search.text='');
                    },
                    decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            SearchCubit.filterWord = search.text;
                            Navigator.of(context)
                                .push(MaterialPageRoute(builder: (context) => SearchScreen(animationController: productsAnimationController,search: search.text,))).then((value) => search.text='');
                          },
                          child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              decoration: BoxDecoration(
                                color: AppTheme.secondary,
                                borderRadius: BorderRadius.only(
                                  topRight:  Radius.circular(context.locale.toString() == 'ar'?0:15),
                                  bottomRight:  Radius.circular(context.locale.toString() == 'ar'?0:15),
                                  topLeft:  Radius.circular(context.locale.toString() == 'en'?0:15),
                                  bottomLeft:  Radius.circular(context.locale.toString() == 'en'?0:15),
                                ),
                              ),
                              child: Text(LocaleKeys.search.tr(), style:
                              TextStyle(fontSize: 15, color: AppTheme.white,height: he * .004),
                              )
                          ),
                        ),

                        filled: true,
                        alignLabelWithHint: true,
                        fillColor: AppTheme.white,
                        hintStyle: TextStyle(fontSize: 15, color: AppTheme.grey,height: he * .001),
                        prefixIcon: Center(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child:Icon(Icons.search,size: we * .06,)
                          ),
                        ),

                        hintText:  LocaleKeys.search_title.tr(),
                        prefixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 50,),
                        isDense: true,
                        contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                        prefixStyle: TextStyle(color: AppTheme.nearlyBlack,),
                        border: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide.none)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              HomeAds(
                animationController: widget.animationController,
              ),
              SizedBox(
                height: 20,
              ),
              homeTitle(LocaleKeys.categories.tr(), () {
                push(context, AllDeptScreen());
              }, context),
              HomeDepartments(
                animationController: widget.animationController,
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Row(
                  children: [
                    Text(
                      LocaleKeys.recommend.tr(),
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: we * .055,
                      ),
                    ),
                    SizedBox(
                      width: we * .01,
                    ),
                    // Image.asset(
                    //   "assets/images/ok.png",
                    //   height: he * .03,
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: 0,
              ),
              HomeRecommend(
                animationController: widget.animationController,
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * .05,
              ),
            ],
          ),

        ])
            : Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          color: Colors.white,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/off.gif"),
              Text(
                LocaleKeys.offline_translate.tr(),
                style:
                TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ],
          ),
        );

  }
}

class HomeAds extends StatelessWidget {
  final AnimationController? animationController;

  HomeAds({this.animationController});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<HomeAdCubit, HomeAdState>(
      builder: (context, state) {
        if (state is HomeAdLoading) {
          return Container(
            height: size.height * 0.22,
            child: Shimmer.fromColors(
              baseColor: Colors.transparent,
              highlightColor: Colors.white.withOpacity(0.1),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                child: Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.white, width: 1),
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ),
          );
        }
        if (state is HomeAdLoaded) {
          return HomeAd(
            animation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: animationController!,
                    curve: Interval((1 / 5) * 5, 1.0, curve: Curves.bounceIn))),
            animationController: animationController!,
            ads: state.ads,
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class HomeDepartments extends StatelessWidget {
  final AnimationController? animationController;

  HomeDepartments({this.animationController});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<DepartmentsCubit, DepartmentsState>(
      builder: (context, state) {
        if (state is DepartmentLoading) {
          return Center(
            child: Container(
              height: size.height * 0.25,
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
          );
        }
        if (state is DepartmentLoaded) {
          DepartmentsCubit homeState = context.read<DepartmentsCubit>();

          return DepartmentsView(
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: animationController!,
                    curve: Interval((1 / 5) * 3, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: animationController,
            departments: state.departments,
            colors: homeState.colors,
            // index:random.nextInt( homeState.colors.length);
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}

class HomeRecommend extends StatelessWidget {
  final AnimationController? animationController;

  HomeRecommend({this.animationController});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return BlocBuilder<RecommendCubit, RecommendState>(
      builder: (context, state) {
        if (state is RecommendLoading) {
          return Center(
            child: Container(
              height: size.height * 0.4,
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
          );
        }
        if (state is RecommendLoaded) {
          RecommendCubit homeState = context.read<RecommendCubit>();

          return RecommendView(
            recommendState: homeState,
            mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: animationController!,
                    curve: Interval((1 / 5) * 3, 1.0,
                        curve: Curves.fastOutSlowIn))),
            mainScreenAnimationController: animationController,
            recommends: state.recommends,
            colors: homeState.colors,
            // index:random.nextInt( homeState.colors.length);
          );
        }
        return const Text('Something went wrong!');
      },
    );
  }
}
