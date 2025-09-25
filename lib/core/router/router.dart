import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/core/router/routes.dart';
import 'package:store_app/data/model/home/product_model.dart';
import 'package:store_app/feature/auth/pages/forgot_pasword.dart';
import 'package:store_app/feature/auth/pages/login_page.dart';
import 'package:store_app/feature/auth/pages/register_page.dart';
import 'package:store_app/feature/auth/pages/reset_password_page.dart';
import 'package:store_app/feature/card/pages/my_card_page.dart';
import 'package:store_app/feature/common/page/save_page.dart';
import 'package:store_app/feature/home/managers/home/product_bloc.dart';
import 'package:store_app/feature/home/pages/home_page.dart';
import 'package:store_app/feature/auth/pages/onboarding_page.dart';
import 'package:store_app/feature/auth/pages/splash_page.dart';
import 'package:store_app/feature/home/pages/product_detail_page.dart';
import 'package:store_app/feature/notifacton/pages/notifacton_page.dart';
import 'package:store_app/feature/profile/pages/faqs_page.dart';
import 'package:store_app/feature/profile/pages/help_center_page.dart';
import 'package:store_app/feature/profile/pages/notifactions_page.dart';
import 'package:store_app/feature/profile/pages/profile_page.dart';
import 'package:store_app/feature/search/pages/search_page.dart';
 final GoRouter router = GoRouter(
    initialLocation: Routes.home,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => SplashPage(),
      ),
           GoRoute(
        path: Routes.reset,
        builder: (context, state) => ResetPasswordPage(),
      ),
          GoRoute(
        path: Routes.faqs,
        builder: (context, state) => FaqsPage(),
      ),
          GoRoute(
        path: Routes.onboarding,
        builder: (context, state) => OnboardingPage(),
      ),
          GoRoute(
        path: Routes.help,
        builder: (context, state) => HelpCenterPage(),
      ),
           GoRoute(
        path: Routes.notifications,
        builder: (context, state) => NotificationsPage(),
      ),
           GoRoute(
        path: Routes.mycart,
        builder: (context, state) => MyCartPage(),
      ),
               GoRoute(
        path: Routes.register,
        builder: (context, state) => RegisterPage(),
      ),
                GoRoute(
        path: Routes.login,
        builder: (context, state) => LoginPage(),
      ),
                  GoRoute(
        path: Routes.forgot_password,
        builder: (context, state) => ForgotPasswordPage(),
      ),
                       GoRoute(
        path: Routes.home,
        builder: (context, state) => HomePage(),
      ),
                         GoRoute(
        path: Routes.notification,
        builder: (context, state) => NotificationPage(),
      ),
                               GoRoute(
        path: Routes.save,
        builder: (context, state) => SavedPage(),
      ),
                                    GoRoute(
        path: Routes.profile,
        builder: (context, state) => ProfilePage(),
      ),
                                    GoRoute(
        path: Routes.cart,
        builder: (context, state) => MyCartPage(),
      ),
                                          GoRoute(
  path: '${Routes.detail}/:id',
  builder: (context, state) {
    final productId = int.parse(state.pathParameters['id']!);
    return ProductDetailWithReviewsPage(productId: productId);
  },
),


                                         GoRoute(
  path: Routes.search,
  builder: (context, state) {
    final extra = state.extra;
    
    if (extra == null || extra is! Map<String, dynamic>) {
      return const Scaffold(
        body: Center(child: Text("No data provided")),
      );
    }

    final allProducts = extra['allProducts'] as List<ProductModel>? ?? [];
    final productBloc = extra['bloc'] as ProductBloc?;

    if (productBloc == null) {
      return const Scaffold(
        body: Center(child: Text("Bloc is missing")),
      );
    }

    return Builder(
      builder: (context) {
        return BlocProvider.value(
          value: productBloc,
          child: SearchPage(allProducts: allProducts),
        );
      },
    );
  },
),

    
    ],
  );



