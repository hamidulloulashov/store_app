import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/model/payment_card/payment_card_request.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/payment/managers/payment_bloc.dart';
import 'package:store_app/feature/payment/managers/payment_event.dart';
import 'package:store_app/feature/payment/managers/payment_state.dart';
import 'package:store_app/feature/payment/widgets/sucses_widget.dart' show showSuccessSnackBar;

class PaymentNewPage extends StatefulWidget {
  const PaymentNewPage({super.key});

  @override
  State<PaymentNewPage> createState() => _NewCardScreenState();
}
class _NewCardScreenState extends State<PaymentNewPage> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _securityCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: CustomAppBar(
        title: "New Card",
        arrow: "assets/arrow.png",
        first: "assets/notifaction.png",
      ),
      body: BlocListener<PaymentBloc, PaymentState>(
        listener: (context, state) {
  if (state is CardCreatedState) {
    showSuccessSnackBar(context, "Your new card has been added.");
    Navigator.pop(context, true);
  } else if (state is CardErrorState) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(state.error), backgroundColor: Colors.red),
    );
  }
},

        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction, 
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Add Debit or Credit Card',
                  style: TextStyle(color: cs.onSurface, fontSize: 16),
                ),
                const SizedBox(height: 24),
                _buildCardNumberField(cs),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildExpiryDateField(cs)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildSecurityCodeField(cs)),
                  ],
                ),
                const Spacer(),
                BlocBuilder<PaymentBloc, PaymentState>(
                  builder: (context, state) {
                    final isLoading = state is CardLoadingState;
                    return SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onAddCard,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: cs.onSurface,
                          foregroundColor: cs.error,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : Text(
                                'Add Card',
                                style: TextStyle(
                                  color: cs.surfaceContainer,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardNumberField(ColorScheme cs) {
    return _BorderedField(
      label: 'Card number',
      controller: _cardNumberController,
      hint: 'Enter your card numbers',
      colorScheme: cs,
      inputType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(16),
        _CardNumberFormatter(),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return 'Karta raqamini kiriting';
        if (v.replaceAll(' ', '').length != 16) return '16 ta raqam bo‘lishi kerak';
        return null;
      },
    );
  }

  Widget _buildExpiryDateField(ColorScheme cs) {
    return _BorderedField(
      label: 'Expiry Date',
      controller: _expiryDateController,
      hint: 'MM/YY',
      colorScheme: cs,
      inputType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(4),
        _ExpiryDateFormatter(),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return 'Amal qilish muddatini kiriting';
        if (v.length != 5) return 'MM/YY formatida kiriting';
        final mm = int.tryParse(v.substring(0, 2)) ?? 0;
        if (mm < 1 || mm > 12) return 'Oy noto‘g‘ri';
        return null;
      },
    );
  }

  Widget _buildSecurityCodeField(ColorScheme cs) {
    return _BorderedField(
      label: 'Security Code',
      controller: _securityCodeController,
      hint: 'CVV',
      colorScheme: cs,
      inputType: TextInputType.number,
      obscure: true,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(3),
      ],
      validator: (v) {
        if (v == null || v.isEmpty) return 'CVV kodni kiriting';
        if (v.length != 3) return '3 ta raqam bo‘lishi kerak';
        return null;
      },
      suffixIcon: Icon(Icons.help_outline, color: cs.onSurface.withOpacity(0.5)),
    );
  }

  void _onAddCard() {
    if (_formKey.currentState?.validate() ?? false) {
      final cardNumber = _cardNumberController.text.replaceAll(' ', '');
      final expiryDate = _convertExpiryDate(_expiryDateController.text);
      final securityCode = _securityCodeController.text;

      final request = CreateCardRequest(
        cardNumber: cardNumber,
        expiryDate: expiryDate,
        securityCode: securityCode,
        payload: securityCode,
      );

      context.read<PaymentBloc>().add(CreateCardEvent(request));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Iltimos, qizil bilan belgilangan maydonlarni to‘g‘rilang"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  String _convertExpiryDate(String mmyy) {
    final parts = mmyy.split('/');
    if (parts.length != 2) return DateTime.now().toIso8601String().split('T')[0];
    final month = parts[0].padLeft(2, '0');
    final year = '20${parts[1]}';
    return '$year-$month-01';
  }

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _securityCodeController.dispose();
    super.dispose();
  }
}

class _BorderedField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final ColorScheme colorScheme;
  final TextInputType inputType;
  final bool obscure;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;

  const _BorderedField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.colorScheme,
    required this.inputType,
    this.obscure = false,
    this.inputFormatters,
    this.validator,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: colorScheme.onSurface, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscure,
          keyboardType: inputType,
          inputFormatters: inputFormatters,
          style: TextStyle(color: colorScheme.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: colorScheme.onSurface.withOpacity(0.5)),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: colorScheme.surface.withOpacity(0.05),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.grey, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.blue, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: Colors.red, width: 2),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text.replaceAll(' ', '');
    final buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(text[i]);
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

class _ExpiryDateFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    final text = newValue.text;
    if (text.length <= 2) return newValue;
    final month = text.substring(0, 2);
    final year = text.substring(2);
    return TextEditingValue(
      text: '$month/$year',
      selection: TextSelection.collapsed(offset: '$month/$year'.length),
    );
  }
}
