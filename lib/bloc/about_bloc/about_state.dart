part of 'about_cubit.dart';


@immutable
abstract class AboutState {}

class AboutInitial extends AboutState {}

class AboutLoading extends AboutState {}

class AboutLoaded extends AboutState {
  AboutModel about ;
  AboutLoaded({required this.about});
}
