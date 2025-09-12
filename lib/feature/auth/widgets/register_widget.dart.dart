import 'package:flutter/material.dart';
import 'package:store_app/core/utils/app_colors.dart';

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
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.inverseSurface,),
        hintText: hint,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.inverseSurface,),
        errorText: errorText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorText != null
                ? Colors.red
                : success
                    ?AppColors.sucses
                    : Colors.grey,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: errorText != null
                ? AppColors.error
                : success
                    ? AppColors.sucses
                    : AppColors.containerBlue,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: errorText != null
            ? Icon(Icons.error, color: AppColors.error)
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
