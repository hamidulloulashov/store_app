class ReviewModel {
  final int? id;
  final int orderId;
  final int rating;
  final String comment;
  final DateTime? createdAt;

  const ReviewModel({
    this.id,
    required this.orderId,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
      id: json['id'],
      orderId: json['order_id'] ?? 0,
      rating: json['rating'] ?? 5,
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'order_id': orderId,
      'rating': rating,
      'comment': comment,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    };
  }
}



