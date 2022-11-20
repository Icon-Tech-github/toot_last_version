part of 'order_method_cubit.dart';

@immutable
abstract class OrderMethodState  {}



class OrderMethodInitial extends OrderMethodState {



}



class OrderMethodLoading extends OrderMethodState {



}


class OrderMethodLoaded extends OrderMethodState {
  final List<OrderMethodModel> orderMethods ;
  final List<OrderMethodModel> paymentMethods;


  OrderMethodLoaded({required this.orderMethods,required this.paymentMethods });


}


class PaymentMethodInitial extends OrderMethodState {}
class PaymentMethodLoading extends OrderMethodState {}

class PaymentMethodLoaded extends OrderMethodState {
  final List<OrderMethodModel> paymentMethods;

  PaymentMethodLoaded({required this.paymentMethods });
}