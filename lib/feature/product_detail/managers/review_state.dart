import 'package:equatable/equatable.dart';
import '../../../data/model/home_model.dart/review_model.dart';

sealed class ReviewState extends Equatable {
  const ReviewState();

  @override
  List<Object?> get props => [];
}

final class ReviewInitial extends ReviewState {}

final class ReviewLoading extends ReviewState {}

final class ReviewLoaded extends ReviewState {
  final List<ReviewModel> reviews;
  const ReviewLoaded(this.reviews);

  @override
  List<Object?> get props => [reviews];
}

final class ReviewError extends ReviewState {
  final String message;
  const ReviewError(this.message);

  @override
  List<Object?> get props => [message];
}
