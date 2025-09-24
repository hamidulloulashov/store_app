class SortModel {
  final int id;
  final String title;
  final double price;
  final int categoryId;
  final int sizeId;
  final String imageUrl;

  SortModel({
    required this.id,
    required this.title,
    required this.price,
    required this.categoryId,
    required this.sizeId,
    required this.imageUrl,
  });

 factory SortModel.fromJson(Map<String, dynamic> json) {
  return SortModel(
    id: json['id'],
    title: json['title'],
    price: (json['price'] as num).toDouble(),
    categoryId: json['categoryId'],
    sizeId: json['sizeId'] ?? 0,
    imageUrl: json['image'] ?? '',
  );
}
}
