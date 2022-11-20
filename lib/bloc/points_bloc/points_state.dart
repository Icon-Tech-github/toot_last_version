part of 'points_cubit.dart';


@immutable
abstract class PointsBlocState {}

class PointsInitial extends PointsBlocState {}

class PointsLoading extends PointsBlocState {

}


class PointsLoaded extends PointsBlocState {
  PointsData points;
 PointsLoaded({required this.points});
}
