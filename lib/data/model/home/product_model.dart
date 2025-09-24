class CategoryModel {
  final int id;
  final String title;

  CategoryModel({required this.id, required this.title});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
      id: json['id'],
      title: json['title'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}
class ProductModel {
  final int id;
  final int categoryId;
  final String title;
  final String image; 
  final double price;
  final bool isLiked;
  final double discount;

  ProductModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.image,
    required this.price,
    required this.isLiked,
    required this.discount,
  });

  String get imageUrl => image;

  ProductModel copyWith({
    int? id,
    int? categoryId,
    String? title,
    String? image,
    double? price,
    bool? isLiked,
    double? discount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      title: title ?? this.title,
      image: image ?? this.image,
      price: price ?? this.price,
      isLiked: isLiked ?? this.isLiked,
      discount: discount ?? this.discount,
    );
  }

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      categoryId: json['categoryId'],
      title: json['title'],
      image: json['image'] ?? '',
      price: (json['price'] as num).toDouble(),
      isLiked: json['isLiked'] ?? false,
      discount: (json['discount'] as num).toDouble(),
    );
  }

  get name => null;

  get description => null;

  get category => null;

  Map<String, dynamic> toJson() => {
        'id': id,
        'categoryId': categoryId,
        'title': title,
        'image': image,
        'price': price,
        'isLiked': isLiked,
        'discount': discount,
      };
}
