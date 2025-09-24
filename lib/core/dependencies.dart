import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/repostories/card_repository.dart' show CartRepository;
import 'package:store_app/data/repostories/home_repostrory.dart' as homeRepo;
import 'package:store_app/data/repostories/favourite_repository.dart';
import 'package:store_app/data/repostories/search_repository.dart';
import 'package:store_app/data/repostories/sort_repository.dart' as sortRepo;
import 'package:store_app/feature/auth/managers/forgot/forgot_bloc.dart' show ForgotPasswordBloc;
import 'package:store_app/feature/card/managers/card_bloc.dart' show CartBloc;
import 'package:store_app/feature/common/managers/save_bloc.dart';
import 'package:store_app/feature/common/managers/theme_bloc.dart';
import 'package:store_app/feature/home/managers/home/product_bloc.dart';
import 'package:store_app/feature/search/managers/search_bloc.dart';
import 'client.dart';

/// 🔑 ApiClient provider
final apiClientProvider = Provider<ApiClient>(create: (_) => ApiClient());

/// 🔑 Product repository
final productRepoProvider = Provider<homeRepo.ProductRepository>(
  create: (context) => homeRepo.ProductRepositoryImpl(context.read<ApiClient>()),
);

/// 🔑 Sort repository
final sortRepoProvider = Provider<sortRepo.SortRepository>(
  create: (context) => sortRepo.ProductRepositoryImpl(context.read<ApiClient>()),
);

/// 🔑 Saved products repository
final savedRepoProvider = Provider<ProductRepositories>(
  create: (context) => ProductRepositories(context.read<ApiClient>()),
);

/// 🔑 Search repository
final searchRepoProvider = Provider<SearchRepository>(
  create: (context) => SearchRepository(),
);

/// 🔑 ✅ Cart repository  (⟵ shu yo‘q edi)
final cartRepoProvider = Provider<CartRepository>(
  create: (context) => CartRepository(apiClient: context.read<ApiClient>()),
);


/// Barcha dependencylar
final List<SingleChildWidget> dependencies = [
  apiClientProvider,
  productRepoProvider,
  sortRepoProvider,
  savedRepoProvider,
  searchRepoProvider,
  cartRepoProvider, // ✅ endi mavjud
     Provider(create: (_) => ApiClient()),
  // Bloc lar
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

  /// ✅ CartBloc
  BlocProvider<CartBloc>(
    create: (context) => CartBloc(context.read<CartRepository>()),
  ),
];
