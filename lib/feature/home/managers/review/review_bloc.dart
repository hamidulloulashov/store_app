import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../data/repostories/rews_repository.dart';
import 'review_event.dart';
import 'review_state.dart';

class ReviewBloc extends Bloc<ReviewEvent, ReviewState> {
  final ReviewRepository repository;

  ReviewBloc(this.repository) : super(ReviewInitial()) {
    on<FetchReviews>(_onFetchReviews);
    on<AddReview>(_onAddReview);
  }

  Future<void> _onFetchReviews(
      FetchReviews event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await repository.fetchReviews(productId: event.productId);
    result.fold(
      (error) => emit(ReviewError(error.toString())),
      (reviews) => emit(ReviewLoaded(reviews)),
    );
  }

  Future<void> _onAddReview(
      AddReview event, Emitter<ReviewState> emit) async {
    emit(ReviewLoading());
    final result = await repository.addReview(
      productId: event.productId,
      comment: event.comment,
      rating: event.rating,
    );

    result.fold(
      (error) => emit(ReviewError(error.toString())),
      (updatedReviews) {
        emit(ReviewAdded(updatedReviews));
      },
    );
  }
}
