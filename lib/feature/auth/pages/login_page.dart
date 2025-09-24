import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/feature/auth/managers/login/login_event.dart';
import 'package:store_app/feature/auth/managers/login/login_state.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import '../managers/login/login_bloc.dart'; // Bu faylda hamma narsa bor
import '../widgets/register_widget.dart.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoggedIn = false;

  String? _loginError;
  String? _passwordError;

  bool get _isLoginValid =>
      _loginController.text.trim().isNotEmpty && _loginError == null;

  bool get _isPasswordValid =>
      _passwordController.text.trim().length >= 6 && _passwordError == null;

  bool get _isFormValid => _isLoginValid && _isPasswordValid;

  void _validateFields() {
    setState(() {
      _loginError =
          _loginController.text.trim().isEmpty ? "Login required" : null;

      _passwordError = _passwordController.text.trim().length < 6
          ? "Password must be at least 6 characters"
          : null;
    });
  }

  @override
  void initState() {
    super.initState();
    _loginController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LoginBloc(),
      child: BlocConsumer<LoginBloc, LoginState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
          
          // Success state uchun listener
          if (state.isSuccess && mounted) {
            setState(() {
              _isLoggedIn = true;
            });
            GoRouter.of(context).go("/home");
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: CustomAppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      "Login to your account",
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text("It's great to see you again."),
                    const SizedBox(height: 32),

                    CustomTextField(
                      controller: _loginController,
                      label: "Email",
                      hint: "Enter your email address",
                      success: _isLoggedIn && _isLoginValid,
                      errorText: _loginError,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      obscure: !_isPasswordVisible,
                      success: _isLoggedIn && _isPasswordValid,
                      errorText: _passwordError,
                      onTogglePassword: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Forgot your password?",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push("/forgot-password");
                          },
                          child: Text(
                            "Reset your password",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _isFormValid
                                  ? () {
                                      _validateFields();

                                      if (_isFormValid) {
                                        // Event yuboramiz
                                        context.read<LoginBloc>().add(
                                          LoginSubmitted(
                                            login: _loginController.text.trim(),
                                            password: _passwordController.text.trim(),
                                          ),
                                        );
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormValid
                                    ? Theme.of(context).colorScheme.onSurface
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.onInverseSurface,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          side: BorderSide(
                              color: Theme.of(context).colorScheme.inverseSurface),
                        ),
                        icon: Image.asset("assets/google.png", height: 24),
                        label: Text(
                          "Sign Up with Google",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.inverseSurface,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: Image.asset("assets/facebook.png", height: 24),
                        label: const Text("Sign Up with Facebook"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push("/register");
                          },
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.inverseSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}