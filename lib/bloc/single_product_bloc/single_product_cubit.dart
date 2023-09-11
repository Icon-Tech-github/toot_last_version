import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loz/data/models/attributes_model.dart';
import 'package:loz/data/models/products.dart';
import 'package:loz/data/repositories/single_product_repo.dart';
import 'package:loz/local_storage.dart';
import 'package:meta/meta.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../../presentation/widgets/helper.dart';
import '../../translations/locale_keys.g.dart';
part 'single_product_state.dart';

class SingleProductCubit extends Cubit<SingleProductState> {
  final SingleProductRepo singleProductRepo;
  ProductModel? globalProduct;
  static int? cartCount;
  int? isFav;
  bool inCart = false;
  int itemCount = 1;
  bool isLoad = true;
  TextEditingController notes = TextEditingController();
  List<Attributes> attributes = [];
  List<Addon> addon = [];

  List<double> attributePrices = [];
  List<double> addonPrices = [];
  double price = 0.0;
  double initialPrice = 0;

  static SingleProductCubit get(context) => BlocProvider.of(context);

  SingleProductCubit(this.singleProductRepo, int id,context,lang)
      : super(SingleProductInitial()) {
    getAttributes(id,context,lang);
    getCartCount();
  }

  void getAttributes(int id,context,lang) async {
    emit(AttributesLoading());
    //if(singleProductRepo.fetchProduct(id) != null)
    var data = await singleProductRepo.fetchProduct(id);
    if(data['en'] == null){


    final product = ProductModel.fromJson(data);
    globalProduct = product;
    if (product.newPrice != 0) {
      price = product.newPrice ?? 0;
    } else {
      price = product.price ?? 0;
    }
    print(price.toString() + "price");
    int i = 0;
    ////////////add first size//////////////
    for (var element in product.attributes!) {
      attributePrices.add(0.0);
      if (element.required == 1) {
        element.values![0].chosen = true;
        attributes.add(Attributes(
            id: element.id,
            title: element.title,
            multiSelect: 0,
            overridePrice: element.overridePrice,
            required: element.overridePrice,
            values: [
              Values(
                id: element.values![0].id,
                price: element.values![0].price,
                attributeValue: element.values![0].attributeValue,
              )
            ]));
        if (element.overridePrice == 1) {
          initialPrice = element.values![0].price!;
          price = initialPrice;
          print(price.toString() + "jjj");
        } else {
          print(price.toString() + "kkk");
          attributePrices[i] = element.values![0].price!;
          print(attributePrices);
          print(price);
          reCalculatePrices();
        }
      }
      i++;
    }
    for (var element in product.addons!) {
      addonPrices.add(0.0);
    }

    emit(AttributesLoaded(product: product));
    isLoad = false;
    }else{

     // emit(AttributesLoaded(product: ""));

    }
  }

  void reCalculatePrices() {
    print(price);
    if (initialPrice == 0) {
      price = (globalProduct?.newPrice != 0
              ? (globalProduct?.newPrice)
              : (globalProduct?.price)) *
          (itemCount);
    } else {
      price = initialPrice * (globalProduct?.count ?? 1);
    }

    for (int n = 0; n < attributePrices.length; n++) {
      price = price + attributePrices[n] * (globalProduct?.count ?? 1);
    }
    for (int n = 0; n < addonPrices.length; n++) {
      price = price + addonPrices[n] * (globalProduct?.count ?? 1);
    }
    print(price);
  }

