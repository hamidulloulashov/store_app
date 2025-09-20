import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/router/routes.dart';
import '../managers/theme_bloc.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final String? arrow; 
  final String? first; 
  final VoidCallback? onFirstTap; 
  final Color? containerColor;
  final PreferredSizeWidget? bottom;

  const CustomAppBar({
    super.key,
    this.title,
    this.actions,
    this.arrow,
    this.first,
    this.onFirstTap,
    this.containerColor,
    this.bottom,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: containerColor ??
              Theme.of(context).appBarTheme.backgroundColor,
          bottom: bottom,
          leading: arrow != null
              ? GestureDetector(
                  onTap: () {
                    if (Navigator.of(context).canPop()) Navigator.of(context).pop();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(19),
                    child: Image.asset(
                      arrow!,
                      width: 24,
                      height: 24,
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  ),
                )
              : null,
          title: title != null
              ? Center(
                  child: Text(
                    title!,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
              : null,
          actions: [
            if (first != null)
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: onFirstTap ?? () {
                    GoRouter.of(context).push(Routes.notification);
                  },
                  child: Image.asset(
                    first!,
                    width: 20,
                    height: 20,
                    color: Theme.of(context).colorScheme.inverseSurface,
                  ),
                ),
              ),
            ...?actions,
            IconButton(
              icon: Icon(state.isDark ? Icons.dark_mode : Icons.light_mode),
              onPressed: () => context.read<ThemeBloc>().add(ToggleThemeEvent()),
            ),
          ],
        );
      },
    );
  }
}
