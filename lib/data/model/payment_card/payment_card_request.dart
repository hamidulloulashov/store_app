class CreateCardRequest {
  final String cardNumber;
  final String expiryDate;   
  final String securityCode;
  final String? payload;     
  CreateCardRequest({
    required this.cardNumber,
    required this.expiryDate,
    required this.securityCode,
    this.payload,
  });

  Map<String, dynamic> toJson() => {
    'cardNumber': cardNumber,
    'expiryDate': expiryDate,
    'securityCode': securityCode,
    if (payload != null) 'payload': payload,
  };
}
