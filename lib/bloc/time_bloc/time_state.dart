part of 'time_cubit.dart';

@immutable
abstract class TimeState {}

class TimeInitial extends TimeState {}

class TimeLoading extends TimeState {

}


class TimeLoaded extends TimeState {
  List<TimeData> timeData;
  TimeLoaded({required this.timeData});
}
