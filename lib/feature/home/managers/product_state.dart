import 'package:equatable/equatable.dart';
import '../../../data/model/home_model.dart/product_detail_model.dart';

enum ProductStatus { initial, loading, success, failure }

class ProductState extends Equatable {
  final ProductStatus status;
  final String? errorMessage;
  final List<ProductModel> products;
  final List<CategoryModel> categories;
  final int selectedCategoryId;

  const ProductState({
    this.status = ProductStatus.initial,
    this.errorMessage,
    this.products = const [],
    this.categories = const [],
    this.selectedCategoryId = 0,
  });

  ProductState copyWith({
    ProductStatus? status,
    String? errorMessage,
    List<ProductModel>? products,
    List<CategoryModel>? categories,
    int? selectedCategoryId,
  }) {
    return ProductState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategoryId: selectedCategoryId ?? this.selectedCategoryId,
    );
  }

  @override
  List<Object?> get props => [
        status,
        errorMessage,
        products,
        categories,
        selectedCategoryId,
      ];
}
