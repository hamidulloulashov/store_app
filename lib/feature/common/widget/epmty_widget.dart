import 'package:flutter/material.dart';

class EmptyNotificationWidget extends StatelessWidget {
  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String message;
  final TextStyle? messageStyle;

  const EmptyNotificationWidget({
    super.key,
    this.icon = Icons.notifications_off,
    this.iconSize = 80,
    this.iconColor = Colors.grey,
    this.message = "Sizda hozircha hech qanday bildirishnoma yo‘q",
    this.messageStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: iconSize, color: iconColor),
          const SizedBox(height: 16),
          Text(
            message,
            style: messageStyle ??
                const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
 