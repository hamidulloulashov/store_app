import 'package:equatable/equatable.dart';
import '../../../data/model/home_model.dart/product_detail_model.dart';

sealed class ProductDetailState extends Equatable {
  const ProductDetailState();

  @override
  List<Object?> get props => [];
}

final class ProductDetailInitial extends ProductDetailState {}

final class ProductDetailLoading extends ProductDetailState {}

final class ProductDetailLoaded extends ProductDetailState {
  final ProductDetailModel product;
  const ProductDetailLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

final class ProductDetailError extends ProductDetailState {
  final String message;
  const ProductDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
