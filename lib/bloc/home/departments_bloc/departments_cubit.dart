import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:easy_localization/src/public_ext.dart';

import '../../../presentation/widgets/helper.dart';
part 'departments_state.dart';

class DepartmentsCubit extends Cubit<DepartmentsState> {
  final GetHomeRepository homeRepository;

  DepartmentsCubit(this.homeRepository,bool fromAll,context,String lang) : super(DepartmentsInitial()) {
    fromAll?
    onLoad():
    getDepartments(context,lang);


  }
  Random random = new Random();
  static int ?activeId;
List<CategoryModel> allDep=[];
  List<List<String>> colors = [["FFC400","FFB295"],['654ea3','eaafc8'],['74ebd5','ACB6E5'],['fffbd5','b20a2c'],[' E8CBC0','636FA4'],['22c1c3','fdbb2d'],['4AC29A','BDFFF3'],['2193b0','6dd5ed'],['ee9ca7','#ffdde1'],['FC5C7D','6A82FB'],["f953c6","b91d73"],['b92b27','1565C0'],['a8ff78','a8ff78']];
  static final List<GlobalObjectKey<FormState>> formKeyList = [];

  void getDepartments(context,String lang)async{
    emit(DepartmentLoading([],isFirstFetch: true));

    await homeRepository.fetchDepartmentsWithoutPagination(1).then((data) {
      if(data[0]['en'] == null){
        final departments = List<CategoryModel>.from(
            data.map((dep) => CategoryModel.fromJson(dep)));
        allDep =departments;
        for(int i=0; i< departments.length; i++) {
          formKeyList.add(GlobalObjectKey<FormState>(i));
          print(i);

        }
        emit(DepartmentLoaded(departments:departments ));
      }else{

        emit(DepartmentLoaded(departments:[] ));

      }
    });


  }

  int page =1;
  RefreshController controller = RefreshController();


  void onLoad()async{

    if (state is DepartmentLoading) return;

    final currentState = state;

    var oldDep = <CategoryModel>[];
    if (currentState is DepartmentLoaded) {
      oldDep= currentState.departments;
    }
    if(page == 1)
      oldDep=[];
    emit(DepartmentLoading(oldDep, isFirstFetch: page == 1));

    var data = await  homeRepository.fetchDepartments(page);
    List<CategoryModel> deps2 = List<CategoryModel>.from(
        data.map((dep) => CategoryModel.fromJson(dep)));
    page++;

    final departments = (state as DepartmentLoading).oldDeps;
    departments.addAll(deps2);

    emit(DepartmentLoaded(departments: departments));
    controller.loadComplete();


  }

  String getUnReadCount(){
    // emit(DepartmentsInitial());
    // emit(DepartmentLoaded(departments: allDep));
    return LocalStorage.getData(key: "unReadCount").toString();
  }
}


