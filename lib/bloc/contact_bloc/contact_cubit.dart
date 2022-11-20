import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:loz/data/repositories/contact_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:meta/meta.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  final ContactRepo contactRepo;


  ContactCubit(this.contactRepo) : super(ContactInitial());
  TextEditingController phone = TextEditingController(text: LocalStorage.getData(key: "phone")??"");
  TextEditingController email = TextEditingController();
  TextEditingController massage = TextEditingController();
  contact() async {
    emit(ContactLoading());
    await contactRepo
        .contactUs(
      message: massage.text,
      phone: phone.text,
      email: email.text
    )
        .then((data) async {
      if(data == null){
        emit(ContactFailure(error: "something went wrong"));
      }else {
        emit(ContactSuccess());
      }
    });
  }

}
