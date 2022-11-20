part of 'balance_cubit.dart';


@immutable
abstract class BalanceState {}

class BalanceInitial extends BalanceState {}

class BalanceLoading extends BalanceState {}

class BalanceSuccess extends BalanceState {

}
class BalanceFailure extends BalanceState {
  final String error;
  BalanceFailure({required this.error});
}
