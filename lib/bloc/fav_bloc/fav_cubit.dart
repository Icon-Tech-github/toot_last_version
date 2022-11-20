import 'package:bloc/bloc.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:loz/data/models/fav_model.dart';
import 'package:loz/data/repositories/fav_reoo.dart';
import 'package:loz/translations/locale_keys.g.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../local_storage.dart';

part 'fav_state.dart';





class FavoriteCubit extends Cubit<FavoriteState> {
  final FavoriteRepo favoriteRepository;

  FavoriteCubit(this.favoriteRepository) : super(FavoriteInitial()) {
    onLoad();
  }
  int page =1;
  List<List<String>> colors = [["FFC400","FFB295"],['654ea3','eaafc8'],['74ebd5','ACB6E5'],['fffbd5','b20a2c'],[' E8CBC0','636FA4'],['22c1c3','fdbb2d'],['4AC29A','BDFFF3'],['2193b0','6dd5ed'],['ee9ca7','#ffdde1'],['FC5C7D','6A82FB'],["f953c6","b91d73"],['b92b27','1565C0'],['a8ff78','a8ff78'],["FFC400","FFB295"],['654ea3','eaafc8'],['74ebd5','ACB6E5'],['fffbd5','b20a2c']];

  RefreshController controller = RefreshController();
List<FavoriteModel> allFav = [];
  void onLoad()async{

    if (state is FavoriteLoading) return;

    final currentState = state;

    var oldPosts = <FavoriteModel>[];
    if (currentState is FavoriteLoaded) {
      oldPosts = currentState.products;
    }
print(oldPosts.toString());
    emit(FavoriteLoading(oldPosts, isFirstFetch: page == 1));
    if(LocalStorage.getData(key: 'token') == null) {
      allFav = [];
      emit(FavoriteLoaded(products: allFav));
    }else {
      var data = await favoriteRepository.getFav(page);
      List<FavoriteModel> products2 = List<FavoriteModel>.from(
          data.map((dep) => FavoriteModel.fromJson(dep)));
      page++;

      final products = (state as FavoriteLoading).OldProducts;
      products.addAll(products2);
      allFav = products;
      controller.loadComplete();
      emit(FavoriteLoaded(products: products));
    }

  }

  void favToggle(int id,context)async{
    emit(FavoriteLoading(allFav));
    Size size = MediaQuery.of(context).size;
    favoriteRepository.favToggle(id).then((data) {
    if( data != null) {
      showTopSnackBar(
          context,
          Card(
            child: CustomSnackBar.success(
              message: LocaleKeys.remove_success.tr(),
              backgroundColor: Colors.white,
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: size.height * 0.04),
            ),
          ));
      for(int n =0; n< allFav.length; n++) {
        if(allFav[n].productId == id){
          allFav.removeAt(n);
          break;
        }
      }
      emit(FavoriteLoaded(products: allFav));

    }else{
      print("llllkkkkkkll");

    }});
  }
}


