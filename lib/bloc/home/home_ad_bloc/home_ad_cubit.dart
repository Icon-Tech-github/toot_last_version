import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/models/home_ad_model.dart';
import 'package:loz/data/repositories/home_repo.dart';
import 'package:meta/meta.dart';

part 'home_ad_state.dart';

class HomeAdCubit extends Cubit<HomeAdState> {
  final GetHomeRepository homeRepository;

  HomeAdCubit(this.homeRepository) : super(HomeAdInitial()) {
    getAds();
  }


  void getAds()async{
    emit(HomeAdLoading());
    var data= await homeRepository.fetchAds();
    final ads = List<HomeAdModel>.from(
        data.map((ads) => HomeAdModel.fromJson(ads)));
    emit(HomeAdLoaded(ads: ads));
  }

}


