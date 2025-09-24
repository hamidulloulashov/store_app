class ReviewModel {
  final int id;
  final String comment;
  final double rating;
  final DateTime created;
  final String userFullName;
  ReviewModel({
    required this.id,
    required this.comment,
    required this.rating,
    required this.created,
    required this.userFullName,
  });
  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'] as int,
      comment: json['comment'] as String,
      rating: (json['rating'] as num).toDouble(), // 🔹 double ga aniq aylantirish
      created: DateTime.parse(json['created']),
      userFullName: json['userFullName'] as String,
    );
  }
}
