import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loz/data/models/branch_model.dart';
import 'package:loz/data/models/department_model.dart';
import 'package:loz/data/repositories/branch_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:loz/presentation/screens/bottom_nav.dart';
import 'package:loz/presentation/widgets/helper.dart';
import 'package:meta/meta.dart';

import '../../translations/locale_keys.g.dart';

part 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  final GetBranchesRepository branchesRepository;

  BranchesCubit(this.branchesRepository) : super(BranchesInitial()) {
  // getBranches();
  }
  Random random = new Random();
  final List<String> items = [
    'Alexandria',
    'Almadina-Elselmia',
    'Madina-Elrwabi',
    'Najran',
  ];
  bool isLoad = false ;
  static var branches;
  String? selectedValue ="Alexandria";
  List<List<String>> colors = [["FFC400","FFB295"],['654ea3','eaafc8'],['74ebd5','ACB6E5'],['fffbd5','b20a2c'],[' E8CBC0','636FA4'],['22c1c3','fdbb2d'],['4AC29A','BDFFF3'],['2193b0','6dd5ed'],['ee9ca7','#ffdde1'],['FC5C7D','6A82FB'],["f953c6","b91d73"],['b92b27','1565C0'],['a8ff78','a8ff78']];

  void getBranches(String? lat,String? long,context, bool isToHome)async{
    emit(BranchesLoading());
    if( !isToHome)
isLoad = true;
  await branchesRepository.fetchBranchData(lat??"",long??"").then((data) {
      branches = List<BranchModel>.from(
        data.map((branch) => BranchModel.fromJson(branch)));
    LocalStorage.saveData(key: "branchId", value: branches[0].id);
      LocalStorage.saveData(key: "branchLat", value: branches[0].lat);
      LocalStorage.saveData(key: "branchLong", value: branches[0].long);

      if( isToHome)
    pushReplacement(context, BottomNavBar(branches: branches,fromSplash: true,));
   else{
     showDialogBranch(context, LocaleKeys.select_branch.tr(), false, context,branches);
   }

    emit(BranchesLoaded(branches:branches ));
   isLoad = false;

  });


  }


  // getUserLocation() async {
  //   // Position position = await Geolocator.getCurrentPosition();
  //   currentLocation = await locateUser();
  //   setState(() {
  //     LocalStorage.saveData(key: "lat", value: currentLocation!.latitude);
  //     LocalStorage.saveData(key: "lng", value: currentLocation!.longitude);
  //
  //     lat = currentLocation!.latitude;
  //     lng = currentLocation!.longitude;
  //   });
  // }

  Future<Position> locateUser() async {
    await Geolocator.requestPermission();
    return Geolocator.getCurrentPosition();
  }
}


