import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/local_storage.dart';

import '../../../data/models/products.dart';

part 'recomend_state.dart';

class RecommendCubit extends Cubit<RecommendState> {
  final GetHomeRepository homeRepository;

  RecommendCubit(this.homeRepository) : super(RecommendInitial()) {
    getRecommend();
    //getBranchData();
  }
  Random random = new Random();
List<ProductModel> allRecommend=[];
  List<List<String>> colors = [["FFC400","FFB295"],['654ea3','eaafc8'],['74ebd5','ACB6E5'],['fffbd5','b20a2c'],[' E8CBC0','636FA4'],['22c1c3','fdbb2d'],['4AC29A','BDFFF3'],['2193b0','6dd5ed'],['ee9ca7','#ffdde1'],['FC5C7D','6A82FB'],["f953c6","b91d73"],['b92b27','1565C0'],['a8ff78','a8ff78']];

  void getRecommend()async{
    emit(RecommendLoading());

    var data = await homeRepository.fetchRecommendation();
    final recommends = List<ProductModel>.from(
        data.map((dep) => ProductModel.fromJson(dep)));
    allRecommend = recommends;
    emit(RecommendLoaded(recommends:recommends ));
  }
  void favToggle(int id,index) {
    //   emit(FavToggle(product: globalProduct!));
    emit(RecommendInitial());
    var data = homeRepository.favToggle(id);
    print(data);
    if (allRecommend[index].inFavourite == 0 && data != null) {
      allRecommend[index].inFavourite = 1;
      print("llllll");
    } else if (allRecommend[index].inFavourite == 1 && data != null) {
      allRecommend[index].inFavourite = 0;
    } else {
      print("llllkkkkkkll");
    }
    emit(RecommendLoaded(recommends: allRecommend));
  }
  // void getBranchData()async{
  //   //  emit(DepartmentLoading());
  //
  //   await homeRepository.fetchBranchData().then((value) {
  //     LocalStorage.saveData(key: "lat", value: value['lat']);
  //     LocalStorage.saveData(key: "long", value: value['long']);
  //     print( value['long']);
  //   }
  //   );
  //
  //   // emit(DepartmentLoaded(departments:departments ));
  // }
}


