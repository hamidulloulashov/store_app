import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repostories/home_repostrory.dart';
import '../../../../data/model/home/product_model.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRepository _repository;

  ProductBloc(this._repository) : super(const ProductState()) {
    on<LoadCategoriesEvent>(_onLoadCategories);
    on<LoadProductsEvent>(_onLoadProducts);
    on<ChangeCategoryEvent>(_onChangeCategory);
    on<SearchProductsEvent>(_onSearchProducts);
    on<ClearSearchEvent>(_onClearSearch);
    on<ToggleLikeProductEvent>(_onToggleLikeProduct);
    on<LoadSortedProductsEvent>(_onLoadSortedProducts);
    on<ClearSortedProductsEvent>(_onClearSortedProducts);
  }

  Future<void> _onLoadCategories(LoadCategoriesEvent event, Emitter<ProductState> emit) async {
    try {
      final categories = await _repository.getCategories();
      emit(state.copyWith(categories: [CategoryModel(id: 0, title: "All"), ...categories], status: ProductStatus.success));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.failure, errorMessage: "Kategoriya olishda xatolik: $e"));
    }
  }

  Future<void> _onLoadProducts(LoadProductsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(status: ProductStatus.loading, errorMessage: null));
    try {
      final products = await _repository.getProducts(categoryId: event.categoryId == 0 ? null : event.categoryId);
      emit(state.copyWith(status: ProductStatus.success, products: products));
    } catch (e) {
      emit(state.copyWith(status: ProductStatus.failure, errorMessage: "Product olishda xatolik: $e"));
    }
  }

  void _onChangeCategory(ChangeCategoryEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(selectedCategoryId: event.categoryId));
    final filtered = event.categoryId == 0
        ? event.allProducts
        : event.allProducts.where((p) => p.categoryId == event.categoryId).toList();
    emit(state.copyWith(products: filtered, status: ProductStatus.success));
  }

  void _onSearchProducts(SearchProductsEvent event, Emitter<ProductState> emit) {
    if (event.query.isEmpty) {
      add(ChangeCategoryEvent(state.selectedCategoryId, event.allProducts));
    } else {
      var searchBase = event.allProducts;
      if (state.selectedCategoryId != 0) {
        searchBase = event.allProducts.where((p) => p.categoryId == state.selectedCategoryId).toList();
      }
      final filtered = searchBase.where((p) => p.title.toLowerCase().contains(event.query.toLowerCase())).toList();
      emit(state.copyWith(products: filtered, status: ProductStatus.success));
    }
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(products: [], selectedCategoryId: 0, status: ProductStatus.initial));
  }

  Future<void> _onToggleLikeProduct(ToggleLikeProductEvent event, Emitter<ProductState> emit) async {
    final index = state.products.indexWhere((p) => p.id == event.productId);
    if (index == -1) return;
    final updatedProducts = List<ProductModel>.from(state.products);
    final isLiked = updatedProducts[index].isLiked;
    updatedProducts[index] = updatedProducts[index].copyWith(isLiked: !isLiked);
    emit(state.copyWith(products: updatedProducts));
    try {
      await _repository.toggleLikeProduct(event.productId.toString(), isLiked: isLiked);
    } catch (e) {
      updatedProducts[index] = updatedProducts[index].copyWith(isLiked: isLiked);
      emit(state.copyWith(products: updatedProducts, errorMessage: "Like qilishda xatolik: $e"));
    }
  }

  Future<void> _onLoadSortedProducts(LoadSortedProductsEvent event, Emitter<ProductState> emit) async {
    emit(state.copyWith(sortStatus: SortStatus.loading));
    try {
      final products = await _repository.getSortedProducts(
        categoryId: event.categoryId,
        sizeId: event.sizeId,
        title: event.title,
        minPrice: event.minPrice,
        maxPrice: event.maxPrice,
        orderBy: event.orderBy,
      );
      emit(state.copyWith(sortStatus: SortStatus.success, sortedProducts: products));
    } catch (e) {
      emit(state.copyWith(sortStatus: SortStatus.failure, errorMessage: e.toString()));
    }
  }

  void _onClearSortedProducts(ClearSortedProductsEvent event, Emitter<ProductState> emit) {
    emit(state.copyWith(sortStatus: SortStatus.initial, sortedProducts: []));
  }
}
