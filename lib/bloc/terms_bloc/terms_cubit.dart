

import 'package:bloc/bloc.dart';
import 'package:loz/data/models/about.dart';
import 'package:loz/data/repositories/about_repo.dart';
import 'package:loz/data/repositories/terms_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:meta/meta.dart';


part 'terms_state.dart';

class TermsCubit extends Cubit<TermsState> {
  final TermsRepository termsRepository;

  TermsCubit(this.termsRepository) : super(TermsInitial()){
    getTerms();
  }
  AboutModel? terms ;

  Future getTerms()async{
    emit(TermsLoading());
    termsRepository.fetchTerms(LocalStorage.getData(key: 'lang')??'en').then((value) {
      terms = AboutModel.fromJson(value);
      emit(TermsLoaded(terms: terms!));
    });
  }

}
