import 'package:flutter/material.dart';
import '../../../core/utils/app_colors.dart';

class BottomNavigatorNews extends StatefulWidget {
  const BottomNavigatorNews({super.key});

  @override
  State<BottomNavigatorNews> createState() => _BottomNavigatorNewsState();
}

class _BottomNavigatorNewsState extends State<BottomNavigatorNews> {
  final List<String> icons = const [
    "assets/home.png",
    "assets/search.png",
    "assets/love.png",
    "assets/shop.png",
    "assets/profile.png",
  ];

  int _selectedIndex = 0; // default tanlangan icon

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // bosilganda index yangilanadi
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 86,
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context)
                .colorScheme
                .onInverseSurface
                .withAlpha(200),
            blurRadius: 50,
            spreadRadius: 20,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          final bool isSelected = index == _selectedIndex;
          return GestureDetector(
            onTap: () => _onItemTapped(index),
            child: ColorFiltered(
              colorFilter: isSelected
                  ? const ColorFilter.mode(
                      AppColors.containerBlack, BlendMode.srcIn) // 🔥 tanlangan qora
                  : const ColorFilter.mode(
                      Colors.grey, BlendMode.srcIn), // ⚪️ qolganlari kulrang
              child: Image.asset(
                icons[index],
                width: 28,
                height: 25,
              ),
            ),
          );
        }),
      ),
    );
  }
}
