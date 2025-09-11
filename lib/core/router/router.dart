import 'package:go_router/go_router.dart';
import 'package:store_app/core/router/routes.dart';
import 'package:store_app/feature/auth/pages/register_page.dart';
import 'package:store_app/feature/onboarding/pages/onboarding_page.dart';
import 'package:store_app/feature/onboarding/pages/splash_page.dart';

 final GoRouter router = GoRouter(
    initialLocation: Routes.splash,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => SplashPage(),
      ),
          GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => OnboardingPage(),
      ),
               GoRoute(
        path: Routes.register,
        builder: (context, state) => RegisterPage(),
      ),
    ],
  );



