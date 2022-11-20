part of 'single_product_cubit.dart';

@immutable
abstract class SingleProductState extends Equatable{
  @override
  List<Object> get props => [];
}

class SingleProductInitial extends SingleProductState {}

class AttributesLoading extends SingleProductState {}


class AttributesLoaded extends SingleProductState {
  final ProductModel product ;
  AttributesLoaded({required this.product});
  @override
  List<Object> get props => [product];

}

class FavToggle extends SingleProductState {
  final ProductModel product ;
  FavToggle({required this.product});
  @override
  List<Object> get props => [product];

}

