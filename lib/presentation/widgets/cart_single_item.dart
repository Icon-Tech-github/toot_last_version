import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme.dart';

// class CartSingleItem extends StatelessWidget {
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     var size = MediaQuery.of(context).size;
//
//     return Container(
//       margin: EdgeInsets.only(bottom: 10),
//       // width: 130,
//       //height: price != null ? 200: 130,
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.only(
//           bottomRight: Radius.circular(8.0),
//           bottomLeft: Radius.circular(8.0),
//           topLeft: Radius.circular(8.0),
//           topRight: Radius.circular(54.0),
//         ),
//       ),
//       child: Padding(
//         padding:  EdgeInsets.only(
//             top: 6, left: 16, right: 16, bottom: 8),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: <Widget>[
//             Row(
//               // mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 Expanded(
//                   flex:1,
//                   child: ClipRRect(
//                     //  margin: EdgeInsets.only(left: 20,),
//
//                     // decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(7),
//                     child: Image.asset("assets/fitness_app/pngegg (7).png"),
//                     // ),
//                     // child: FadeInImage.assetNetwork(
//                     //   width: 90,
//                     //   height: 80,
//                     //   placeholder: 'assets/images/loadd.gif',
//                     //   image: ,
//                     //   fit: BoxFit.fill,
//                     // ),
//                   ),
//                 ),
//                 SizedBox(width: 20,),
//                 Expanded(
//                   flex: 3,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       SizedBox(
//                         width:size.width *.3,
//                         child: Text("Watermelon Juice",  overflow: TextOverflow.ellipsis, maxLines: 1,
//                           softWrap: false,style: TextStyle( fontSize: 13,fontWeight: FontWeight.bold),),
//                       ),
//                       SizedBox(height: 5,),
//                       Text("Medium" ,style: TextStyle( fontSize: 13),),
//                       SizedBox(height: size.height * .005,),
//
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text("Extra Milk \\ nuts" ,style: TextStyle( fontSize: 13,color: Colors.grey),),
//                           Row(
//                             children: [
//                               InkWell(
//                                 onTap: () {
//
//                                 },
//                                 child: Container(
//                                   height: 20,
//                                   width: 30,
//                                   decoration:
//                                   BoxDecoration(
//                                     shape: BoxShape
//                                         .circle,
//                                     color: AppTheme.secondary,
//                                     //  borderRadius:
//                                     //  BorderRadius.only(
//                                     //    topLeft:
//                                     //    Radius.circular(8),
//                                     // )
//                                   ),
//                                   child: Center(
//                                     child: Icon(
//                                       Icons.add,
//                                       color: Colors
//                                           .white,
//                                       size: 15,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               SizedBox(width: size.width * .02,),
//                               Text("2",
//                                 style: TextStyle(
//                                     fontSize:
//                                     size.height *
//                                         0.018),
//                               ),
//                               SizedBox(width: size.width * .02,),
//
//                               InkWell(
//                                 onTap: () {
//
//                                 },
//                                 child: Container(
//                                   height: 20,
//                                   width: 30,
//                                   alignment: Alignment
//                                       .center,
//                                   decoration:
//                                   BoxDecoration(
//                                     shape: BoxShape
//                                         .circle,
//                                     color:
//                                     AppTheme.secondary,
//                                     // borderRadius:
//                                     // BorderRadius.only(
//                                     //   bottomLeft:
//                                     //   Radius.circular(8),
//                                     // )
//                                   ),
//                                   child: Icon(
//                                     FontAwesomeIcons
//                                         .minus,
//                                     color:
//                                     Colors.white,
//                                     size:12,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//               ],
//             ),
//             Divider(
//               thickness: 1,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Container(
//                   child: Icon(Icons.star_border,color: Colors.grey,),
//                 ),
//                 Container(
//                   height: size.height * .035,
//                   width: size.width*.012,
//                   decoration: BoxDecoration(
//                     //  color: dark,
//
//                       borderRadius: BorderRadius.circular(15)
//                   ),
//                   child:  VerticalDivider(
//                     // color: FitnessAppTheme.secondary,
//                     width:  size.width*.001,
//                     thickness:  size.width*.002,
//                   ),),
//                 Container(
//                     child: Image.asset("assets/fitness_app/bin.png",width: size.height *.025,color: Colors.grey,)
//                 ),
//                 Container(
//                   height: size.height * .035,
//                   width: size.width*.012,
//                   decoration: BoxDecoration(
//                     //  color: dark,
//
//                       borderRadius: BorderRadius.circular(15)
//                   ),
//                   child:  VerticalDivider(
//                     //  color: FitnessAppTheme.secondary,
//                     //   width:  size.width*.001,
//                     thickness:  1,
//                   ),),
//                 Text("200 KWD",
//                   style: TextStyle( fontSize: 13,fontWeight: FontWeight.bold,color: AppTheme.orange),)
//               ],
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
