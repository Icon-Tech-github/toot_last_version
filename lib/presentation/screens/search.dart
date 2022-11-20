import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:loz/bloc/search_bloc/search_cubit.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../bloc/auth_bloc/auth_cubit.dart';
import '../../data/models/products.dart';
import '../../data/repositories/auth_repo.dart';
import '../../data/repositories/search.dart';
import '../../local_storage.dart';
import '../../theme.dart';
import '../../translations/locale_keys.g.dart';
import '../widgets/helper.dart';
import 'package:lottie/lottie.dart'as lottie;

import '../widgets/single_product.dart';
import 'Auth_screens/login.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key,this.search,this.animationController}) : super(key: key);
  final  String? search;
  final AnimationController? animationController;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with TickerProviderStateMixin{

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          GetAppBarUi(animationController: productsAnimationController,search: widget.search)),
    );
  }
}

class GetAppBarUi extends StatefulWidget {
  const GetAppBarUi({Key? key, this.animationController,this.search}) : super(key: key);
  final AnimationController? animationController;
  final String ? search;

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
print(widget.search);
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
    return Stack(
      children: [
        BlocProvider<SearchCubit>(
            create: (BuildContext context) => SearchCubit(SearchRepo()),
            child: ProductsList(animationController:widget.animationController,
              search: widget.search,
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
  const ProductsList({Key? key, this.animationController,this.mainScreenAnimationController,this.search=""}) : super(key: key);
  final AnimationController? animationController;
  final  String? search;
  final  Animation<double>? mainScreenAnimationController;

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
    SearchCubit productState = context.read<SearchCubit>();
    return SmartRefresher(
      header: WaterDropHeader(),

      controller: productState.controller,
      onLoading: (){
        productState.onLoad();
      },
      enablePullUp: true,
      enablePullDown: false,
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height:size.height * 0.02 ,),
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
                    Center(
                      child: SizedBox(
                        width: size.width * 0.74,
                        child: TextFormField(
                          cursorColor: AppTheme.secondary,

                          enableSuggestions: true,
                         // controller: productState.filter,
                          textAlign: TextAlign.start,
                          onChanged: (value){
                            if(value != '') {
                              SearchCubit.filterWord = value;
                              productState.allProducts = [];
                              productState.page = 1;
                              productState.onLoad();
                            }
                          },
                          initialValue: widget.search??"",
                          decoration: InputDecoration(
                              filled: true,

                              alignLabelWithHint: true,
                              fillColor: AppTheme.white,
                              hintStyle: TextStyle(fontSize: 15, color: AppTheme.grey,),
                              prefixIcon: Center(
                                child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16),
                                    child:Icon(Icons.search,size: size.width * .06,)
                                ),
                              ),
                              hintText:   LocaleKeys.search_title.tr(),
                              prefixIconConstraints: const BoxConstraints(maxHeight: 20, maxWidth: 50,),
                              isDense: true,
                              contentPadding:
                              const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                              prefixStyle: TextStyle(color: AppTheme.nearlyBlack,),
                              border: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(15)),
                                  borderSide: BorderSide.none)),
                          style:  TextStyle(fontSize: 15, color: AppTheme.grey,height: size.height * .003),
                        ),
                      ),
                    ),
                    // SizedBox(width: 60,),
                  ],
                ),
              ),
              BlocBuilder<SearchCubit, SearchState>(

                  builder: (context, state) {
                    if (state is SearchLoading && state.isFirstFetch) {
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

                    if (state is SearchLoading) {
                      products = state.OldProducts;
                      isLoading = true;
                    } else if (state is SearchLoaded) {
                      products = state.products;
                    }

                    SearchCubit productState = context.read<SearchCubit>();

                    return products.length ==0?
                    Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height *.21,),
                          lottie.Lottie.asset(
                              'assets/images/search.json',
                              height: size.height *.3,
                              width: 400),
                          SizedBox(height: size.height *.02,),
                          Text(
                            LocaleKeys.no_results.tr(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: size.height *.03,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ):
                      SafeArea(
                      child: ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [

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
                                          crossAxisCount: 2, childAspectRatio: 0.71),
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
                          ]
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