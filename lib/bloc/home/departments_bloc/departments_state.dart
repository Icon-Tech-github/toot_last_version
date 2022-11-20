part of 'departments_cubit.dart';



@immutable
abstract class DepartmentsState extends Equatable {}



class DepartmentsInitial extends DepartmentsState {

  @override
  List<Object> get props => [];

}



class DepartmentLoading extends DepartmentsState {
  final List<CategoryModel> oldDeps;
  final bool isFirstFetch;

  DepartmentLoading(this.oldDeps, {this.isFirstFetch=false});

  @override
  List<Object> get props => [];

}


class DepartmentLoaded extends DepartmentsState {
  final List<CategoryModel> departments ;
  DepartmentLoaded({required this.departments });

  @override
  List<Object> get props => [departments];
}