  void switchSingleSelect(int attributeIndex, List<Values> list, int i) {
    emit(SingleProductInitial());

    if (list[i].chosen == null) list[i].chosen = false;
/////////unselected//////////////////
    if (list[i].chosen! &&
        globalProduct!.attributes![attributeIndex].required == 0) {
      for (var element in list) {
        element.chosen = false;
      }
      ////calc price /////
      attributePrices[attributeIndex] = 0.0;
      reCalculatePrices();
      /////removing/////
      attributes.removeWhere((element) =>
          element.id == globalProduct!.attributes![attributeIndex].id);
    }
    ////////////selected size///////////
    else if (!list[i].chosen!) {
      for (var element in list) {
        element.chosen = false;
      }
      list[i].chosen = true;
      if (globalProduct!.attributes![attributeIndex].overridePrice == 1 &&
          globalProduct!.attributes![attributeIndex].multiSelect == 0) {
        for (int j = 0; j < attributes.length; j++) {
          if (attributes[j].id ==
              globalProduct!.attributes![attributeIndex].id) {
            ////remove previous choice /////
            attributes[j].values = [];
            print(list[i].id);
            attributes[j].values!.add(Values(
                id: list[i].id,
                price: list[i].price,
                attributeValue: list[i].attributeValue));
            attributePrices[attributeIndex] = 0.0;
            initialPrice = list[i].price!;
            price = initialPrice;
            reCalculatePrices();
            break;
          }
        }
      } else {
        int counter = 0;
        for (int j = 0; j < attributes.length; j++) {
          if (attributes[j].id !=
              globalProduct!.attributes![attributeIndex].id) {
            counter++;
          }
        }
        ///// add attribute ////
        if (counter == attributes.length) {
          attributes.add(Attributes(
              id: globalProduct!.attributes![attributeIndex].id,
              title: globalProduct!.attributes![attributeIndex].title,
              multiSelect: 0,
              values: []));
          attributes.last.values!.add(Values(
              id: list[i].id,
              price: list[i].price,
              attributeValue: list[i].attributeValue));
//////calc price///////////
          attributePrices[attributeIndex] = list[i].price!;
          reCalculatePrices();
        } else {
          ///// change value of attribute////
          for (int j = 0; j < attributes.length; j++) {
            if (attributes[j].id ==
                globalProduct!.attributes![attributeIndex].id) {
              attributes[j].values!.clear();
              attributes[j].values!.add(Values(
                  id: list[i].id,
                  price: list[i].price,
                  attributeValue: list[i].attributeValue));
              //calc price
              attributePrices[attributeIndex] = list[i].price!;
              reCalculatePrices();

              break;
            }
          }
        }
      }
    }
    emit(AttributesLoaded(product: globalProduct!));
  }
  void switchSingleSelectAddon(int addonIndex, List<AddonValue> list, int i) {
    emit(SingleProductInitial());

    if (list[i].chosen == null) list[i].chosen = false;
/////////unselected//////////////////
    if (list[i].chosen!) {
      for (var element in list) {
        element.chosen = false;
      }
      ////calc price /////
      addonPrices[addonIndex] = 0.0;
      reCalculatePrices();
      /////removing/////
      addon.removeWhere((element) =>
      element.id == globalProduct!.addons![addonIndex].id);
    }
    ////////////selected size///////////
    else if (!list[i].chosen!) {
      for (var element in list) {
        element.chosen = false;
      }
      list[i].chosen = true;
       {
        int counter = 0;
        for (int j = 0; j < addon.length; j++) {
          if (addon[j].id !=
              globalProduct!.addons![addonIndex].id) {
            counter++;
          }
        }
        ///// add attribute ////
        if (counter == addon.length) {
          addon.add(Addon(
              id: globalProduct!.addons![addonIndex].id,
              title: globalProduct!.addons![addonIndex].title,
              multiSelect: 0,
              values: []));
          addon.last.values!.add(AddonValue(
              id: list[i].id,
              price: list[i].price,
              title: list[i].title));
//////calc price///////////
          addonPrices[addonIndex] = list[i].price!;
          reCalculatePrices();
        } else {
          ///// change value of attribute////
          for (int j = 0; j < addon.length; j++) {
            if (addon[j].id ==
                globalProduct!.addons![addonIndex].id) {
              addon[j].values!.clear();
              addon[j].values!.add(AddonValue(
                  id: list[i].id,
                  price: list[i].price,
                  title: list[i].title));
              //calc price
              addonPrices[addonIndex] = list[i].price!;
              reCalculatePrices();
              break;
            }
          }
        }
      }
    }
    emit(AttributesLoaded(product: globalProduct!));
  }

