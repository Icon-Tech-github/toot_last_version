import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:loz/bloc/products_bloc/products_cubit.dart';
import 'package:loz/data/models/order_track_model.dart';
import 'package:loz/data/models/points_model.dart';
import 'package:loz/data/repositories/points_repo.dart';
import 'package:loz/data/repositories/tracking_repo.dart';
import 'package:loz/local_storage.dart';

part 'points_state.dart';





class PointsCubit extends Cubit<PointsBlocState> {
  final PointsRepo pointsRepo;

  PointsCubit(this.pointsRepo) : super(PointsInitial()) {
    getPoints();
  }

  PointsData? points ;
  int pointOrders=1;

  Future getPoints()async{
    emit(PointsLoading());
    pointsRepo.getPoints(LocalStorage.getData(key: 'token')).then((value) {
      points = PointsData.fromJson(value);
      emit(PointsLoaded(points: points!));
    });
  }
  void switchPoints(int pointOrdersId){
    emit(PointsInitial());
      pointOrders = pointOrdersId;
    emit(PointsLoaded(points: points!));
  }
  Future convertPoints()async{
 //   emit(PointsLoading());
    pointsRepo.convertPoints(LocalStorage.getData(key: 'token')).then((value) {
      if(value == true)
        getPoints();
    //  emit(PointsLoaded(points: points!));
    });
  }

}


