part of 'orders_bloc_cubit.dart';

@immutable
abstract class OrdersBlocState {}

class OrdersInitial extends OrdersBlocState {}

class OrdersLoading extends OrdersBlocState {
  final List<Orders> OldOrders;
  final bool isFirstFetch;

  OrdersLoading(this.OldOrders, {this.isFirstFetch=false});
}


class OrdersLoaded extends OrdersBlocState {
List<Orders> orders;
OrdersLoaded({required this.orders});
}
