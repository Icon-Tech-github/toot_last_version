part of 'notification_cubit.dart';



abstract class NotificationState extends Equatable {
  const NotificationState();
  @override
  List<Object> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {
  final List<NotificationData> OldNotifications;
  final bool isFirstFetch;

  NotificationLoading(this.OldNotifications, {this.isFirstFetch=false});
}


class NotificationLoaded extends NotificationState {
  final List<NotificationData> notifications ;
  const NotificationLoaded({required this.notifications});
  @override
  List<Object> get props => [notifications];
}