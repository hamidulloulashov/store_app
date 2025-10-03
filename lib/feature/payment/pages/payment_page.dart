import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/utils/app_colors.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/payment/managers/payment_bloc.dart';
import 'package:store_app/feature/payment/managers/payment_event.dart';
import 'package:store_app/feature/payment/managers/payment_state.dart';
import 'package:store_app/feature/payment/pages/payment_new_page.dart';
import 'package:store_app/data/model/payment_card/payment_card_model.dart';
class PaymentPage extends StatefulWidget {
  final int? preSelectedCardId;
  
  const PaymentPage({
    super.key,
    this.preSelectedCardId,
  });

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  int? selectedCardId;

  @override
  void initState() {
    super.initState();
    selectedCardId = widget.preSelectedCardId;
    context.read<PaymentBloc>().add(LoadCardsEvent());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: CustomAppBar(
        title: "Payment Method",
        arrow: "assets/arrow.png",
        first: "assets/notifaction.png",
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Saved Cards',
                style: textTheme.titleMedium?.copyWith(
                  color: cs.onBackground,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<PaymentBloc, PaymentState>(
              builder: (context, state) {
                if (state is CardLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CardErrorState) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Xato: ${state.error}',
                            style: TextStyle(color: cs.error)),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<PaymentBloc>().add(LoadCardsEvent()),
                          child: const Text('Qayta urinish'),
                        ),
                      ],
                    ),
                  );
                }
                if (state is CardsLoadedState) {
                  final cards = state.cards;
                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: cards.length + 1,
                    itemBuilder: (context, index) {
                      if (index < cards.length) {
                        final PaymentCardModel card = cards[index];
                        final cardValue = card.id ?? index;
                        final isDefault = index == 0;

                        return InkWell(
                          onTap: () => setState(() => selectedCardId = cardValue),
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 14),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: cs.outline.withOpacity(0.3),
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: cs.shadow.withOpacity(0.05),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 28,
                                  decoration: BoxDecoration(
                                    color: cs.primary,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    'VISA',
                                    style: TextStyle(
                                      color: cs.onPrimary,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _formatCardNumber(card.cardNumber),
                                        style: textTheme.bodyLarge?.copyWith(
                                          color: cs.onSurface,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      if (isDefault)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color: cs.surfaceVariant.withOpacity(0.2),
                                            borderRadius: BorderRadius.circular(16),
                                            border: Border.all(
                                                color: cs.outline.withOpacity(0.3)),
                                          ),
                                          child: Text(
                                            'Default',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: cs.onSurfaceVariant,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: cs.error),
                                  onPressed: () => _showDeleteConfirmation(card.id),
                                ),
                                Radio<int>(
                                  value: cardValue,
                                  groupValue: selectedCardId,
                                  fillColor: MaterialStateProperty.resolveWith(
                                    (states) => states.contains(MaterialState.selected)
                                        ? cs.onSurface
                                        : cs.onSurfaceVariant,
                                  ),
                                  onChanged: (v) =>
                                      setState(() => selectedCardId = v),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        return InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PaymentNewPage(),
                              ),
                            );
                            if (result == true) {
                              context.read<PaymentBloc>().add(LoadCardsEvent());
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: cs.surface,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: cs.outline.withOpacity(0.3),
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add, color: cs.onSurface),
                                const SizedBox(width: 8),
                                Text(
                                  'Add New Card',
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: cs.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  );
                }
                return const SizedBox();
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: selectedCardId == null 
                ? null 
                : () {
                    final state = context.read<PaymentBloc>().state;
                    if (state is CardsLoadedState) {
                      final selectedCard = state.cards.firstWhere(
                        (card) => card.id == selectedCardId,
                      );
                      Navigator.pop(context, selectedCard);
                    }
                  },
              style: ElevatedButton.styleFrom(
                backgroundColor: cs.onSurface,
                disabledBackgroundColor: cs.primary.withOpacity(0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                'Apply',
                style: textTheme.titleMedium?.copyWith(
                  color: cs.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCardNumber(String cardNumber) {
    if (cardNumber.length >= 4) {
      final lastFour = cardNumber.substring(cardNumber.length - 4);
      return '**** **** **** $lastFour';
    }
    return cardNumber;
  }

  void _showDeleteConfirmation(int? cardId) {
    if (cardId == null) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF2A2A2A),
        title: const Text('Delete Card',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to delete this card?',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.primary)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<PaymentBloc>().add(DeleteCardEvent(cardId));
            },
            child: const Text('Delete',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}