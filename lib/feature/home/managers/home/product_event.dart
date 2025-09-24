import 'package:equatable/equatable.dart';
import '../../../../data/model/home/product_model.dart';

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

class LoadSortedProductsEvent extends ProductEvent {
  final int? categoryId;
  final int? sizeId;
  final String? title;
  final double? minPrice;
  final double? maxPrice;
  final String? orderBy;
  const LoadSortedProductsEvent({this.categoryId, this.sizeId, this.title, this.minPrice, this.maxPrice, this.orderBy});
  @override
  List<Object?> get props => [categoryId, sizeId, title, minPrice, maxPrice, orderBy];
}
class ClearSortedProductsEvent extends ProductEvent {}
