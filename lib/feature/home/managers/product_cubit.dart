import 'package:flutter_bloc/flutter_bloc.dart';
import 'product_state.dart';
import '../../../data/repostories/home_repostrory.dart';
import '../../../data/model/home_model.dart/product_detail_model.dart';

class ProductCubit extends Cubit<ProductState> {
  final ProductRepository _repository;

  ProductCubit(this._repository) : super(const ProductState());

  Future<void> loadCategories() async {
    try {
      final categories = await _repository.getCategories();
      final updated = [
        CategoryModel(id: 0, title: "All"),
        ...categories,
      ];
      emit(state.copyWith(
        categories: updated,
        status: ProductStatus.success,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage: "Kategoriya olishda xatolik: $e",
      ));
    }
  }

  Future<void> loadProducts({int? categoryId}) async {
    emit(state.copyWith(status: ProductStatus.loading, errorMessage: null));
    try {
      final products = await _repository.getProducts(
        categoryId: categoryId == 0 ? null : categoryId,
      );
      emit(state.copyWith(
        status: ProductStatus.success,
        products: products,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: ProductStatus.failure,
        errorMessage: "Product olishda xatolik: $e",
      ));
    }
  }

  void changeCategory(int categoryId) {
    emit(state.copyWith(selectedCategoryId: categoryId));
    loadProducts(categoryId: categoryId);
  }

  Future<void> toggleLikeProduct(int productId) async {
    final index = state.products.indexWhere((p) => p.id == productId);
    if (index == -1) return;

    final updatedProducts = List<ProductModel>.from(state.products);
    final isCurrentlyLiked = updatedProducts[index].isLiked;

    updatedProducts[index] =
        updatedProducts[index].copyWith(isLiked: !isCurrentlyLiked);

    emit(state.copyWith(products: updatedProducts));

    try {
      await _repository.toggleLikeProduct(
        productId.toString(),
        isLiked: isCurrentlyLiked,
      );
    } catch (e) {
      updatedProducts[index] =
          updatedProducts[index].copyWith(isLiked: isCurrentlyLiked);
      emit(state.copyWith(
        products: updatedProducts,
        errorMessage: "Like qilishda xatolik: $e",
      ));
    }
  }
    void searchProducts(String query) {
    if (query.isEmpty) {
      // agar qidiruv bo‘sh bo‘lsa, kategoriya bo‘yicha productlarni qayta yuklaymiz
      loadProducts(categoryId: state.selectedCategoryId);
    } else {
      final filtered = state.products
          .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
          .toList();

      emit(state.copyWith(products: filtered));
    }
  }

}
