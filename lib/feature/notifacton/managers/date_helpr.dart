import 'package:intl/intl.dart';

String formatNotificationDate(DateTime date) {
  final now = DateTime.now();
  final diff = now.difference(date);

  if (diff.inDays == 0) {
    return "Bugun ${DateFormat.Hm().format(date)}";
  } else if (diff.inDays == 1) {
    return "Kecha ${DateFormat.Hm().format(date)}";
  } else if (diff.inDays < 7) {
    return DateFormat('dd.MM.yyyy – HH:mm').format(date);
  } else {
    return DateFormat('dd.MM.yyyy – HH:mm').format(date);
  }
}
