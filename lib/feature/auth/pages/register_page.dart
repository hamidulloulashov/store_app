import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../managers/register_view_model.dart.dart';
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

  String? _fullNameError;
  String? _emailError;
  String? _passwordError;

  bool get _isFullNameValid =>
      _fullNameController.text.trim().isNotEmpty && _fullNameError == null;

  bool get _isEmailValid =>
      RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
              .hasMatch(_emailController.text.trim()) &&
      _emailError == null;

  bool get _isPasswordValid =>
      _passwordController.text.trim().length >= 6 && _passwordError == null;

  bool get _isFormValid => _isFullNameValid && _isEmailValid && _isPasswordValid;

  void _validateFields() {
    setState(() {
      _fullNameError =
          _fullNameController.text.trim().isEmpty ? "Full Name required" : null;

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
    _fullNameController.addListener(_validateFields);
    _emailController.addListener(_validateFields);
    _passwordController.addListener(_validateFields);
  }

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<RegisterViewModel>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Create an account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text("Let's create your account."),
              const SizedBox(height: 32),

              // Full Name
              CustomTextField(
                controller: _fullNameController,
                label: "Full Name",
                hint: "Enter your full name",
                success: _isRegistered && _isFullNameValid,
                errorText: _fullNameError,
              ),
              const SizedBox(height: 16),

              // Email
              CustomTextField(
                controller: _emailController,
                label: "Email",
                hint: "Enter your email address",
                success: _isRegistered && _isEmailValid,
                errorText: _emailError,
              ),
              const SizedBox(height: 16),

              // Password
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

              // Create account button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: authVM.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _isFormValid
                            ? () async {
                                _validateFields();

                                if (_isFormValid) {
                                  final success = await authVM.register(
                                    _fullNameController.text.trim(),
                                    _emailController.text.trim(),
                                    _passwordController.text.trim(),
                                  );

                                  if (success && mounted) {
                                    setState(() {
                                      _isRegistered = true;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              "Account created successfully!")),
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(authVM.errorMessage ??
                                            "Something went wrong"),
                                      ),
                                    );
                                  }
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              _isFormValid ? Colors.black : Colors.grey,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          "Create an Account",
                          style: TextStyle(color: Colors.white, fontSize: 16),
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
                  label: const Text("Sign Up with Google"),
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

              // Already have account
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Log In"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
