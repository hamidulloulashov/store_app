import '../../../data/model/home_model.dart/product_detail_model.dart';

abstract class ProductDetailState {}

class ProductDetailInitial extends ProductDetailState {}

class ProductDetailLoading extends ProductDetailState {}

class ProductDetailLoaded extends ProductDetailState {
  final ProductDetailModel product;

  ProductDetailLoaded(this.product);
}

class ProductDetailError extends ProductDetailState {
  final String message;

  ProductDetailError(this.message);
}
