import 'package:flutter/material.dart';

class ProfilePhoneField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  const ProfilePhoneField({
    super.key,
    required this.controller,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Phone Number',
            style: theme.textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🇺🇸', style: TextStyle(fontSize: 20)),
                  SizedBox(width: 8),
                  Text('+1', style: TextStyle(fontSize: 16)),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: controller,
                keyboardType: TextInputType.phone,
                validator: (v) => v == null || v.isEmpty ? 'Phone number is required' : null,
                onChanged: onChanged,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
                  hintText: 'Enter phone number',
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: theme.colorScheme.outline.withOpacity(0.3)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
