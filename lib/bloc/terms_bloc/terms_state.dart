part of 'terms_cubit.dart';


@immutable
abstract class TermsState {}

class TermsInitial extends TermsState {}

class TermsLoading extends TermsState {}

class TermsLoaded extends TermsState {
  AboutModel terms ;
  TermsLoaded({required this.terms});
}
