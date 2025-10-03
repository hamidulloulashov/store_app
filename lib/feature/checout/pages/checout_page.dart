import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/client.dart';
import 'package:store_app/data/repostories/checout_repository.dart';
import 'package:store_app/feature/checout/managers/checout_bloc.dart';
import 'package:store_app/feature/checout/managers/checout_event.dart';
import 'package:store_app/feature/checout/managers/checout_state.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/order/pages/my_order_page.dart';
import 'package:store_app/feature/payment/pages/payment_page.dart';
import 'package:store_app/data/model/payment_card/payment_card_model.dart';
import 'package:store_app/data/model/checout/checout_model.dart';

class CheckoutPage extends StatefulWidget {
  final double subTotal;
  final double vat;
  final double shippingFee;
  final double total;

  const CheckoutPage({
    super.key,
    required this.subTotal,
    required this.vat,
    required this.shippingFee,
    required this.total,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckoutBloc(
        CheckoutRepository(apiClient: context.read<ApiClient>()),
      )..add(LoadCheckoutData()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: "Checkout",
          arrow: "assets/arrow.png",
          first: "assets/notifaction.png",
        ),
        body: BlocConsumer<CheckoutBloc, CheckoutState>(
          listener: (context, state) {
            if (state is CheckoutOrderPlaced) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Buyurtma qabul qilindi"),
                  content: Text(
                    "Buyurtma raqami: ${state.order.orderNumber}\n"
                    "Jami: \$${state.order.totalAmount.toStringAsFixed(2)}",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            } else if (state is CheckoutError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is CheckoutLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CheckoutLoaded) {
              return _buildCheckoutContent(context, state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildCheckoutContent(BuildContext context, CheckoutLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDeliveryAddress(context, state),
          const SizedBox(height: 24),
          _buildPaymentMethod(context, state),
          const SizedBox(height: 24),
          _buildOrderSummary(context, state),
          const SizedBox(height: 16),
          _buildPromoCode(context, state),
          const SizedBox(height: 24),
          _buildPlaceOrderButton(context, state),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress(BuildContext context, CheckoutLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Delivery Address",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            TextButton(
              onPressed: () {
                _showAddressSelector(context, state);
              },
              child: const Text("Change"),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Colors.grey),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      state.selectedAddress?.title ?? "Home",
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Text(
                      state.selectedAddress?.fullAddress ??
                          "925 S Chugach St #APT 10, Alaska 99645",
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _showAddressSelector(BuildContext context, CheckoutLoaded state) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Manzilni tanlang",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ...state.addresses.map((address) => ListTile(
                  leading: const Icon(Icons.location_on),
                  title: Text(address.title),
                  subtitle: Text(address.fullAddress),
                  selected: state.selectedAddress?.id == address.id,
                  onTap: () {
                    context.read<CheckoutBloc>().add(SelectAddress(address));
                    Navigator.pop(ctx);
                  },
                )),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentMethod(BuildContext context, CheckoutLoaded state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Payment Method",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildPaymentOption(
              context,
              "Card",
              Icons.credit_card,
              state.selectedPaymentMethod == "Card",
              () => context.read<CheckoutBloc>().add(const SelectPaymentMethod("Card")),
            ),
            const SizedBox(width: 12),
            _buildPaymentOption(
              context,
              "Cash",
              Icons.money,
              state.selectedPaymentMethod == "Cash",
              () => context.read<CheckoutBloc>().add(const SelectPaymentMethod("Cash")),
            ),
            const SizedBox(width: 12),
            _buildPaymentOption(
              context,
              "Pay",
              Icons.apple,
              state.selectedPaymentMethod == "Pay",
              () => context.read<CheckoutBloc>().add(const SelectPaymentMethod("Pay")),
            ),
          ],
        ),
        if (state.selectedPaymentMethod == "Card") ...[
          const SizedBox(height: 16),
          if (state.cards.isEmpty)
            GestureDetector(
              onTap: () => _navigateToPaymentPage(context, state),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      "Karta qo'shish",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            GestureDetector(
              onTap: () => _navigateToPaymentPage(context, state),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/visa_logo.png",
                      width: 40,
                      height: 24,
                      errorBuilder: (c, e, s) =>
                          const Icon(Icons.credit_card, size: 24),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      state.selectedCard?.maskedNumber ?? '**** **** **** ----',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
        ],
      ],
    );
  }

  Future<void> _navigateToPaymentPage(BuildContext context, CheckoutLoaded state) async {
    final result = await Navigator.push<PaymentCardModel>(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentPage(),
      ),
    );

    if (result != null && mounted) {
      final selectedCard = _convertPaymentToCard(result);
      context.read<CheckoutBloc>().add(SelectCard(selectedCard));
    }
  }

  PaymentCardModel _convertCardToPayment(CardModel card) {
    return PaymentCardModel(
      id: card.id,
      cardNumber: card.maskedNumber,
    );
  }

  CardModel _convertPaymentToCard(PaymentCardModel payment) {
    return CardModel(
      id: payment.id ?? 0,
      maskedNumber: payment.cardNumber,
      cardHolderName: null,
      expiryDate: null,
      cardType: 'visa',
      isDefault: false,
    );
  }

  Widget _buildPaymentOption(
    BuildContext context,
    String title,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            border: Border.all(
              color: isSelected ? Colors.black : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.black,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                title,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOrderSummary(BuildContext context, CheckoutLoaded state) {
    final discount = state.discount;
    final finalTotal = widget.total - discount;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Order Summary",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 16),
        _buildSummaryRow("Sub-total", "\$${widget.subTotal.toStringAsFixed(2)}"),
        _buildSummaryRow("VAT (%)", "\$${widget.vat.toStringAsFixed(2)}"),
        _buildSummaryRow("Shipping fee", "\$${widget.shippingFee.toStringAsFixed(2)}"),
        if (discount > 0)
          _buildSummaryRow(
            "Discount",
            "-\$${discount.toStringAsFixed(2)}",
            isDiscount: true,
          ),
        const SizedBox(height: 8),
        const Divider(),
        const SizedBox(height: 8),
        _buildSummaryRow(
          "Total",
          "\$${finalTotal.toStringAsFixed(2)}",
          isBold: true,
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    String title,
    String amount, {
    bool isBold = false,
    bool isDiscount = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : Colors.grey[700],
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isDiscount ? Colors.green : Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoCode(BuildContext context, CheckoutLoaded state) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _promoController,
              decoration: const InputDecoration(
                hintText: "Enter promo code",
                border: InputBorder.none,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              if (_promoController.text.trim().isNotEmpty) {
                context.read<CheckoutBloc>().add(
                      ApplyPromoCode(_promoController.text.trim()),
                    );
              }
            },
            style: TextButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderButton(BuildContext context, CheckoutLoaded state) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: state.isPlacingOrder
            ? null
            : () {
                context.read<CheckoutBloc>().add(PlaceOrder());
              },
        child: state.isPlacingOrder
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              )
            : const Text(
                "Place Order",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
      ),
    );
  }
}
