class CartItem {
  final int id;
  final int productId;
  final String title;
  final String size;
  final int sizeId; 
  final double price;
  final String image;
  final int quantity;
  CartItem({
    required this.id,
    required this.productId,
    required this.title,
    required this.size,
    required this.sizeId, 
    required this.price,
    required this.image,
    required this.quantity,
  });
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] ?? 0,
      productId: json['productId'] ?? 0,
      title: json['title'] ?? '',
      size: json['size']?.toString() ?? '',
      sizeId: json['sizeId'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      image: json['image'] ?? '',
      quantity: json['quantity'] ?? 0,
    );
  }
}
class CartModel {
  final List<CartItem> items;
  final double subTotal;
  final double vat;
  final double shippingFee;
  final double total;

  CartModel({
    required this.items,
    required this.subTotal,
    required this.vat,
    required this.shippingFee,
    required this.total,
  });

  factory CartModel.fromJson(Map<String, dynamic> json) {
    final list = (json['items'] as List<dynamic>?)
            ?.map((e) => CartItem.fromJson(e))
            .toList() ??
        [];
    return CartModel(
      items: list,
      subTotal: (json['subTotal'] as num?)?.toDouble() ?? 0.0,
      vat: (json['vat'] as num?)?.toDouble() ?? 0.0,
      shippingFee: (json['shippingFee'] as num?)?.toDouble() ?? 0.0,
      total: (json['total'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
