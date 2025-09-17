
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:store_app/feature/auth/managers/forgot_veiw_model.dart';
import 'package:store_app/feature/auth/managers/login_view_model.dart' show LoginViewModel;
import 'package:store_app/feature/auth/managers/register_view_model.dart';

import '../feature/common/managers/theme_view_model.dart';
import 'client.dart';

final List<SingleChildWidget> dependencies = [
  Provider<ApiClient>(
    create: (context) => ApiClient(),
  ),
  ChangeNotifierProvider<RegisterViewModel>(
    create: (_) => RegisterViewModel(),
  ),
  ChangeNotifierProvider<LoginViewModel>(
    create: (_) => LoginViewModel(),
  ),
    ChangeNotifierProvider<ThemeViewModel>(
    create: (_) => ThemeViewModel(),
  ),
      ChangeNotifierProvider<ForgotPasswordViewModel>(
    create: (_) => ForgotPasswordViewModel(),
  ),
       ChangeNotifierProvider<ForgotPasswordViewModel>(
    create: (_) => ForgotPasswordViewModel(),
  ),
  
];
