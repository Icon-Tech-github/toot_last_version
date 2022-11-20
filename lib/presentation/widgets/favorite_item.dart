//
// import 'package:flutter/material.dart';
// import 'package:loz/data/meals.dart';
// import 'package:loz/data/models/products.dart';
// import 'package:loz/presentation/screens/product_details.dart';
// import 'package:loz/presentation/screens/products.dart';
// import 'package:loz/presentation/widgets/helper.dart';
//
// import '../../main.dart';
// import '../../theme.dart';
// import 'dep.dart';
// import 'hex_color.dart';
//
// class FavoriteListView extends StatefulWidget {
//   const FavoriteListView(
//       {Key? key, this.mainScreenAnimationController, this.mainScreenAnimation,this.startColor,this.endColor})
//       : super(key: key);
//
//   final AnimationController? mainScreenAnimationController;
//   final Animation<double>? mainScreenAnimation;
//   final String? startColor;
//   final String? endColor;
//
//   @override
//   _FavoriteListViewState createState() => _FavoriteListViewState();
// }
//
// class _FavoriteListViewState extends State<FavoriteListView>
//     with TickerProviderStateMixin {
//   AnimationController? animationController;
//   // List<ProductModel> mealsListData = ProductModel.tabIconsList;
//
//   @override
//   void initState() {
//     animationController = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//     super.initState();
//   }
//
//   Future<bool> getData() async {
//     await Future<dynamic>.delayed(const Duration(milliseconds: 50));
//     return true;
//   }
//
//   @override
//   void dispose() {
//     animationController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: widget.mainScreenAnimationController!,
//       builder: (BuildContext context, Widget? child) {
//         return FadeTransition(
//           opacity: widget.mainScreenAnimation!,
//           child: Transform(
//             transform: Matrix4.translationValues(
//                 0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
//             child: Container(
//               //  height: 400,
//               width: double.infinity,
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate:
//                 const SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2, childAspectRatio: 0.7),
//                 padding: const EdgeInsets.only(
//                     top: 0, bottom: 0, right: 16, left: 16),
//                 itemCount: mealsListData.length,
//                 scrollDirection: Axis.vertical,
//                 itemBuilder: (BuildContext context, int index) {
//                   final int count =
//                   mealsListData.length > 10 ? 10 : mealsListData.length;
//                   final Animation<double> animation =
//                   Tween<double>(begin: 0.0, end: 1.0).animate(
//                       CurvedAnimation(
//                           parent: animationController!,
//                           curve: Interval((1 / count) * index, 1.0,
//                               curve: Curves.fastOutSlowIn)));
//                   animationController?.forward();
//
//                   return ProductView(
//                     function: (){
//                       push(context, ProductDetailsScreen(animationController: animationController, startColor:  widget.startColor,  endColor:   widget.endColor, imagePath:  mealsListData[index].imagePath,));
//                     },
//                     //   mealsListData: mealsListData[index],
//                     animation: animation,
//                     animationController: animationController!,
//                     title:   mealsListData[index].titleTxt,
//                  //   description: mealsListData[index].meals!.join('\n'),
//                     price: mealsListData[index].kacl.toString(),
//                     startColor:  widget.startColor,
//                     endColor:   widget.endColor,
//                     imagePath:  mealsListData[index].imagePath,
//                     favScreen: true,
//
//                   );
//                 },
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//
//
