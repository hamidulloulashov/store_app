import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/feature/common/managers/save_state.dart';
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/home/widgets/product_card_widgete.dart';

import '../managers/save_bloc.dart';

class SavedPage extends StatelessWidget {
  const SavedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigatorNews(),
      appBar: CustomAppBar(
        title: "Saved Items",
        arrow: "assets/arrow.png",
        first: "assets/notifaction.png",
      ),
      body: BlocBuilder<SavedBloc, SavedState>(
        builder: (context, state) {
          if (state.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.savedProduct.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("assets/love.png"),
                  Text(
                    "No Saved Items!",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "You don't have any saved items.\n      Go to home and add some.",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inverseSurface,
                    ),
                  )
                ],
              ),
            );
          }

          if (state.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Error: ${state.errorMessage}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<SavedBloc>().fetchSavedProduct();
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 0.75,
            ),
            itemCount: state.savedProduct.length,
            itemBuilder: (context, index) {
              final product = state.savedProduct[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}
