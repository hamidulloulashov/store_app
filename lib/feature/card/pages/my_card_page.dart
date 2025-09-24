import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/client.dart';
import 'package:store_app/data/repostories/card_repository.dart';
import 'package:store_app/feature/card/managers/card_bloc.dart';
import 'package:store_app/feature/card/managers/card_event.dart';
import 'package:store_app/feature/card/managers/card_state.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
class MyCartPage extends StatelessWidget {
  const MyCartPage({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CartBloc(CartRepository(apiClient: context.read<ApiClient>()))
        ..add(LoadCart()),
      child: Scaffold(
        appBar: CustomAppBar(
          title:"My Cart",
          arrow: "assets/arrow.png",
          first: "assets/notifaction.png",
        ),
        body: BlocBuilder<CartBloc, CartState>(
          builder: (context, state) {
            if (state is CartLoading) return const Center(child: CircularProgressIndicator());
            if (state is CartError) return Center(child: Text(state.message));
            if (state is CartEmpty) return _buildEmpty();
            if (state is CartLoaded) return _buildCartList(context, state);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text("Your Cart Is Empty!"),
          Text("When you add products, they’ll appear here."),
        ],
      ),
    );
  }

  Widget _buildCartList(BuildContext context, CartLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: state.cart.items.length,
            itemBuilder: (context, index) {
              final item = state.cart.items[index];
              return ListTile(
                leading: Image.network(item.image, width: 56, height: 56, fit: BoxFit.cover),
                title: Text(item.title),
                subtitle: Text("Size: ${item.size}\n\$${item.price}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: item.quantity > 1
                          ? () => context.read<CartBloc>().add(DecreaseQuantity(item.id))
                          : null,
                    ),
                    Text("${item.quantity}", style: const TextStyle(fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => context.read<CartBloc>().add(IncreaseQuantity(item.id)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => context.read<CartBloc>().add(RemoveCartItem(item.id)),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _row("Sub-total", "\$${state.cart.subTotal}"),
              _row("VAT", "\$${state.cart.vat}"),
              _row("Shipping", "\$${state.cart.shippingFee}"),
              const Divider(),
              _row("Total", "\$${state.cart.total}", bold: true),
              const SizedBox(height: 12),
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: Theme.of(context).colorScheme.onSurface,  
    padding: const EdgeInsets.symmetric(vertical: 14),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  onPressed: () {},
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
       Text(
        "Go To Checkout ",
        style: TextStyle(fontSize: 15, color: Theme.of(context).colorScheme.onErrorContainer, ), 
      ),
      const SizedBox(width: 10),
      Image.asset(
        "assets/arrow2.png",
        width: 14,
        height: 14,
        color: Theme.of(context).colorScheme.onErrorContainer,
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

  Widget _row(String title, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}