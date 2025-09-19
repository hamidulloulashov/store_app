import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repostories/home_repostrory.dart';
import 'product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  final ProductRepository repository;

  ProductDetailCubit(this.repository) : super(ProductDetailInitial());

  Future<void> getProductDetail(int id) async {
    try {
      emit(ProductDetailLoading());
 final product = await repository.getProductDetail(id);
      emit(ProductDetailLoaded(product));
    } catch (e) {
      emit(ProductDetailError(e.toString()));
    }
  }
}
