import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/feature/home/managers/product_cubit.dart';
import '../feature/common/managers/theme_view_model.dart';
import '../feature/common/managers/favourite_cubit.dart';
import 'client.dart';
import '../data/repostories/home_repostrory.dart';
import '../data/repostories/favourite_repository.dart';

final List<SingleChildWidget> dependencies = [

  Provider<ApiClient>(
    create: (context) => ApiClient(),
  ),


Provider<ProductRepository>(
  create: (context) => ProductRepositoryImpl(
    context.read<ApiClient>(),
  ),
),


  ChangeNotifierProvider<ThemeViewModel>(
    create: (_) => ThemeViewModel(),
  ),

  BlocProvider<ProductCubit>(
    create: (context) => ProductCubit(
      ProductRepositoryImpl(context.read<ApiClient>()),
    )
      ..loadCategories()
      ..loadProducts(),
  ),

  BlocProvider<SavedCubit>(
    create: (context) => SavedCubit(
      savedProductRepo: ProductRepositories(
        context.read<ApiClient>(),
      ),
    ),
  ),
];
