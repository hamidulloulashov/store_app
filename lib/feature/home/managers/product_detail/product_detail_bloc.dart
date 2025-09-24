import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repostories/home_repostrory.dart';
import 'product_detail_event.dart';
import 'product_detail_state.dart';

class ProductDetailBloc extends Bloc<ProductDetailEvent, ProductDetailState> {
  final ProductRepository repository;

  ProductDetailBloc(this.repository) : super(ProductDetailInitial()) {
    on<LoadProductDetail>((event, emit) async {
      try {
        emit(ProductDetailLoading());
        final product = await repository.getProductDetail(event.productId);
        emit(ProductDetailLoaded(product));
      } catch (e) {
        emit(ProductDetailError(e.toString()));
      }
    });
  }
}
