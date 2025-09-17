import 'package:flutter/material.dart';
import '../../../data/model/home_model.dart/product_detail_model.dart';
import '../../../data/repostories/home_repostrory.dart';

class ProductViewModel extends ChangeNotifier {
  final ProductRepository _repository;

  ProductViewModel(this._repository);

  bool _isLoading = false;
  String? _errorMessage;
  List<ProductModel> _products = [];
  List<CategoryModel> _categories = [];
  int _selectedCategoryId = 0; // 0 = All

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<ProductModel> get products => _products;
  List<CategoryModel> get categories => _categories;
  int get selectedCategoryId => _selectedCategoryId;

  /// 🔹 Kategoriyalarni yuklash
  Future<void> loadCategories() async {
    try {
      _categories = await _repository.getCategories();
      _categories.insert(0, CategoryModel(id: 0, title: "All")); // "All" qo‘shimcha
      notifyListeners();
    } catch (e) {
      _errorMessage = "Kategoriya olishda xatolik: $e";
      notifyListeners();
    }
  }

  /// 🔹 Productlarni yuklash
  Future<void> loadProducts({int? categoryId}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _products = await _repository.getProducts(
        categoryId: categoryId == 0 ? null : categoryId,
      );
    } catch (e) {
      _errorMessage = "Product olishda xatolik: $e";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// 🔹 Kategoriya o‘zgartirish
  void changeCategory(int categoryId) {
    _selectedCategoryId = categoryId;
    loadProducts(categoryId: categoryId);
    notifyListeners();
  }

  /// 🔹 Like / Unlike qilish
  Future<void> toggleLikeProduct(int productId) async {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    final isCurrentlyLiked = _products[index].isLiked;

    // UI da darhol o‘zgarish ko‘rsatish
    _products[index] = _products[index].copyWith(isLiked: !isCurrentlyLiked);
    notifyListeners();

    try {
      // Repositorydagi toggleLikeProduct ni chaqirish
      await _repository.toggleLikeProduct(
        productId.toString(),
        isLiked: isCurrentlyLiked, // agar hozir liked bo‘lsa, unsave qilinadi
      );
    } catch (e) {
      // Xatolik bo‘lsa, UI ni asl holatga qaytarish
      _products[index] =
          _products[index].copyWith(isLiked: isCurrentlyLiked);
      _errorMessage = "Like qilishda xatolik: $e";
      notifyListeners();
    }
  }
}
