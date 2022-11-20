part of 'cars_cubit.dart';

@immutable
abstract class CarsState  {}



class CarsInitial extends CarsState {



}



class CarsLoading extends CarsState {



}






class CarsLoaded extends CarsState {
  final List<CarsModel> cars ;
  CarsLoaded({required this.cars });


}


class AddCarFailure extends CarsState {
  final String error;
  AddCarFailure({required this.error});
}

class AddCarsLoaded extends CarsState{

}
