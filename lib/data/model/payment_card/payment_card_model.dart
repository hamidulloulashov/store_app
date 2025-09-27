
class PaymentCardModel {
  final int? id;
  final String cardNumber;

  const PaymentCardModel({
    this.id,
    required this.cardNumber,
  });

  factory PaymentCardModel.fromJson(Map<String, dynamic> json) => PaymentCardModel(
        id: json['id'] as int?,
        cardNumber: json['cardNumber'] as String,
      );

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'cardNumber': cardNumber,
      };

  @override
  String toString() => 'PaymentCardModel(id: $id, cardNumber: $cardNumber)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PaymentCardModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          cardNumber == other.cardNumber;

  @override
  int get hashCode => id.hashCode ^ cardNumber.hashCode;
}