part of 'home_notify_cubit.dart';



@immutable
abstract class HomeNotifyState  {}



class HomeNotifyInitial extends HomeNotifyState {

  @override
  List<Object> get props => [];

}



class HomeNotifyLoading extends HomeNotifyState {



  HomeNotifyLoading();

}


class HomeNotifyLoaded extends HomeNotifyState {
  String readCount ;
  HomeNotifyLoaded({required this.readCount });

}

