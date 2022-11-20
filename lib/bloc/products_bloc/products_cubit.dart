import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/products_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../presentation/widgets/helper.dart';

part 'products_state.dart';





class ProductsCubit extends Cubit<ProductsState> {
  final ProductsRepo productsRepository;

  ProductsCubit(this.productsRepository,int id,context,lang) : super(ProductsInitial()) {
    onLoad(id,context,lang);
  }
//List<ProductModel> products =[];
  int page =1;
  RefreshController controller = RefreshController();
  // void getProducts(int id, int page)async{
  //   print(id);
  //   emit(ProductsLoading());
  //   var data = await  productsRepository.getProducts(id, page);
  //    products = List<ProductModel>.from(
  //       data.map((dep) => ProductModel.fromJson(dep)));
  //   print('sssssssssss');
  //   emit(ProductsLoaded(products:products ));
  // }
  List<ProductModel> allProducts = [];
  void onLoad(int id,context,lang)async{

    if (state is ProductsLoading) return;

    final currentState = state;

    var oldPosts = <ProductModel>[];
    if (currentState is ProductsLoaded) {
      oldPosts = currentState.products;
    }
if(page == 1)
  oldPosts=[];
    emit(ProductsLoading(oldPosts, isFirstFetch: page == 1));

    var data = await  productsRepository.getProducts(id, page);
if(data.length !=0){
    if(data[0]['en'] == null){
      List<ProductModel> products2 = List<ProductModel>.from(
          data.map((dep) => ProductModel.fromJson(dep)));
      page++;

      final products = (state as ProductsLoading).OldProducts;
      products.addAll(products2);
      allProducts = products;
      controller.loadComplete();
      emit(ProductsLoaded(products: products));
    }else{
      showDialogBranchClosed(context, lang== 'ar'?data[0]['ar'].toString() : data[0]['en'].toString(),true);

      emit(ProductsLoaded(products: []));

    }}else{
  List<ProductModel> products2 = List<ProductModel>.from(
      data.map((dep) => ProductModel.fromJson(dep)));
  page++;

  final products = (state as ProductsLoading).OldProducts;
  products.addAll(products2);
  allProducts = products;
  controller.loadComplete();
  emit(ProductsLoaded(products: products));
    }





  }

  void favToggle(int id,index) {
    emit(ProductsInitial());
    var data = productsRepository.favToggle(id);
    print(data);
    if (allProducts[index].inFavourite == 0 && data != null) {
      allProducts[index].inFavourite  = 1;
      print("llllll");
    } else if (allProducts[index].inFavourite  == 1 && data != null) {
      allProducts[index].inFavourite  = 0;
    } else {
      print("llllkkkkkkll");
    }
    emit(ProductsLoaded(products: allProducts));
  }
}


