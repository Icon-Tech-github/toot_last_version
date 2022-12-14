part of 'contact_cubit.dart';


@immutable
abstract class ContactState {}

class ContactInitial extends ContactState {}

class ContactLoading extends ContactState {}
class ContactDataLoading extends ContactState {}

class ContactSuccess extends ContactState {

}
class ContactDataLoaded extends ContactState {

}
class ContactFailure extends ContactState {
  final String error;
  ContactFailure({required this.error});
}
