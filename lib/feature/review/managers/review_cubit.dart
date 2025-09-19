import 'package:bloc/bloc.dart';
import '../../../data/repostories/rews_repository.dart';
import 'review_state.dart';

class ReviewCubit extends Cubit<ReviewState> {
  final ReviewRepository repository;

  ReviewCubit(this.repository) : super(ReviewInitial());

  void getReviews(int productId) async {
    emit(ReviewLoading());
    try {
      final result = await repository.fetchReviews(productId: productId);

      result.fold(
        (error) => emit(ReviewError(error.toString())),
        (reviews) => emit(ReviewLoaded(reviews)),
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
