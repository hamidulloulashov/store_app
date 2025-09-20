import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repostories/rews_repository.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc(this.repository) : super(ReviewInitial()) {
    on<FetchReviews>(_onFetchReviews);
  }

  Future<void> _onFetchReviews(FetchReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    try {
      final result = await repository.fetchReviews(productId: event.productId);

      result.fold(
        (error) => emit(ReviewError(error.toString())),
        (reviews) => emit(ReviewLoaded(reviews)),
      );
    } catch (e) {
      emit(ReviewError(e.toString()));
    }
  }
}
