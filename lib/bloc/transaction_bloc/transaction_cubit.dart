import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:loz/data/models/transaction_model.dart';
import 'package:loz/data/repositories/transaction_repo.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../local_storage.dart';


part 'transaction_state.dart';





class TransactionCubit extends Cubit<TransactionState> {
  final TransactionRepo transactionRepo;

  TransactionCubit(this.transactionRepo) : super(TransactionInitial()) {
    id = int.parse(LocalStorage.getData(key: "id").toString());
    print(id);
    onLoad();
  }
  int ?id ;
  int page =1;
  RefreshController controller = RefreshController();
  List<TransactionDataModel> allTransactions = [];
  void onLoad()async{

    if (state is TransactionLoading) return;

    final currentState = state;

    var oldPosts = <TransactionDataModel>[];
    if (currentState is TransactionLoaded) {
      oldPosts = currentState.products;
    }
    if(page == 1)
      oldPosts=[];
    emit(TransactionLoading(oldPosts, isFirstFetch: page == 1));

   // var data = await  transactionRepo.getTransactions(page);
    if(LocalStorage.getData(key: 'token') == null) {
      allTransactions = [];
      emit(TransactionLoaded(products: allTransactions));
    }else {
      var data = await transactionRepo.getTransactions(page);
      List<TransactionDataModel> products2 = List<TransactionDataModel>.from(
          data.map((dep) => TransactionDataModel.fromJson(dep)));
      page++;

      final products = (state as TransactionLoading).OldProducts;
      products.addAll(products2);
      allTransactions = products;
      controller.loadComplete();
      emit(TransactionLoaded(products: products));
    }
    }

    int trans = 0;
  void switchTrans(int tran){
    emit(TransactionInitial());
    trans = tran;
    print(trans);
    emit(TransactionLoaded(products: allTransactions));
  }
}