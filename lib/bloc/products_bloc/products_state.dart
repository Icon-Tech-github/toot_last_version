part of 'products_cubit.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();
  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {
  final List<ProductModel> OldProducts;
  final bool isFirstFetch;

  ProductsLoading(this.OldProducts, {this.isFirstFetch=false});
}


class ProductsLoaded extends ProductsState {
final List<ProductModel> products ;
 const ProductsLoaded({required this.products});
 @override
 List<Object> get props => [products];
}