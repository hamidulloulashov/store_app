import 'package:store_app/core/client.dart';
import 'package:store_app/core/result.dart';
import '../model/home/review_model.dart';

class ReviewRepository {
  final ApiClient _apiClient;

  ReviewRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  Future<Result<List<ReviewModel>>> fetchReviews({required int productId}) async {
    final result = await _apiClient.get('/reviews/list/$productId');
    return result.fold(
      (error) => Result.error(Exception(error.toString())),
      (data) {
        final list = data as List;
        final reviews = list
            .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Result.ok(reviews);
      },
    );
  }

  /// 🔹 Yangi izoh qo‘shish
  Future<Result<List<ReviewModel>>> addReview({
    required int productId,
    required String comment,
    required double rating,
  }) async {
    final result = await _apiClient.post(
      '/reviews/add',
      data: {
        'productId': productId,
        'comment': comment,
        'rating': rating,
      },
    );

    return result.fold(
      (error) => Result.error(Exception(error.toString())),
      (data) {
        // Backend qaytaradigan yangilangan ro‘yxat
        final list = data as List;
        final reviews = list
            .map((e) => ReviewModel.fromJson(e as Map<String, dynamic>))
            .toList();
        return Result.ok(reviews);
      },
    );
  }
}
