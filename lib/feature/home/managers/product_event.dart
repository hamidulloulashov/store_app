import 'package:equatable/equatable.dart';
import '../../../data/model/home_model.dart/product_model.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List<Object?> get props => [];
}

class LoadCategoriesEvent extends ProductEvent {}

class LoadProductsEvent extends ProductEvent {
  final int? categoryId;

  const LoadProductsEvent({this.categoryId});

  @override
  List<Object?> get props => [categoryId];
}

class ChangeCategoryEvent extends ProductEvent {
  final int categoryId;
  final List<ProductModel> allProducts;

  const ChangeCategoryEvent(this.categoryId, this.allProducts);

  @override
  List<Object?> get props => [categoryId, allProducts];
}

class SearchProductsEvent extends ProductEvent {
  final String query;
  final List<ProductModel> allProducts;

  const SearchProductsEvent(this.query, this.allProducts);

  @override
  List<Object?> get props => [query, allProducts];
}

class ClearSearchEvent extends ProductEvent {}

class ToggleLikeProductEvent extends ProductEvent {
  final int productId;

  const ToggleLikeProductEvent(this.productId);

  @override
  List<Object?> get props => [productId];
}
