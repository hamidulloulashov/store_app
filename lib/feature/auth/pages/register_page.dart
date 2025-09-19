import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import '../managers/aut/register_cubit.dart';
import '../managers/aut/register_state.dart';
import '../widgets/register_widget.dart.dart';
class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isRegistered = false;

  String? _emailError;
  String? _passwordError;

  bool get _isEmailValid =>
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
          .hasMatch(_emailController.text.trim()) &&
      _emailError == null;

  bool get _isPasswordValid =>
      _passwordController.text.trim().length >= 6 && _passwordError == null;

  bool get _isFormValid =>
      _fullNameController.text.trim().isNotEmpty &&
      _isEmailValid &&
      _isPasswordValid;

  void _validateFields() {
    setState(() {
      _emailError = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(_emailController.text.trim())
          ? null
          : "Enter a valid email";

      _passwordError = _passwordController.text.trim().length < 6
          ? "Password must be at least 6 characters"
          : null;
    });
  }

  @override
  void initState() {
    super.initState();
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RegisterCubit(),
      child: BlocConsumer<RegisterCubit, RegisterState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage!)),
            );
          }
        },
        builder: (context, state) {
          final registerCubit = context.read<RegisterCubit>();

          return Scaffold(
            appBar: CustomAppBar(),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    const Text(
                      "Create an account",
                      style: TextStyle(
                          fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text("Let's create your account."),
                    const SizedBox(height: 32),

                    CustomTextField(
                      controller: _fullNameController,
                      label: "Full Name",
                      hint: "Enter your full name",
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _emailController,
                      label: "Email",
                      hint: "Enter your email address",
                      success: _isRegistered && _isEmailValid,
                      errorText: _emailError,
                    ),
                    const SizedBox(height: 16),

                    CustomTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "Enter your password",
                      obscure: !_isPasswordVisible,
                      success: _isRegistered && _isPasswordValid,
                      errorText: _passwordError,
                      onTogglePassword: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                    const SizedBox(height: 20),

                    const Text(
                      "By signing up you agree to our Terms, Privacy Policy, and Cookie Use",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 20),

                    // Submit
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: state.isLoading
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _isFormValid
                                  ? () async {
                                      _validateFields();
                                      if (_isFormValid) {
                                        final success = await registerCubit.register(
                                          fullName: _fullNameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          password: _passwordController.text.trim(),
                                        );

                                        if (success && mounted) {
                                          setState(() {
                                            _isRegistered = true;
                                          });
                                          GoRouter.of(context).go("/home");
                                        }
                                      }
                                    }
                                  : null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _isFormValid
                                    ? Theme.of(context).colorScheme.inverseSurface
                                    : Colors.grey,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                "Create an Account",
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.inversePrimary,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: const [
                        Expanded(child: Divider(thickness: 1)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8),
                          child: Text("Or"),
                        ),
                        Expanded(child: Divider(thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        onPressed: () {},
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
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push("/login");
                          },
                          child: Text(
                            "Log In",
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
