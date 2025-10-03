import 'package:store_app/data/model/checout/checout_model.dart';
import 'package:store_app/data/model/payment_card/payment_card_model.dart';
import '../../core/client.dart';
import '../../core/result.dart';

class CheckoutRepository {
  final ApiClient apiClient;
  CheckoutRepository({required this.apiClient});

  Future<Result<List<AddressModel>>> getUserAddresses() async {
    final res = await apiClient.get<List<dynamic>>('/addresses/list');
    return res.fold(
      (err) => Result.error(err),
      (data) => Result.ok(
        data.map((e) => AddressModel.fromJson(e as Map<String,dynamic>)).toList(),
      ),
    );
  }

  Future<Result<List<CardModel>>> getUserCards() async {
    final res = await apiClient.get<List<dynamic>>('/cards/list');
    return res.fold(
      (err) => Result.error(err),
      (data) => Result.ok(
        data.map((paymentCard) {
          final json = paymentCard as Map<String, dynamic>;
          final payment = PaymentCardModel.fromJson(json);
          
          // PaymentCardModel -> CardModel konvertatsiya
          return CardModel(
            id: payment.id ?? 0,
            maskedNumber: payment.cardNumber,
            cardHolderName: null,
            expiryDate: null,
            cardType: 'visa',
            isDefault: false,
          );
        }).toList(),
      ),
    );
  }

  Future<Result<List<String>>> getPaymentMethods() async {
    return const Result.ok(['Card', 'Cash', 'Pay']);
  }

  Future<Result<OrderModel>> placeOrder({
    required int addressId,
    required String paymentMethod,
    String? promoCode,
    int? cardId,
  }) async {
    final res = await apiClient.post<Map<String,dynamic>>('/orders/create', data: {
      'addressId': addressId,
      'paymentMethod': paymentMethod,
      if (promoCode != null) 'promoCode': promoCode,
      if (cardId != null) 'cardId': cardId,
    });
    return res.fold(
      (err) => Result.error(err),
      (data) => Result.ok(OrderModel.fromJson(data)),
    );
  }
}