part of 'orders_bloc_cubit.dart';

@immutable
abstract class OrdersBlocState {}

class OrdersInitial extends OrdersBlocState {}

class OrdersLoading extends OrdersBlocState {
  final List<Orders> OldOrders;
  final List<Orders> oldCurrentOrders ;
  final List<Orders> oldAcceptedOrders ;
  final List<Orders> oldHistoryOrders ;
  final bool isFirstFetch;

  OrdersLoading(this.OldOrders,this.oldCurrentOrders,this.oldAcceptedOrders,this.oldHistoryOrders, {this.isFirstFetch=false});
}


class OrdersLoaded extends OrdersBlocState {
List<Orders> orders;
List<Orders> currentOrders;
List<Orders> acceptedOrders ;
List<Orders> historyOrders ;
OrdersLoaded({required this.orders,required this.historyOrders,required this.acceptedOrders,required this.currentOrders});
}
