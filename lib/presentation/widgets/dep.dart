import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/presentation/widgets/single_department.dart';

class DepartmentsView extends StatefulWidget {
  DepartmentsView(
      {Key? key,
      this.mainScreenAnimationController,
      this.mainScreenAnimation,
      this.departments,
      this.colors})
      : super(key: key);

  final AnimationController? mainScreenAnimationController;
  final Animation<double>? mainScreenAnimation;
  List<CategoryModel>? departments;
  List<List<String>>? colors;

  @override
  _DepartmentsViewState createState() => _DepartmentsViewState();
}

class _DepartmentsViewState extends State<DepartmentsView>
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
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController!,
      builder: (BuildContext context, Widget? child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation!,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation!.value), 0.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * .36,
              child:

              StaggeredGridView.countBuilder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                crossAxisCount: 3,
                mainAxisSpacing: 0,
                crossAxisSpacing: 0,
                staggeredTileBuilder: (int index) =>
                new StaggeredTile.count(1,1.27),
                physics: NeverScrollableScrollPhysics(),
                // shrinkWrap: true,
                // scrollDirection: Axis.horizontal,
                //  physics: NeverScrollableScrollPhysics(),
                // gridDelegate:
                // const SliverGridDelegateWithFixedCrossAxisCount(
                //     crossAxisCount: 2, childAspectRatio: 1.9),
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 0, left: 0),
                itemCount: widget.departments!.length,
                //  scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      widget.departments!.length ;
                  final Animation<double> animation =
                  Tween<double>(begin: 0.0, end: 1.0).animate(
                      CurvedAnimation(
                          parent: animationController!,
                          curve: Interval((1 / count) * index, 1.0,
                              curve: Curves.fastOutSlowIn)));
                  animationController?.forward();

                  return Center(
                    child: SingleDepartmentWidget(
                      departments:  widget.departments,
                      productsAnimationController: productsAnimationController,
                      animation: animation,
                      animationController: animationController!,
                      department: widget.departments![index],
                      colors: widget.colors,
                      depIndex: index,

                    ),
                  );
                },
              ),
              // child:StaggeredGridView.countBuilder(
              //   shrinkWrap: true,
              //   scrollDirection: Axis.vertical,
              //   crossAxisCount: 4,
              //   mainAxisSpacing: 0,
              //   crossAxisSpacing: 0,
              //   staggeredTileBuilder: (int index) =>
              //   new StaggeredTile.count( tileMap[index % 3]!, double.parse(tileMap[index % 18].toString())),
              //     physics: NeverScrollableScrollPhysics(),
              //  //  gridDelegate:
              //  //  const SliverGridDelegateWithFixedCrossAxisCount(
              //  //      crossAxisCount: 2, childAspectRatio: 1.0),
              //   padding: const EdgeInsets.only(
              //       top: 0, bottom: 0, right: 0, left: 0),
              //   itemCount: widget.departments!.length,
              // //  scrollDirection: Axis.horizontal,
              //   itemBuilder: (BuildContext context, int index) {
              //     final int count =
              //     widget.departments!.length ;
              //     final Animation<double> animation =
              //     Tween<double>(begin: 0.0, end: 1.0).animate(
              //         CurvedAnimation(
              //             parent: animationController!,
              //             curve: Interval((1 / count) * index, 1.0,
              //                 curve: Curves.fastOutSlowIn)));
              //     animationController?.forward();
              //
              //     return Center(
              //       child: SingleDepartmentWidget(
              //         departments:  widget.departments,
              //         productsAnimationController: productsAnimationController,
              //         animation: animation,
              //         animationController: animationController!,
              //         department: widget.departments![index],
              //         colors: widget.colors,
              //         depIndex: index,
              //
              //       ),
              //     );
              //   },
              // ),
            ),
          ),
        );
      },
    );
  }
}
