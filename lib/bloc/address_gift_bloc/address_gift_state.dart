part of 'address_gift_cubit.dart';

@immutable
abstract class AddressGiftState  {}




class AddressGiftInitial extends AddressGiftState {

}

class AddressesGiftLoading extends AddressGiftState{}


class AddressesGiftLoaded extends AddressGiftState {
  final List<AddressModel> address ;
  AddressesGiftLoaded({required this.address });


}
class AddAddressGiftFailure extends AddressGiftState {
  final String error;
  AddAddressGiftFailure({required this.error});
}

class AddAddressGiftLoaded extends AddressGiftState{

}