import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:loz/data/repositories/points_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:meta/meta.dart';

import '../../translations/locale_keys.g.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<BalanceState> {
  final PointsRepo pointsRepo;


  BalanceCubit(this.pointsRepo) : super(BalanceInitial());
  TextEditingController phone = TextEditingController();
  TextEditingController balance = TextEditingController();
  sendBalance() async {
    emit(BalanceLoading());
    await pointsRepo
        .sendBalance(
       LocalStorage.getData(key: "token"),
        phone.text,
        balance.text
    )
        .then((data) async {
      if(data == null){
        emit(BalanceFailure(error: "something went wrong"));
      }else  if (data ==  "406"){
        emit(BalanceFailure(error: LocaleKeys.not_enough.tr()));
      }else  if (data ==  "404"){
        emit(BalanceFailure(error: LocaleKeys.phone_not_found.tr()));
      }
      else {
        emit(BalanceSuccess());
      }
    });
  }

}
