import 'package:store_app/core/client.dart';
import 'package:store_app/core/result.dart';
import 'package:store_app/data/model/payment_card/payment_card_model.dart';
import 'package:store_app/data/model/payment_card/payment_card_request.dart';

class PaymentRepository {
  final ApiClient _apiClient;

  PaymentRepository(this._apiClient);

  /// 🟢 Karta ro‘yxatini olish
  Future<Result<List<PaymentCardModel>>> getCards() async {
    // Javob dinamik bo‘lsin, chunki backend ba'zida list yoki map qaytarishi mumkin
    final result = await _apiClient.get<dynamic>('/cards/list');

    return result.fold(
      (error) => Result.error(error),
      (data) {
        try {
          // Agar butun javob List bo‘lsa
          if (data is List) {
            final cards = data
                .map((e) => PaymentCardModel.fromJson(e as Map<String, dynamic>))
                .toList();
            return Result.ok(cards);
          }

          // Agar javob Map bo‘lsa (masalan: { "data": [...] })
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

  /// 🟢 Yangi karta qo‘shish
  Future<Result<void>> createCard(CreateCardRequest request) async {
    // Javob faqat success bo‘lsa, int yoki string qaytsa ham ishlaydi
    final result = await _apiClient.post<dynamic>(
      '/cards/create',
      data: request.toJson(),
    );

    return result.fold(
      (error) => Result.error(error),
      (_) => Result.ok(null),
    );
  }

  /// 🟢 Kartani o‘chirish
  Future<Result<void>> deleteCard(int cardId) async {
    final result = await _apiClient.delete<dynamic>(
      '/cards/delete/$cardId',
    );

    return result.fold(
      (error) => Result.error(error),
      (_) => Result.ok(null),
    );
  }
}
