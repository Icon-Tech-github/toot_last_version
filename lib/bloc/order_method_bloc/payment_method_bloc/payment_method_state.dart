part of 'payment_method_cubit.dart';

@immutable
abstract class PaymentMethodState {}

class PaymentMethodInitial extends PaymentMethodState {}
class PaymentMethodLoading extends PaymentMethodState {}

class PaymentMethodLoaded extends PaymentMethodState {
  final List<OrderMethodModel> paymentMethods ;
  PaymentMethodLoaded({required this.paymentMethods });

  @override
  List<Object> get props => [paymentMethods];
}




