part of 'recomend_cubit.dart';



@immutable
abstract class RecommendState extends Equatable {}



class RecommendInitial extends RecommendState {

  @override
  List<Object> get props => [];

}



class RecommendLoading extends RecommendState {

  @override
  List<Object> get props => [];

}


class RecommendLoaded extends RecommendState {
  final List<ProductModel> recommends ;
  RecommendLoaded({required this.recommends });

  @override
  List<Object> get props => [recommends];
}

