import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:store_app/core/dependencies.dart' show dependencies;
import 'package:store_app/feature/common/managers/theme_bloc.dart' show ThemeBloc, ThemeState;
import 'package:store_app/firebase_options.dart';
import 'core/router/router.dart' as AppRouter;
import 'core/utils/app_theme.dart';
void main() async  {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final token = await FirebaseMessaging.instance.getToken();
  await FirebaseMessaging.instance.requestPermission();
  print('telefon token🛑: ${token}');
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
    return BlocBuilder<ThemeBloc, ThemeState>(  
      builder: (context, state) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          title: 'My Cooking App',
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: state.themeMode, 
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}

