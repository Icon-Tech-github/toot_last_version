part of 'transaction_cubit.dart';

abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {
  final List<TransactionDataModel> OldProducts;
  final bool isFirstFetch;

  TransactionLoading(this.OldProducts, {this.isFirstFetch=false});
}


class TransactionLoaded extends TransactionState {
  final List<TransactionDataModel> products ;
  const TransactionLoaded({required this.products});
  @override
  List<Object> get props => [products];
}