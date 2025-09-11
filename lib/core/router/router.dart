import 'package:go_router/go_router.dart';
import 'package:store_app/core/router/routes.dart';
import 'package:store_app/feature/onboarding/pages/splash_page.dart';

 final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => SplashPage(),
      ),
    ],
  );



