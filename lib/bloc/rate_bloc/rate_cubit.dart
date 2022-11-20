
import 'package:bloc/bloc.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/data/repositories/rating_repo.dart';

import 'package:meta/meta.dart';

part 'rate_state.dart';

class RateCubit extends Cubit<RateState> {
  final RatingRepository ratingRepository;


  TextEditingController comment = TextEditingController();



  RateCubit(this.ratingRepository) : super(RateInitial()){

  }


  String branchRating = "3";
  String foodRating = "3";
  rateOrder(int orderId

      ) async {
    emit(RateLoading());
    await ratingRepository
        .rateOrder(
        comment: comment.text,
        orderId: "$orderId",
        foodRate: foodRating.toString(),
      restaurantRate: branchRating.toString()
    )
        .then((data) async {
      if(data == null){
        emit(RateFailure(error: "not valid"));
      }else {

        emit(RateSuccess());
      }
    });
  }


setBranchRating(String rate){
  emit(RateInitial());
  branchRating = rate;
  emit(RateLoaded());
}
  setFoodRating(String rate){
    emit(RateInitial());
    foodRating = rate;
    emit(RateLoaded());
  }
}
