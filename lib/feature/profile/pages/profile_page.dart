import 'package:flutter/material.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Profile",
        arrow: "assets/arrow.png",
      ),
    );
  }
}