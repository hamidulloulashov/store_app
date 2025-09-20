// lib/core/dependencies.dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/feature/common/managers/save_bloc.dart' show SavedBloc;
import '../feature/common/managers/theme_bloc.dart';
import 'client.dart';
import '../data/repostories/home_repostrory.dart';
import '../data/repostories/favourite_repository.dart';

final apiClientProvider = Provider<ApiClient>(create: (_) => ApiClient());

final productRepoProvider = Provider<ProductRepository>(
  create: (context) => ProductRepositoryImpl(context.read<ApiClient>()),
);

final savedRepoProvider = Provider<ProductRepositories>(
  create: (context) => ProductRepositories(context.read<ApiClient>()),
);

final List<SingleChildWidget> dependencies = [
  apiClientProvider,
  productRepoProvider,
  savedRepoProvider,

  BlocProvider<ThemeBloc>(
        create: (_) => ThemeBloc(),
      ),
  BlocProvider<SavedBloc>(
    create: (context) => SavedBloc(savedProductRepo: context.read<ProductRepositories>()),
  ),
];
