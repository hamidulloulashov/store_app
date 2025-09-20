class NotificationModel {
  final int id;
  final String title;
  final String icon;
  final String content;
  final DateTime date; 

  NotificationModel({
    required this.id,
    required this.title,
    required this.icon,
    required this.content,
    required this.date,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] as int,
      title: json['title'] as String,
      icon: json['icon'] as String,
      content: json['content'] as String,
      date: DateTime.parse(json['date']), 
    );
  }
}
