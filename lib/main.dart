import 'package:flutter/material.dart';

import 'core/router/router.dart' as AppRouter;
void main() {
  runApp(
    const MyApp(),
    );

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'My Cooking App',
      // theme: AppThemes.lightTheme,
      // darkTheme: AppThemes.darkTheme,
      // themeMode: context.watch<ThemeViewModel>().currentTheme,
      routerConfig: AppRouter.router,
      
    );
  }
}
