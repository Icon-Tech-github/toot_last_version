part of 'home_ad_cubit.dart';

@immutable
abstract class HomeAdState extends Equatable {}



class HomeAdInitial extends HomeAdState {

  @override
  List<Object> get props => [];

}

class HomeAdLoading extends HomeAdState {

  @override
  List<Object> get props => [];

}


class HomeAdLoaded extends HomeAdState {
  final List<HomeAdModel> ads ;
  HomeAdLoaded({required this.ads });

  @override
  List<Object> get props => [ads];
}

