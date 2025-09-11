
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:store_app/feature/auth/managers/register_view_model.dart.dart';

import 'client.dart';

final List<SingleChildWidget> dependencies = [
  Provider<ApiClient>(
    create: (context) => ApiClient(),
  ),
  ChangeNotifierProvider<RegisterViewModel>(
    create: (_) => RegisterViewModel(),
  ),
  
];
