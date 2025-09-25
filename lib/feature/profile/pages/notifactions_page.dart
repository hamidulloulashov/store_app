import 'package:flutter/material.dart';
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Map<String, bool> notifications = {
    "General Notifications": true,
    "Sound": true,
    "Vibrate": false,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: CustomAppBar(
        arrow: "assets/arrow.png",
        first: "assets/notifaction.png",
        title: "Notifaction",
      ),
      body: ListView.separated(
  padding: const EdgeInsets.all(16),
  itemCount: notifications.length,
  separatorBuilder: (_, __) => const Divider(),
  itemBuilder: (context, index) {
    final key = notifications.keys.elementAt(index);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      title: Text(key),
      trailing: Transform.scale(
        scale: 0.7, 
        child: Switch(
          value: notifications[key]!,
          activeColor: isDark ? Colors.white : Colors.black,
          inactiveThumbColor: isDark ? Colors.grey[800] : Colors.grey[300],
          inactiveTrackColor: isDark ? Colors.grey[600] : Colors.grey[400],
          onChanged: (value) {
            setState(() {
              notifications[key] = value;
            });
          },
        ),
      ),
    );
  },
),

      bottomNavigationBar: const BottomNavigatorNews(),
    );
  }
}
