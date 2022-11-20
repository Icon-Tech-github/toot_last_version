part of 'status_cubit.dart';



abstract class StatusState extends Equatable {
  const StatusState();
  @override
  List<Object> get props => [];
}

class StatusInitial extends StatusState {}

class StatusLoading extends StatusState {}
class FrontLoading extends StatusState {
  final TrackData status ;
  const FrontLoading({required this.status});
  @override
  List<Object> get props => [status];
}

class StatusLoaded extends StatusState {
  final TrackData status ;
  const StatusLoaded({required this.status});
  @override
  List<Object> get props => [status];
}