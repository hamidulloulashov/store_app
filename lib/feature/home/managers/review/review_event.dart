import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchReviews extends ReviewEvent {
  final int productId;

  FetchReviews(this.productId);

  @override
  List<Object?> get props => [productId];
}

class AddReview extends ReviewEvent {
  final int productId;
  final String comment;
  final double rating;

  AddReview({
    required this.productId,
    required this.comment,
    required this.rating,
  });

  @override
  List<Object?> get props => [productId, comment, rating];
}
