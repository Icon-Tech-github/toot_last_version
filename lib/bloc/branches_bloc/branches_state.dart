part of 'branches_cubit.dart';



@immutable
abstract class BranchesState extends Equatable {}



class BranchesInitial extends BranchesState {

  @override
  List<Object> get props => [];

}



class BranchesLoading extends BranchesState {

  @override
  List<Object> get props => [];

}


class BranchesLoaded extends BranchesState {
  final List<BranchModel> branches ;
  BranchesLoaded({required this.branches });

  @override
  List<Object> get props => [branches];
}

