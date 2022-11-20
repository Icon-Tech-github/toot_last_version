import 'dart:math';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:meta/meta.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:easy_localization/src/public_ext.dart';

import '../../../presentation/widgets/helper.dart';
part 'home_notify_state.dart';

class HomeNotifyCubit extends Cubit<HomeNotifyState> {

  HomeNotifyCubit() : super(HomeNotifyInitial()) {
    getUnReadCount();
  }

static String ?read ;

    getUnReadCount(){
    emit(HomeNotifyLoading());

    // emit(DepartmentLoaded(departments: allDep));
   String readCount=  LocalStorage.getData(key: "unReadCount").toString();
   read = readCount;
   print(readCount+"ggggggggggggggg");
    emit(HomeNotifyLoaded(readCount: readCount));

  }
}


