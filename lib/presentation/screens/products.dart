import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/products_bloc/products_cubit.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/models/products.dart';

import 'package:loz/data/repositories/products_repo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc/auth_bloc/auth_cubit.dart';
import '../../bloc/home/departments_bloc/departments_cubit.dart';
import '../../data/repositories/auth_repo.dart';
import '../../local_storage.dart';
import '../../theme.dart';
import '../widgets/helper.dart';
import '../widgets/single_product.dart';
import 'Auth_screens/login.dart';



class ProductScreen extends StatefulWidget {

  const ProductScreen({Key? key, this.animationController,this.id,this.endColor,this.startColor,this.depName, this.departments,required this.keyIndex}) : super(key: key);
  final AnimationController? animationController;
  final int ? id;
final  String? startColor;
final String ? endColor;
final String ? depName;
  final GlobalObjectKey keyIndex;
  final List<CategoryModel> ?departments;


  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductScreen>
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




  @override
  Widget build(BuildContext context) {

    return Container(
      color: AppTheme.secondary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
         body:
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
             child:
            GetAppBarUi(animationController: productsAnimationController,id: widget.id,startColor: widget.startColor,endColor: widget.endColor,depName:   widget.depName ,departments: widget.departments,contextUpper: context,keyIndex: widget.keyIndex,)),
      ),
    );
  }


}


class GetAppBarUi extends StatefulWidget {
  const GetAppBarUi({Key? key, this.animationController,this.id,this.startColor,this.endColor,this.depName, this.departments,this.contextUpper,required this.keyIndex}) : super(key: key);
  final AnimationController? animationController;
  final int ? id;
  final  String? startColor;
  final BuildContext ?contextUpper;
  final String ? endColor;
  final String ? depName;
  final GlobalObjectKey keyIndex;

  final List<CategoryModel>? departments;

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
    var lang = context.locale.toString();

    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
    BlocProvider<ProductsCubit>(
                create: (BuildContext context) => ProductsCubit(ProductsRepo(),widget.id!,widget.contextUpper,lang),
                child: ProductsList(contextUpper:widget.contextUpper,animationController:widget.animationController ,keyIndex: widget.keyIndex,startColor: widget.startColor,endColor: widget.endColor,id: widget.id,depName: widget.depName,departments: widget.departments,
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
  const ProductsList({Key? key, this.animationController,this.endColor,this.startColor,this.id,this.depName,this.departments,this.mainScreenAnimationController,this.contextUpper,required this.keyIndex}) : super(key: key);
  final AnimationController? animationController;
  final  String? startColor;
  final String ? endColor;
  final int ? id;
  final BuildContext ?contextUpper;
  final GlobalObjectKey keyIndex;

  final String ?depName;
  final  Animation<double>? mainScreenAnimationController;
  final List<CategoryModel> ?departments;
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList>
    with TickerProviderStateMixin {
  AnimationController? animationController;


  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    //if (widget.keyIndex.currentContext != null)
      //   print(widget.keyIndex.toString());
  //    if (widget.keyIndex.currentContext != null)
        //   print(widget.keyIndex.toString());
        Future.delayed(const Duration(milliseconds: 0), () {
          print(widget.keyIndex.toString());
    Scrollable.ensureVisible(
        widget.keyIndex.currentContext!,
        duration: const Duration(milliseconds: 1000));
  });
    super.initState();
  }


  @override
  void dispose() {
    animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var lang = context.locale.toString();

    return SmartRefresher(
      header: WaterDropHeader(),

      controller: context.read<ProductsCubit>().controller,
      onLoading: (){
        context.read<ProductsCubit>().onLoad(DepartmentsCubit.activeId!,context,lang);
      },
      enablePullUp: true,
      enablePullDown: false,
      child: SafeArea(
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                          color: AppTheme.secondary,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                    Text(
                        context.read<ProductsCubit>().depName??
                        widget.depName.toString(),
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
                height: size.height * 0.08,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ListView.builder(
                      shrinkWrap: true,
                       physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(
                          top: 0, bottom: 20, right: 8, left: 18),
                      itemCount:   widget.departments!.length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final int count =
                            widget.departments!.length;
                        final Animation<double> animation =
                        Tween<double>(begin: 0.0, end: 1.0).animate(
                            CurvedAnimation(
                                parent: animationController!,
                                curve: Interval((1 / count) * index, 1.0,
                                    curve: Curves.fastOutSlowIn)));
                        animationController?.forward();
                        return InkWell(
                          onTap: (){
                            context.read<ProductsCubit>().depName = widget.departments![index].title!.en.toString();
    setState(() {
                            DepartmentsCubit.activeId =   widget.departments![index].id;
                            context.read<ProductsCubit>().page=1;
                            context.read<ProductsCubit>().onLoad(  widget.departments![index].id!,widget.contextUpper,lang);
    });
                          },
                          child: Container(
                            key:DepartmentsCubit.formKeyList[index],
                            height: size.height * 0.09,
                            width: size.width * 0.22,
                            margin: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                              color:  DepartmentsCubit.activeId! ==   widget.departments![index].id?AppTheme.secondary: Colors.white,
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
                                // SizedBox(
                                //   width: 30,
                                //   height: 30,
                                //   child: Hero(
                                //       tag:   widget.departments![index].id!,
                                //       child: Image.network(  widget.departments?[index].image??"",fit: BoxFit.fill,)),
                                // ),
                                SizedBox(
                                  width: size.width * .2,
                                  child: Text(
                               //     DepartmentsCubit.formKeyList[index].toString(),
                                   widget.departments![index].title!.en.toString(),
                                    textAlign: TextAlign.center,
                                 //   overflow: TextOverflow.ellipsis,
                                    style: TextStyle(

                                      fontWeight: FontWeight.bold,
                                      fontSize: size.height*0.015,
                                      letterSpacing: 0.4,
                                      height:  size.height*0.001,
                                      color:  DepartmentsCubit.activeId! ==   widget.departments![index].id? Colors.white :AppTheme.nearlyBlack,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } ),
                ),
              ),
              BlocBuilder<ProductsCubit, ProductsState>(

              builder: (context, state) {
                if (state is ProductsLoading && state.isFirstFetch) {
                  return Center(
                    child: SafeArea(
                      child: Column(
                        children: [


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
                List<ProductModel> products = [];
                bool isLoading = false;

                if (state is ProductsLoading) {
                  products = state.OldProducts;
                  isLoading = true;
                } else if (state is ProductsLoaded) {
                  products = state.products;
                }

                  ProductsCubit productState = context.read<ProductsCubit>();

                  return SingleChildScrollView(
                    child: AnimatedBuilder(
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
                                  crossAxisCount: 2, childAspectRatio: 0.7),
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 0, right: 4, left: 4),
                              itemCount: products.length,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (BuildContext context, int index) {
                                final int count =
                                products.length > 10 ? 10 : products.length;
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
                                    startColor:   widget.startColor,
                                    endColor:   widget.endColor,
                                    animationController: animationController!,
                                    product: products[index],
                                    favToggle: (){
                                      if(LocalStorage.getData(key: "token") != null)
                                        productState.favToggle(products[index].id!,index);
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
                  );


                return SizedBox();
              }
   ),
            ],
          ),
        ),
      ),
    );
  }
}

