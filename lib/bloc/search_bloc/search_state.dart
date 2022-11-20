part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {
  final List<ProductModel> OldProducts;
  final bool isFirstFetch;

  SearchLoading(this.OldProducts, {this.isFirstFetch=false});
}


class SearchLoaded extends SearchState {
  final List<ProductModel> products ;
  const SearchLoaded({required this.products});
  @override
  List<Object> get props => [products];
}