  void switchMultiSelect(int attributeIndex, List<Values> list, int i) {
    emit(SingleProductInitial());
    if (list[i].chosen == null) list[i].chosen = false;
//// un selected ////
    if (list[i].chosen!) {
      int valuesCount = 0;
      for (int j = 0;
          j < globalProduct!.attributes![attributeIndex].values!.length;
          j++) {
        if (globalProduct!.attributes![attributeIndex].values![j].chosen ==
            true) {
          valuesCount++;
        }
      }
      print(valuesCount);
      if (valuesCount > 1 ||
          globalProduct!.attributes![attributeIndex].required == 0) {
        list[i].chosen = false;
        for (int element = 0; element < attributes.length; element++) {
          if (attributes[element].id ==
              globalProduct!.attributes![attributeIndex].id) {
            //// remove value /////
            if (attributes[element].values!.length > 1) {
              for (int j = 0; j < attributes[element].values!.length; j++) {
                if (attributes[element].values![j].id == list[i].id) {
                  ////calc price ////
                  attributePrices[attributeIndex] =
                      attributePrices[attributeIndex] - list[i].price!;
                  reCalculatePrices();
                  ////removing /////
                  attributes[element].values!.removeAt(j);
                  break;
                }
              }
            }
            ////remove attribute ////
            else {
              attributePrices[attributeIndex] = 0.0;
              reCalculatePrices();
              attributes.removeWhere((e) => e.id == attributes[element].id);
              break;
            }
            break;
          }
        }
      }
    }
    ////selected/////
    else {
      list[i].chosen = true;
      bool inList = false;
      for (int i = 0; i < attributes.length; i++) {
        if (attributes[i].id == globalProduct!.attributes![attributeIndex].id) {
          inList = true;
        }
      }
      ////add attribute ////
      if (!inList) {
        attributes.add(Attributes(
            id: globalProduct!.attributes![attributeIndex].id,
            title: globalProduct!.attributes![attributeIndex].title,
            multiSelect: 1,
            values: []));
        attributes.last.values!.add(Values(
            id: list[i].id,
            price: list[i].price,
            attributeValue: list[i].attributeValue));
        attributePrices[attributeIndex] = list[i].price!;
        reCalculatePrices();
      } else {
        ////add value////
        for (int k = 0; k < attributes.length; k++) {
          if (attributes[k].id ==
              globalProduct!.attributes![attributeIndex].id) {
            attributes[k].values!.add(Values(
                id: list[i].id,
                price: list[i].price,
                attributeValue: list[i].attributeValue));
            attributePrices[attributeIndex] =
                attributePrices[attributeIndex] + list[i].price!;
            reCalculatePrices();
          }
        }
      }
    }
    print(json.encode(attributes));
    emit(AttributesLoaded(product: globalProduct!));
  }

