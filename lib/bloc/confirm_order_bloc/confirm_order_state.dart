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