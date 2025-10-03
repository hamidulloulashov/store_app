import 'package:store_app/core/client.dart';
import 'package:store_app/core/result.dart';
import 'package:store_app/data/model/checout/checout_model.dart' hide PaymentCardModel;
import 'package:store_app/data/model/payment_card/payment_card_model.dart';
import 'package:store_app/data/model/payment_card/payment_card_request.dart';

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  Future<Result<List<PaymentCardModel>>> getCards() async {
    final result = await _apiClient.get<dynamic>('/cards/list');

    return result.fold(
      (error) => Result.error(error),
      (data) {
        try {
          if (data is List) {
            final cards = data
                .map((e) => PaymentCardModel.fromJson(e as Map<String, dynamic>))
                .toList();
            return Result.ok(cards);
          }

          if (data is Map && data['data'] is List) {
            final list = data['data'] as List;
            final cards = list
                .map((e) => PaymentCardModel.fromJson(e as Map<String, dynamic>))
                .toList();
            return Result.ok(cards);
          }

          return Result.error(Exception('Kutilmagan javob formati: $data'));
        } catch (e) {
          return Result.error(Exception('Karta maʼlumotini o‘qishda xatolik: $e'));
        }
      },
    );
  }

  Future<Result<void>> createCard(CreateCardRequest request) async {
    final result = await _apiClient.post<dynamic>(
      '/cards/create',
      data: request.toJson(),
    );

    return result.fold(
      (error) => Result.error(error),
      (_) => Result.ok(null),
    );
  }

  Future<Result<void>> deleteCard(int cardId) async {
    final result = await _apiClient.delete<dynamic>(
      '/cards/delete/$cardId',
    );

    return result.fold(
      (error) => Result.error(error),
      (_) => Result.ok(null),
    );
  }
  Future<Result<OrderModel>> placeOrder({
  required int addressId,
  required String paymentMethod,
}) async {
  final result = await _apiClient.post<dynamic>(
    '/orders/create',
    data: {
      'addressId': addressId,
      'paymentMethod': paymentMethod,
    },
  );

  return result.fold(
    (error) => Result.error(error),
    (data) => Result.ok(OrderModel.fromJson(data as Map<String, dynamic>)),
  );
}

}