  void switchMultiSelectAddon(int attributeIndex, List<AddonValue> list, int i) {
    emit(SingleProductInitial());
    if (list[i].chosen == null) list[i].chosen = false;
//// un selected ////
    if (list[i].chosen!) {
      print("ggjkkkkkk");
      int valuesCount = 0;
      for (int j = 0;
      j < globalProduct!.addons![attributeIndex].values!.length;
      j++) {
        if (globalProduct!.addons![attributeIndex].values![j].chosen ==
            true) {
          valuesCount++;
        }
      }
      print(valuesCount);
        list[i].chosen = false;
        for (int element = 0; element < addon.length; element++) {
          if (addon[element].id ==
              globalProduct!.addons![attributeIndex].id) {
            //// remove value /////
            if (addon[element].values!.length > 1) {
              print("gggg");
              for (int j = 0; j < addon[element].values!.length; j++) {
                if (addon[element].values![j].id == list[i].id) {
                  ////calc price ////
                  addonPrices[attributeIndex] =
                      addonPrices[attributeIndex] - list[i].price!;
                  reCalculatePrices();
                  ////removing /////
                  addon[element].values!.removeAt(j);
                  break;
                }
              }
            }
            ////remove attribute ////
            else {
              print("ggggllll");
              addonPrices[attributeIndex] = 0.0;
              reCalculatePrices();
              addon.removeWhere((e) => e.id ==  globalProduct!.addons![attributeIndex].id);

    break;
            }
            break;
          }
        }
print(addon.length);
    }
    ////selected/////
    else {
      list[i].chosen = true;
      bool inList = false;
      for (int i = 0; i < addon.length; i++) {
        if (addon[i].id == globalProduct!.addons![attributeIndex].id) {
          inList = true;
        }
      }
      ////add attribute ////
      if (!inList) {
        addon.add(Addon(
            id: globalProduct!.addons![attributeIndex].id,
            title: globalProduct!.addons![attributeIndex].title,
            multiSelect: 1,
            values: []));
        addon.last.values!.add(AddonValue(
            id: list[i].id,
            price: list[i].price,
            title: list[i].title));
        addonPrices[attributeIndex] = list[i].price!;
        reCalculatePrices();
      } else {
        ////add value////
        for (int k = 0; k < addon.length; k++) {
          if (addon[k].id ==
              globalProduct!.addons![attributeIndex].id) {
            addon[k].values!.add(AddonValue(
                id: list[i].id,
                price: list[i].price,
                title: list[i].title));
            addonPrices[attributeIndex] =
                addonPrices[attributeIndex] + list[i].price!;
            reCalculatePrices();
          }
        }
      }
    }
    print(json.encode(addon));
    emit(AttributesLoaded(product: globalProduct!));
  }

  void getCartCount() {
    List<String> cart = LocalStorage.getList(key: 'cart') ?? [];
    cartCount = cart.length;
    for (var element in cart) {
      inCart = globalProduct != null
          ? element.contains(globalProduct!.title!.en!)
          : false;
    }
  }

  void favToggle(int id) {
    //   emit(FavToggle(product: globalProduct!));
    emit(AttributesLoading());
    var data = singleProductRepo.favToggle(id);
    print(data);
    if (globalProduct!.inFavourite == 0 && data != null) {
      globalProduct!.inFavourite = 1;
      print("llllll");
    } else if (globalProduct!.inFavourite == 1 && data != null) {
      globalProduct!.inFavourite = 0;
    } else {
      print("llllkkkkkkll");
    }
    print(globalProduct!.inFavourite);
    emit(AttributesLoaded(product: globalProduct!));
  }

