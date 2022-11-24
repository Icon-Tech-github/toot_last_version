part of 'confirm_order_cubit.dart';


@immutable
abstract class ConfirmOrderState {}

class ConfirmOrderInitial extends ConfirmOrderState {}

class ConfirmOrderLoading extends ConfirmOrderState {}

class ConfirmOrderLoaded extends ConfirmOrderState {
  List<ProductModel> products  ;
  ConfirmOrderLoaded({this.products = const []});
}
class ConfirmLoading extends ConfirmOrderState {}
class ConfirmSuccess extends ConfirmOrderState {}

class ConfirmFailure extends ConfirmOrderState {
  final String error;
  ConfirmFailure({required this.error});
}
class AddCouponLoading extends ConfirmOrderState {}
class UseBalanceLoading extends ConfirmOrderState {}
class AddCouponSuccess extends ConfirmOrderState {
  CouponModel coupon  ;
  AddCouponSuccess({required this.coupon});

}
class AddCouponFailure extends ConfirmOrderState {
  final String error;
  AddCouponFailure({required this.error});
}
class UseBalanceFailure extends ConfirmOrderState {
  final String error;
  UseBalanceFailure({required this.error});
}
class UseBalanceSuccess extends ConfirmOrderState {
  final String balance;
  UseBalanceSuccess({required this.balance});
}