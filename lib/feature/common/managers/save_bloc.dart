import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;
import 'package:store_app/data/repostories/favourite_repository.dart' show ProductRepositories;
import 'package:store_app/feature/common/managers/save_state.dart' show SavedState;

import '../../../data/model/home_model.dart/product_model.dart';
import 'save_event.dart';

class SavedBloc extends Bloc<SavedEvent, SavedState> {
  final ProductRepositories _savedProductRepo;
  static const String _savedProductsKey = 'saved_products';

  SavedBloc({
    required ProductRepositories savedProductRepo,
  })  : _savedProductRepo = savedProductRepo,
        super(SavedState.initial()) {
    on<LoadSavedProducts>(_onLoadSavedProducts);
    on<ToggleSaveProduct>(_onToggleSaveProduct);
    on<ClearAllSavedProducts>(_onClearAllSavedProducts);
    on<FetchSavedProducts>(_onFetchSavedProducts);

    add(const LoadSavedProducts());
  }

  Future<void> fetchSavedProduct() async {
    add(const FetchSavedProducts());
  }

  Future<void> toggleSave(ProductModel product) async {
    add(ToggleSaveProduct(product: product));
  }

  Future<void> clearAllSaved() async {
    add(const ClearAllSavedProducts());
  }

  Future<void> _onLoadSavedProducts(
    LoadSavedProducts event,
    Emitter<SavedState> emit,
  ) async {
    emit(state.copyWith(loading: true));
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedProductsJson = prefs.getStringList(_savedProductsKey) ?? [];
      
      final localSavedProducts = <ProductModel>[];
      for (final jsonString in savedProductsJson) {
        try {
          final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
          localSavedProducts.add(ProductModel.fromJson(jsonMap));
        } catch (e) {
          print('JSON decode xatolik: $e');
        }
      }

      List<ProductModel> allSavedProducts = localSavedProducts;
      
      try {
        final apiSavedProducts = await _savedProductRepo.getSavedProduct();
        final combinedProducts = <ProductModel>[];
        final addedIds = <String>{};
        
        for (final product in localSavedProducts) {
          if (product.id != null) {
            final idString = product.id.toString();
            if (!addedIds.contains(idString)) {
              combinedProducts.add(product);
              addedIds.add(idString);
            }
          }
        }
        
        for (final product in apiSavedProducts) {
          if (product.id != null) {
            final idString = product.id.toString();
            if (!addedIds.contains(idString)) {
              combinedProducts.add(product);
              addedIds.add(idString);
            }
          }
        }
        
        allSavedProducts = combinedProducts;
      } catch (e) {
        print('API dan ma\'lumot olishda xatolik: $e');
      }

      emit(state.copyWith(savedProduct: allSavedProducts, loading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), loading: false));
    }
  }

  Future<void> _onFetchSavedProducts(
    FetchSavedProducts event,
    Emitter<SavedState> emit,
  ) async {
    add(const LoadSavedProducts());
  }

  Future<void> _onToggleSaveProduct(
    ToggleSaveProduct event,
    Emitter<SavedState> emit,
  ) async {
    final currentList = List<ProductModel>.from(state.savedProduct);

    if (currentList.any((p) => p.id == event.product.id)) {
      currentList.removeWhere((p) => p.id == event.product.id);
    } else {
      currentList.add(event.product);
    }

    emit(state.copyWith(savedProduct: currentList));
    
    // Save to SharedPreferences
    await _saveSavedProducts(currentList);
  }

  Future<void> _onClearAllSavedProducts(
    ClearAllSavedProducts event,
    Emitter<SavedState> emit,
  ) async {
    emit(state.copyWith(savedProduct: []));
    await _saveSavedProducts([]);
  }

  Future<void> _saveSavedProducts(List<ProductModel> products) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final productsJson = products
          .map((product) => jsonEncode(product.toJson()))
          .toList();
      await prefs.setStringList(_savedProductsKey, productsJson);
    } catch (e) {
      print('Mahalliy saqlashda xatolik: $e');
    }
  }
}