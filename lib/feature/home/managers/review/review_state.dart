import 'package:equatable/equatable.dart';
import '../../../../data/model/home/review_model.dart';

abstract class ReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class ReviewInitial extends ReviewState {}

class ReviewLoading extends ReviewState {}

class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;

  ReviewLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

class ReviewAdded extends ReviewState {
  /// AddReview muvaffaqiyatli tugaganda backend qaytaradigan yangilangan ro‘yxat
  final List<ReviewModel> updatedReviews;

  ReviewAdded(this.updatedReviews);

  @override
  List<Object?> get props => [updatedReviews];
}

class ReviewError extends ReviewState {
  final String message;

  ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
