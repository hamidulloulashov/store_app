class ProductDetailModel {
  final int id;
  final String title;
  final String description;
  final double price;
  final bool isLiked;
  final List<ProductImage> productImages;
  final List<ProductSize> productSizes;
  final int reviewsCount;
  final double rating;

  ProductDetailModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.isLiked,
    required this.productImages,
    required this.productSizes,
    required this.reviewsCount,
    required this.rating,
  });

  factory ProductDetailModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      isLiked: json['isLiked'],
      productImages: (json['productImages'] as List)
          .map((e) => ProductImage.fromJson(e))
          .toList(),
      productSizes: (json['productSizes'] as List)
          .map((e) => ProductSize.fromJson(e))
          .toList(),
      reviewsCount: json['reviewsCount'],
      rating: (json['rating'] as num).toDouble(),
    );
  }
}

class ProductImage {
  final int id;
  final String image;

  ProductImage({required this.id, required this.image});

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'],
      image: json['image'],
    );
  }
}

class ProductSize {
  final int id;
  final String title;

  ProductSize({required this.id, required this.title});

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      id: json['id'],
      title: json['title'],
    );
  }
}
