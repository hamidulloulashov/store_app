import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/client.dart';
import 'package:store_app/data/repostories/cart_repository.dart' show CartRepository;
import 'package:store_app/data/repostories/checout_repository.dart';
import 'package:store_app/data/repostories/home_repostrory.dart' as homeRepo;
import 'package:store_app/data/repostories/favourite_repository.dart';
import 'package:store_app/data/repostories/payment_repository.dart';
import 'package:store_app/data/repostories/profile_update_repository.dart' show ProfileUpdateRepository;
import 'package:store_app/data/repostories/search_repository.dart';
import 'package:store_app/data/repostories/sort_repository.dart' as sortRepo;
import 'package:store_app/feature/auth/managers/forgot/forgot_bloc.dart' show ForgotPasswordBloc;
import 'package:store_app/feature/card/managers/card_bloc.dart' show CartBloc;
import 'package:store_app/feature/checout/managers/checout_bloc.dart';
import 'package:store_app/feature/common/managers/save_bloc.dart';
import 'package:store_app/feature/common/managers/theme_bloc.dart';
import 'package:store_app/feature/home/managers/home/product_bloc.dart';
import 'package:store_app/feature/profile_update/managers/profile_update_bloc.dart' show ProfileUpdateBloc;
import 'package:store_app/feature/search/managers/search_bloc.dart';
import 'package:store_app/feature/payment/managers/payment_bloc.dart';          

final apiClientProvider = Provider<ApiClient>(create: (_) => ApiClient());

final productRepoProvider = Provider<homeRepo.ProductRepository>(
  create: (context) => homeRepo.ProductRepositoryImpl(context.read<ApiClient>()),
);

final sortRepoProvider = Provider<sortRepo.SortRepository>(
  create: (context) => sortRepo.ProductRepositoryImpl(context.read<ApiClient>()),
);

final savedRepoProvider = Provider<ProductRepositories>(
  create: (context) => ProductRepositories(context.read<ApiClient>()),
);

final searchRepoProvider = Provider<SearchRepository>(
  create: (context) => SearchRepository(),
);

final cartRepoProvider = Provider<CartRepository>(
  create: (context) => CartRepository(apiClient: context.read<ApiClient>()),
);

final checkoutRepoProvider = Provider<CheckoutRepository>(
  create: (context) => CheckoutRepository(apiClient: context.read<ApiClient>()),
);

final paymentRepoProvider = Provider<PaymentRepository>(
  create: (context) => PaymentRepository(context.read<ApiClient>()),
);

final List<SingleChildWidget> dependencies = [
  apiClientProvider,
  productRepoProvider,
  sortRepoProvider,
  savedRepoProvider,
  searchRepoProvider,
  cartRepoProvider,
  checkoutRepoProvider,
  paymentRepoProvider,

  Provider(create: (_) => ApiClient()),

  BlocProvider<ThemeBloc>(create: (_) => ThemeBloc()),
  BlocProvider<SavedBloc>(
    create: (context) =>
        SavedBloc(savedProductRepo: context.read<ProductRepositories>()),
  ),
  BlocProvider<ProductBloc>(
    create: (context) =>
        ProductBloc(context.read<homeRepo.ProductRepository>()),
  ),
  BlocProvider<SearchBloc>(
    create: (context) => SearchBloc(context.read<SearchRepository>()),
  ),
  BlocProvider<ForgotPasswordBloc>(create: (_) => ForgotPasswordBloc()),
  BlocProvider<CartBloc>(
    create: (context) => CartBloc(context.read<CartRepository>()),
  ),
  BlocProvider<CheckoutBloc>(
    create: (context) => CheckoutBloc(context.read<CheckoutRepository>()),
  ),
  BlocProvider<PaymentBloc>(
    create: (context) => PaymentBloc(context.read<PaymentRepository>()),
  ),
  BlocProvider<ProfileUpdateBloc>(
    create: (context) => ProfileUpdateBloc(
      ProfileUpdateRepository(context.read<ApiClient>()),
    ),
  ),
];