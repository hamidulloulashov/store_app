import 'package:equatable/equatable.dart';

abstract class ReviewEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchReviews extends ReviewEvent {
  final int productId;

  FetchReviews(this.productId);

  @override
  List<Object> get props => [productId];
}