  void addToCard(context) {
    print(globalProduct!.tax);
    emit(SingleProductInitial());
bool validWithCoupon = true;
    if(LocalStorage.getData(key: "coupon") != null){
      if(globalProduct!.denyCoupon ==1){
        print(validWithCoupon);
        validWithCoupon = false;
      }
    }
    print(validWithCoupon.toString()+"jjjjjjjjj");
if(validWithCoupon == true){
  showTopSnackBar(
      Overlay.of(context),
      Card(
        child: CustomSnackBar.success(
          message: LocaleKeys.added_to_cart.tr(),
          backgroundColor: Colors.white,
          textStyle: TextStyle(
              color: Colors.black,
              fontSize: MediaQuery.of(context).size.height * 0.027),
        ),
      ));
    List<String> data = LocalStorage.getList(key: 'cart') ?? [];

    ProductModel newProduct = ProductModel(
        id: globalProduct!.id,
        price: globalProduct!.price,
        title: globalProduct!.title,
        images: globalProduct!.images,
        attributes: attributes,
        tax: globalProduct!.tax,
        total: price,
        denyCoupon: globalProduct!.denyCoupon,
        notes: globalProduct!.notes,
        count: globalProduct!.count,
        inFavourite: globalProduct!.inFavourite,
        addons: addon,
        newPrice: globalProduct!.newPrice);
  print(addon.length.toString()+"mmmmmmm");

    List<ProductModel> products = [];
    int count = 0;
    int count2 = 0;
    int addonCount1 =0;
  int addonCount2 =0;

  int ?productIndex;
    bool isOld = false;

  if (LocalStorage.getList(key: 'cart') != null) {
    products = List<ProductModel>.from(json
        .decode(LocalStorage.getList(key: 'cart').toString())
        .map((e) => ProductModel.fromJson(e)));
    //
    //
  }
  print(products.length.toString()+"kkk");
  for (int i = 0; i < products.length; i++) {
    if (newProduct.id == products[i].id) {
      count=0;
      count2=0;
      addonCount1=0;
      addonCount2=0;
      bool isEqual =true;
      bool isEqualAttribute=true;


      print(i.toString() +"lll");

      for (int k = 0; k < newProduct.attributes!.length; k++) {
        count = count + newProduct.attributes![k].values!.length;
        print("lllllllll");

      }
      for (int n = 0; n < newProduct.addons!.length; n++) {
        print("lllllllll");
        addonCount1 = addonCount1 + newProduct.addons![n].values!.length;
        print(addonCount1.toString() + "vvvvvvvvvv");
      }
      print(addonCount1.toString() + "vvvvvvvvvv");

      if(products[i].attributes!.length ==  newProduct.attributes!.length){
        for (int k = 0; k < newProduct.attributes!.length; k++) {
          for (int j = 0; j < products[i].attributes!.length; j++) {
            if (products[i].attributes![j].id ==
                newProduct.attributes![k].id) {

              if (products[i].attributes![j].values!.length == newProduct.attributes![k].values!.length) {
                print("nnnn");
                for (int m = 0;
                m < products[i].attributes![j].values!.length;
                m++) {
                  for (int o = 0;
                  o < newProduct.attributes![k].values!.length;
                  o++) {
                    print(products[i].attributes!.length);


                    if (products[i].attributes![j].values![m].id ==
                        newProduct.attributes![k].values![o].id) {
                      print("pppppp");
                      print(products[i].attributes![j].id);
                      print(newProduct.attributes![k].id);
                      isEqualAttribute = true;

                      count2++;
                    }
                  }
                }}
            }
          }
        }

      }
      else{
        isEqualAttribute = false;

      }
      if(products[i].addons!.length ==  newProduct.addons!.length){
        print("ll");
        for (int k = 0; k < newProduct.addons!.length; k++) {
          for (int j = 0; j < products[i].addons!.length; j++) {
            if (products[i].addons![j].id ==
                newProduct.addons![k].id) {

              if (products[i].addons![j].values!.length == newProduct.addons![k].values!.length) {
                print("nnnn");
                for (int m = 0;
                m < products[i].addons![j].values!.length;
                m++) {
                  for (int o = 0;
                  o < newProduct.addons![k].values!.length;
                  o++) {
                    print(products[i].addons!.length);


                    if (products[i].addons![j].values![m].id ==
                        newProduct.addons![k].values![o].id) {
                      print("pppppp");
                      print(products[i].addons![j].id);
                      print(newProduct.addons![k].id);
                      isEqual = true;
                      addonCount2++;
                    }
                  }
                }}
            }
          }
        }

      }else{
        isEqual = false;

      }
      print(addonCount1);
      print(addonCount2.toString()+"cccccccccc");
      if (count2 ==count && addonCount1 == addonCount2 && isEqual == true&& isEqualAttribute == true) {
        print("3333");
        isOld = true;
        products[i].count = products[i].count! + newProduct.count!;
        products[i].total =price + products[i].total!;
        data = [];
        for (int j = 0; j < products.length; j++) {
          print(products[i].count);
          data.add(jsonEncode(products[j].toJson()));
        }
        break;
      }
    }
    print("kkkkkkk");
  }

  if (isOld == false) {
    data.add(jsonEncode(newProduct.toJson()));
  }

  LocalStorage.saveList(key: 'cart', value: data);
  getCartCount();
  print(json.encode(newProduct));
  emit(AttributesLoaded(product: globalProduct!));
  }}

  void countIncrementAdnDecrement(String function) {
    emit(SingleProductInitial());
    if (function == '+') {
      itemCount = itemCount + 1;
    } else if (function == '-' && itemCount > 1) itemCount = itemCount - 1;
    globalProduct!.count = itemCount;
    reCalculatePrices();
    emit(AttributesLoaded(product: globalProduct!));
  }

  void setNote(String notes) {
    globalProduct!.notes = notes;
  }
}
