import 'package:equatable/equatable.dart';
import '../../../../data/model/home/product_model.dart';
import '../../../../data/model/sort/sort_model.dart';
enum ProductStatus { initial, loading, success, failure }
enum SortStatus { initial, loading, success, failure }
class ProductState extends Equatable {
  final ProductStatus status;
  final SortStatus sortStatus;
  final String? errorMessage;
  final List<ProductModel> products;
  final List<SortModel> sortedProducts;
  final List<CategoryModel> categories;
  final int selectedCategoryId;
  const ProductState({
    this.status = ProductStatus.initial,
    this.sortStatus = SortStatus.initial,
    this.errorMessage,
    this.products = const [],
    this.sortedProducts = const [],
    this.categories = const [],
    this.selectedCategoryId = 0,
  });
  ProductState copyWith({
    ProductStatus? status,
    SortStatus? sortStatus,
    String? errorMessage,
    List<ProductModel>? products,
    List<SortModel>? sortedProducts,
    List<CategoryModel>? categories,
    int? selectedCategoryId,
  }) {
    return ProductState(
      status: status ?? this.status,
      sortStatus: sortStatus ?? this.sortStatus,
      errorMessage: errorMessage,
      products: products ?? this.products,
      sortedProducts: sortedProducts ?? this.sortedProducts,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [status, sortStatus, errorMessage, products, sortedProducts, categories, selectedCategoryId];
}
