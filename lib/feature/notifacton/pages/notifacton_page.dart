import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:store_app/data/repostories/notifaction_repositoriya.dart';
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/common/widget/epmty_widget.dart';
import '../managers/date_helpr.dart';
import '../managers/notifaction_bloc.dart';
import '../managers/notifaction_event.dart';
import '../managers/notifaction_state.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NotificationBloc(NotificationRepository())..add(LoadNotifications()),
      child: Scaffold(
        bottomNavigationBar: const BottomNavigatorNews(),
        appBar: const CustomAppBar(
          arrow: "assets/arrow.png",
          title: "Notifications",
        ),
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            if (state is NotificationLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NotificationError) {
              return const EmptyNotificationWidget(
                icon: Icons.error_outline,
                iconSize: 100,
                iconColor: Colors.red,
                message: "Xatolik yuz berdi",
                messageStyle: TextStyle(fontSize: 18, color: Colors.red),
              );
            } else if (state is NotificationLoaded) {
              final notifications = state.notifications;
              if (notifications.isEmpty) {
                return const EmptyNotificationWidget(
                  icon: Icons.notifications_off,
                  iconSize: 80,
                  iconColor: Colors.grey,
                  message: "Sizda hozircha hech qanday bildirishnoma yo‘q",
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  final notif = notifications[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: SvgPicture.network(
                        notif.icon,
                        height: 32,
                        width: 32,
                        placeholderBuilder: (context) => const CircularProgressIndicator(),
                      ),
                      title: Text(
                        notif.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        formatNotificationDate(notif.date),
                        style: const TextStyle(color: Colors.grey, fontSize: 13),
                      ),
                    ),
                  );
                },
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}