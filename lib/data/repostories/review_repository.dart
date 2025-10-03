import 'package:store_app/core/client.dart';
import 'package:store_app/core/result.dart';
import 'package:store_app/data/model/review/review_model.dart';

class ReviewRepository {
  final ApiClient apiClient;

  ReviewRepository({required this.apiClient});

  Future<Result<ReviewModel>> createReview({
    required int orderId,
    required int rating,
    required String comment,
  }) async {
    final result = await apiClient.post<Map<String, dynamic>>(
      '/reviews/create',
      data: {
        'order_id': orderId,
        'rating': rating,
        'comment': comment,
      },
    );

    return result.fold(
      (error) => Result.error(error),
      (data) {
        try {
          final review = ReviewModel.fromJson(data);
          return Result.ok(review);
        } catch (e) {
          return Result.error(Exception('Failed to parse review: $e'));
        }
      },
    );
  }
}