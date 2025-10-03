// Address Model
class AddressModel {
  final int id;
  final String title;
  final String fullAddress;
  final double? latitude;
  final double? longitude;
  final bool isDefault;

  const AddressModel({
    required this.id,
    required this.title,
    required this.fullAddress,
    this.latitude,
    this.longitude,
    this.isDefault = false,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      fullAddress: json['full_address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'full_address': fullAddress,
      'latitude': latitude,
      'longitude': longitude,
      'is_default': isDefault,
    };
  }

  AddressModel copyWith({
    int? id,
    String? title,
    String? fullAddress,
    double? latitude,
    double? longitude,
    bool? isDefault,
  }) {
    return AddressModel(
      id: id ?? this.id,
      title: title ?? this.title,
      fullAddress: fullAddress ?? this.fullAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

// Card Model
class CardModel {
  final int id;
  final String maskedNumber;
  final String? cardHolderName;
  final String? expiryDate;
  final String cardType; // visa, mastercard, etc.
  final bool isDefault;

  const CardModel({
    required this.id,
    required this.maskedNumber,
    this.cardHolderName,
    this.expiryDate,
    this.cardType = 'visa',
    this.isDefault = false,
  });

  factory CardModel.fromJson(Map<String, dynamic> json) {
    return CardModel(
      id: json['id'] ?? 0,
      maskedNumber: json['masked_number'] ?? '**** **** **** ****',
      cardHolderName: json['card_holder_name'],
      expiryDate: json['expiry_date'],
      cardType: json['card_type'] ?? 'visa',
      isDefault: json['is_default'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'masked_number': maskedNumber,
      'card_holder_name': cardHolderName,
      'expiry_date': expiryDate,
      'card_type': cardType,
      'is_default': isDefault,
    };
  }

  CardModel copyWith({
    int? id,
    String? maskedNumber,
    String? cardHolderName,
    String? expiryDate,
    String? cardType,
    bool? isDefault,
  }) {
    return CardModel(
      id: id ?? this.id,
      maskedNumber: maskedNumber ?? this.maskedNumber,
      cardHolderName: cardHolderName ?? this.cardHolderName,
      expiryDate: expiryDate ?? this.expiryDate,
      cardType: cardType ?? this.cardType,
      isDefault: isDefault ?? this.isDefault,
    );
  }
}

// Order Model
class OrderModel {
  final int id;
  final String orderNumber;
  final String status;
  final double totalAmount;
  final String paymentMethod;
  final AddressModel deliveryAddress;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? 'pending',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      deliveryAddress: AddressModel.fromJson(json['delivery_address'] ?? {}),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      items: (json['items'] as List<dynamic>?)
          ?.map((item) => OrderItemModel.fromJson(item))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'delivery_address': deliveryAddress.toJson(),
      'created_at': createdAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

// Order Item Model
class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String size;

  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.size,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'] ?? 0,
      productId: json['product_id'] ?? 0,
      productName: json['product_name'] ?? '',
      productImage: json['product_image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      quantity: json['quantity'] ?? 1,
      size: json['size'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'size': size,
    };
  }
}