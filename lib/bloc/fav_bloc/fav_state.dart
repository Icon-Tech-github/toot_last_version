part of 'fav_cubit.dart';


abstract class FavoriteState extends Equatable {
  const FavoriteState();
  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {
  final List<FavoriteModel> OldProducts;
  final bool isFirstFetch;

  FavoriteLoading(this.OldProducts, {this.isFirstFetch=false});
}


class FavoriteLoaded extends FavoriteState {
  final List<FavoriteModel> products ;
  const FavoriteLoaded({required this.products});
  @override
  List<Object> get props => [products];
}