class CartItem {
  final int id;
  final String title;
  final String image;
  final String size;
  final double price;
  final int quantity;

  CartItem({
    required this.id,
    required this.title,
    required this.image,
    required this.size,
    required this.price,
    required this.quantity,
  });

  CartItem copyWith({
    int? id,
    String? title,
    String? image,
    String? size,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      size: size ?? this.size,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        size: json['size'],
        price: (json['price'] as num).toDouble(),
        quantity: json['quantity'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'image': image,
        'size': size,
        'price': price,
        'quantity': quantity,
      };
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

  CartModel copyWith({
    List<CartItem>? items,
    double? subTotal,
    double? vat,
    double? shippingFee,
    double? total,
  }) {
    return CartModel(
      items: items ?? this.items,
      subTotal: subTotal ?? this.subTotal,
      vat: vat ?? this.vat,
      shippingFee: shippingFee ?? this.shippingFee,
      total: total ?? this.total,
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) => CartModel(
        items: (json['items'] as List)
            .map((e) => CartItem.fromJson(e))
            .toList(),
        subTotal: (json['subTotal'] as num).toDouble(),
        vat: (json['vat'] as num).toDouble(),
        shippingFee: (json['shippingFee'] as num).toDouble(),
        total: (json['total'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'items': items.map((e) => e.toJson()).toList(),
        'subTotal': subTotal,
        'vat': vat,
        'shippingFee': shippingFee,
        'total': total,
      };
}
