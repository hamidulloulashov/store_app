import 'package:flutter/material.dart';

class ProfileDateField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onTap;

  const ProfileDateField({
    super.key,
    required this.controller,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Date of Birth',
            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          validator: (v) => v == null || v.isEmpty ? 'Date of birth is required' : null,
          onTap: onTap,
          decoration: InputDecoration(
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            hintText: 'Select date',
            filled: true,
            fillColor: theme.colorScheme.surface,
            suffixIcon: const Icon(Icons.calendar_today),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
