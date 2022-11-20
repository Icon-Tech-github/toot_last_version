part of 'rate_cubit.dart';

@immutable
abstract class RateState {}

class RateInitial extends RateState {}


class RateLoading extends RateState {}

class RateSuccess extends RateState {}
class RateLoaded extends RateState {}
class RateFailure extends RateState {
  final String error;
  RateFailure({required this.error});
}
