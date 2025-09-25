import 'package:flutter/material.dart';
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "FAQs",
        first: "assets/notifaction.png",
        arrow: "assets/arrow.png",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            _buildFaqItem(
              "How do I make a purchase?",
              "When you find a product you want to purchase, tap on it to view the product details. Check the price, description, and available options (if applicable), then tap the 'Add to Cart' button.",
            ),
            _buildFaqItem(
              "What payment methods are accepted?",
              "We accept all major credit cards and digital wallets.",
            ),
            _buildFaqItem(
              "How do I track my orders?",
              "Go to 'My Orders' section to track your shipments.",
            ),
            _buildFaqItem(
              "Can I cancel or return an order?",
              "You can cancel or return within 14 days following the instructions.",
            ),
            _buildFaqItem(
              "How can I contact customer support for assistance?",
              "Use the Help Center or contact us via WhatsApp.",
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigatorNews(),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return ExpansionTile(
      title: Text(question, style: const TextStyle(fontWeight: FontWeight.w600)),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(answer),
        ),
      ],
    );
  }
}