

import 'package:bloc/bloc.dart';
import 'package:loz/data/models/about.dart';
import 'package:loz/data/repositories/about_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:meta/meta.dart';


part 'about_state.dart';

class AboutCubit extends Cubit<AboutState> {
  final AboutRepository aboutRepository;

  AboutCubit(this.aboutRepository) : super(AboutInitial()){
    getAbout();
  }
  AboutModel? about ;

  Future getAbout()async{
    emit(AboutLoading());
    aboutRepository.fetchAbout(LocalStorage.getData(key: 'lang')??'en').then((value) {
      about = AboutModel.fromJson(value);
      emit(AboutLoaded(about: about!));
    });
  }

}
