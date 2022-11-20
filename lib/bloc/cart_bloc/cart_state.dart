part of 'cart_cubit.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartLoading extends CartState {}
class AddCouponLoading extends CartState {}
class UseBalanceLoading extends CartState {}
class AddCouponSuccess extends CartState {
  CouponModel coupon  ;
  AddCouponSuccess({required this.coupon});

}
class AddCouponFailure extends CartState {
  final String error;
  AddCouponFailure({required this.error});
}
class UseBalanceFailure extends CartState {
  final String error;
  UseBalanceFailure({required this.error});
}
class UseBalanceSuccess extends CartState {
  final String balance;
  UseBalanceSuccess({required this.balance});
}
class CartLoaded extends CartState {
  List<ProductModel> products  ;
  CartLoaded({this.products = const []});
}
