import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loz/data/models/notification.dart';
import 'package:loz/data/repositories/notification_repo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';


import '../../local_storage.dart';

part 'notification_state.dart';





class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepo notificationRepo;

  NotificationCubit(this.notificationRepo) : super(NotificationInitial()) {
    onLoad();
  }
  int page =1;

  RefreshController controller = RefreshController();
  List<NotificationData> allNotifications = [];
  void onLoad()async{

    if (state is NotificationLoading) return;

    final currentState = state;

    var oldNotifications = <NotificationData>[];
    if (currentState is NotificationLoaded) {
      oldNotifications = currentState.notifications;
    }
    print(oldNotifications.toString());
    emit(NotificationLoading(oldNotifications, isFirstFetch: page == 1));
    if(LocalStorage.getData(key: 'token') == null) {
      allNotifications = [];
      emit(NotificationLoaded(notifications: allNotifications));
    }else {
      var data = await notificationRepo.getNotification(page);
      List<NotificationData> notifications2 = List<NotificationData>.from(
          data.map((dep) => NotificationData.fromJson(dep)));
      page++;

      final notifications = (state as NotificationLoading).OldNotifications;
      notifications.addAll(notifications2);
      allNotifications = notifications;
      controller.loadComplete();
      emit(NotificationLoaded(notifications: notifications));
    }

  }
  void reed(List<int>id,List<int> index)async{
    emit(NotificationInitial());
    notificationRepo.reed(id).then((data) {
      if( data != null) {
        for(int i=0; i< index.length ; i++){
          allNotifications[index[i]].readAt =1;
        }

     emit(NotificationLoaded(notifications: allNotifications));
      }else{
        print("llllkkkkkkll");

      }});
  }

}


