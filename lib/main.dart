import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/dependencies.dart' show dependencies;
import 'core/router/router.dart' as AppRouter;
void main() {
  runApp(
    MultiProvider(
      providers: dependencies,
      child: const MyApp(),
    ),
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
