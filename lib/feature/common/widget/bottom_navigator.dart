import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BottomNavigatorNews extends StatelessWidget {
  const BottomNavigatorNews({super.key});

  final List<String> icons = const [
    "assets/home.png",
    "assets/search.png",
    "assets/love.png",
    "assets/shop.png",
    "assets/profile.png",
  ];

  int _getSelectedIndex(String location) {
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/search')) return 1;
    if (location.startsWith('/save')) return 2;
    if (location.startsWith('/shop')) return 3;
    if (location.startsWith('/profile')) return 4;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        // context.go('/search');
        break;
      case 2:
        context.go('/save');
        break;
      case 3:
        // context.go('/shop');
        break;
      case 4:
        // context.go('/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final String location = GoRouterState.of(context).uri.toString();
    final int selectedIndex = _getSelectedIndex(location);

    return Container(
      width: double.infinity,
      height: 86,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onErrorContainer,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.onInverseSurface.withAlpha(200),
            blurRadius: 50,
            spreadRadius: 20,
            offset: const Offset(0, 30),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(icons.length, (index) {
          final bool isSelected = index == selectedIndex;

          return GestureDetector(
            onTap: () => _onItemTapped(context, index),
            child: ColorFiltered(
              colorFilter: isSelected
                  ?  ColorFilter.mode(Theme.of(context).colorScheme.onPrimaryContainer, BlendMode.srcIn)
                  : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
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
