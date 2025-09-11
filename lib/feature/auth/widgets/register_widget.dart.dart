import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscure;
  final bool success;
  final String? errorText;
  final VoidCallback? onTogglePassword;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    this.obscure = false,
    this.success = false,
    this.errorText,
    this.onTogglePassword,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorText != null
                ? Colors.red
                : success
                    ? Colors.green
                    : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorText != null
                ? Colors.red
                : success
                    ? Colors.green
                    : Colors.blue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: errorText != null
            ? const Icon(Icons.error, color: Colors.red)
            : success
                ? const Icon(Icons.check_circle, color: Colors.green)
                : (onTogglePassword != null
                    ? IconButton(
                        icon: Icon(
                          obscure ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: onTogglePassword,
                      )
                    : null),
      ),
    );
  }
}
