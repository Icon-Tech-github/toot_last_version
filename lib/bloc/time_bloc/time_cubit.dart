
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:loz/data/models/orders_model.dart';
import 'package:loz/data/repositories/delivery_time.dart';
import 'package:loz/data/repositories/orders_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:intl/intl.dart';

import '../../data/models/time.dart';
import '../../data/models/time.dart';
import '../../translations/locale_keys.g.dart';

part 'time_state.dart';

class TimeBlocCubit extends Cubit<TimeState> {
  final DeliveryTimeRepo timeRepository ;
  List<TimeData> allTimes = [];
  TimeBlocCubit(this.timeRepository) : super(TimeInitial()){
    getTime();
    LocalStorage.removeData(key: "deliveryTime");


  }

  void getTime()async{
    emit(TimeLoading());

    await timeRepository.getTime(LocalStorage.getData(key: "token")).then((data) {
        final times = List<TimeData>.from(
            data.map((time) => TimeData.fromJson(time)));
        allTimes =times;
        times[0].chosen =true;
        LocalStorage.saveData(key: "deliveryDate", value:allTimes[0].date.toString() );
print(allTimes[0].date.toString());
        emit(TimeLoaded(timeData: times));

    });


  }
  int daySelected =0;
  chooseDay( int i) {
    emit(TimeInitial());
    if (allTimes[i].chosen == null) allTimes[i].chosen = false;
    for (var element in allTimes) {
      element.chosen = false;
      for (var ele in element.daysTimes!) {
        ele.chosen = false;
      }
    }
    LocalStorage.removeData(key: "deliveryTime");

    allTimes[i].chosen = true;
    daySelected = i;
LocalStorage.saveData(key: "deliveryDate", value:allTimes[i].date.toString(), );
    emit(TimeLoaded(timeData: allTimes));



  }
  chooseTime( int i) {
    emit(TimeInitial());
    if(checkToday(allTimes[daySelected].date.toString()) == LocaleKeys.today.tr()) {
      if (calculateValidTime(
          allTimes[daySelected].daysTimes![i].fromTime.toString(),
          allTimes[daySelected].daysTimes![i].toTime.toString(),
          allTimes[daySelected].date.toString())) {
        if (allTimes[daySelected].daysTimes![i].chosen == null)
          allTimes[daySelected].daysTimes![i].chosen = false;
        for (var element in allTimes[daySelected].daysTimes!) {
          element.chosen = false;
        }


        allTimes[daySelected].daysTimes![i].chosen = true;
        LocalStorage.saveData(key: "deliveryTime",
            value: "${convertTime(allTimes[daySelected].daysTimes![i].fromTime
                .toString())} : ${convertTime(
                allTimes[daySelected].daysTimes![i].toTime.toString())}");
      }
    }else{
      if (allTimes[daySelected].daysTimes![i].chosen == null)
        allTimes[daySelected].daysTimes![i].chosen = false;
      for (var element in allTimes[daySelected].daysTimes!) {
        element.chosen = false;
      }


      allTimes[daySelected].daysTimes![i].chosen = true;
      LocalStorage.saveData(key: "deliveryTime",
          value: "${convertTime(allTimes[daySelected].daysTimes![i].fromTime
              .toString())} : ${convertTime(
              allTimes[daySelected].daysTimes![i].toTime.toString())}");

    }

    emit(TimeLoaded(timeData: allTimes));



  }
  String convertTime(String timer) {

    DateTime now = DateTime.now();
    String date = now.toString().substring(0,10);
    DateTime timeFormat = DateTime.parse( "$date ${timer}.000");

    DateFormat   format = DateFormat("hh:mm a");
    return format.format(timeFormat);

  }

  bool calculateValidTime(String timeFrom, String timeTo,String dateDelivery){
    DateTime now = DateTime.now();
    print(now);
   // String date = now.toString().substring(0,10);
    DateTime parseDate =
    Intl.withLocale('en', () => new DateFormat("yyyy-MM-dd").parse(dateDelivery));
    String date = parseDate.toString().substring(0,10);
    DateTime startDate = DateTime.parse("$date ${timeFrom}.000");
    DateTime endDate= DateTime.parse("$date ${timeTo}.000");
    print(endDate);
    if(now.isBefore(endDate)){
      print("object");
      return true;
    }
    else{
      print("objectuuu");

      return false;
    }
  }

  String checkToday (String date){
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);
    DateTime parseDate =
    Intl.withLocale('en', () => new DateFormat("yyyy-MM-dd").parse(date));
    final aDate = DateTime(parseDate.year, parseDate.month, parseDate.day);
    if(aDate == today) {
    return LocaleKeys.today.tr();

    } else if(aDate == tomorrow) {
    return    LocaleKeys.tomorrow.tr();
    }
    else
      return "";
  }
}
