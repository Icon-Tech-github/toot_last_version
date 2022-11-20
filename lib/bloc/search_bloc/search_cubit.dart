import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/search.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


part 'search_state.dart';





class SearchCubit extends Cubit<SearchState> {
  final SearchRepo searchRepo;

  SearchCubit(this.searchRepo) : super(SearchInitial()) {
    onLoad();
  }
  int page =1;
  RefreshController controller = RefreshController();
  TextEditingController filter = TextEditingController();
  static String filterWord ='';
  List<ProductModel> allProducts = [];
  void onLoad()async{

    if (state is SearchLoading) return;

    final currentState = state;

    var oldPosts = <ProductModel>[];
    if (currentState is SearchLoaded) {
      oldPosts = currentState.products;
    }
    if(page == 1)
      oldPosts=[];
    emit(SearchLoading(oldPosts, isFirstFetch: page == 1));

    var data = await  searchRepo.getProductsSearch(filterWord, page);
    if(data.length !=0){
      if(data[0]['en'] == null){
        List<ProductModel> products2 = List<ProductModel>.from(
            data.map((dep) => ProductModel.fromJson(dep)));
        page++;

        final products = (state as SearchLoading).OldProducts;
        products.addAll(products2);
        allProducts = products;
        controller.loadComplete();
        emit(SearchLoaded(products: products));
      }else{

        emit(SearchLoaded(products: []));

      }}else{
      List<ProductModel> products2 = List<ProductModel>.from(
          data.map((dep) => ProductModel.fromJson(dep)));
      page++;

      final products = (state as SearchLoading).OldProducts;
      products.addAll(products2);
      allProducts = products;
      controller.loadComplete();
      emit(SearchLoaded(products: products));
    }





  }
  void search ()async{
    allProducts = [];
    page =1;

  }

  void favToggle(int id,index) {
    emit(SearchInitial());
    var data = searchRepo.favToggle(id);
    print(data);
    if (allProducts[index].inFavourite == 0 && data != null) {
      allProducts[index].inFavourite  = 1;
      print("llllll");
    } else if (allProducts[index].inFavourite  == 1 && data != null) {
      allProducts[index].inFavourite  = 0;
    } else {
      print("llllkkkkkkll");
    }
    emit(SearchLoaded(products: allProducts));
  }
}


