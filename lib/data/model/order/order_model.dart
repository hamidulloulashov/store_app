// order_model.dart
class OrderModel {
  final int id;
  final String orderNumber;
  final String status; // ongoing, completed, cancelled
  final double totalAmount;
  final String paymentMethod;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.totalAmount,
    required this.paymentMethod,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? 0,
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? 'ongoing',
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      paymentMethod: json['payment_method'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : DateTime.now(),
      items: (json['items'] as List<dynamic>?)
              ?.map((item) => OrderItemModel.fromJson(item))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'status': status,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'created_at': createdAt.toIso8601String(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }

  OrderModel copyWith({
    int? id,
    String? orderNumber,
    String? status,
    double? totalAmount,
    String? paymentMethod,
    DateTime? createdAt,
    List<OrderItemModel>? items,
  }) {
    return OrderModel(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      status: status ?? this.status,
      totalAmount: totalAmount ?? this.totalAmount,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      createdAt: createdAt ?? this.createdAt,
      items: items ?? this.items,
    );
  }
}

class OrderItemModel {
  final int id;
  final int productId;
  final String productName;
  final String productImage;
  final double price;
  final int quantity;
  final String size;
  final String? color;

  const OrderItemModel({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productImage,
    required this.price,
    required this.quantity,
    required this.size,
    this.color,
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
      color: json['color'],
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
      if (color != null) 'color': color,
    };
  }
}

// Order tracking status
class OrderTrackingStatus {
  final String status;
  final String description;
  final DateTime? timestamp;
  final bool isCompleted;

  const OrderTrackingStatus({
    required this.status,
    required this.description,
    this.timestamp,
    required this.isCompleted,
  });

  factory OrderTrackingStatus.fromJson(Map<String, dynamic> json) {
    return OrderTrackingStatus(
      status: json['status'] ?? '',
      description: json['description'] ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'])
          : null,
      isCompleted: json['is_completed'] ?? false,
    );
  }
}