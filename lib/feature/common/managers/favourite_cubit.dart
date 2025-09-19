import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:store_app/data/model/home_model.dart/product_model.dart' show ProductModel;
import 'package:store_app/feature/common/managers/favourite_state.dart';
import '../../../data/repostories/favourite_repository.dart';

class SavedCubit extends Cubit<SavedState> {
  SavedCubit({
    required ProductRepositories savedProductRepo,
  })  : _savedProductRepo = savedProductRepo,
        super(SavedState.initial()) {
    _loadSavedProducts();
  }

  final ProductRepositories _savedProductRepo;
  static const String _savedProductsKey = 'saved_products';

  // Mahalliy saqlangan mahsulotlarni yuklash
  Future<void> _loadSavedProducts() async {
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
          // Buzilgan ma'lumotni o'tkazib yuboramiz
        }
      }

      // API dan ham ma'lumotlarni olib kelish (ixtiyoriy)
      List<ProductModel> allSavedProducts = localSavedProducts;
      
      try {
        final apiSavedProducts = await _savedProductRepo.getSavedProduct();
        // API va mahalliy ma'lumotlarni birlashtirish
        final combinedProducts = <ProductModel>[];
        final addedIds = <String>{};
        
        // Avval mahalliy ma'lumotlarni qo'shish
        for (final product in localSavedProducts) {
          if (product.id != null) {
            final idString = product.id.toString();
            if (!addedIds.contains(idString)) {
              combinedProducts.add(product);
              addedIds.add(idString);
            }
          }
        }
        
        // Keyin API ma'lumotlarini qo'shish (takrorlanmaganlarini)
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
        // API ishlamasa ham mahalliy ma'lumotlar bilan davom etish
      }

      emit(state.copyWith(savedProduct: allSavedProducts, loading: false));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString(), loading: false));
    }
  }

  // Mahalliy xotiraga saqlash
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

  // API dan saqlangan mahsulotlarni olish (eski usul)
  Future<void> fetchSavedProduct() async {
    await _loadSavedProducts();
  }

  // Saqlash/olib tashlash
  Future<void> toggleSave(ProductModel product) async {
    final currentList = List<ProductModel>.from(state.savedProduct);

    if (currentList.any((p) => p.id == product.id)) {
      currentList.removeWhere((p) => p.id == product.id);
    } else {
      currentList.add(product);
    }

    emit(state.copyWith(savedProduct: currentList));
    
    // Mahalliy xotiraga saqlash
    await _saveSavedProducts(currentList);
  }

  // Barcha saqlangan mahsulotlarni o'chirish
  Future<void> clearAllSaved() async {
    emit(state.copyWith(savedProduct: []));
    await _saveSavedProducts([]);
  }
}