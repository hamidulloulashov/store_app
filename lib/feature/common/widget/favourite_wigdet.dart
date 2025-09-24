import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/model/home/product_model.dart';
import '../managers/save_bloc.dart';
import '../managers/save_state.dart';

class FavouriteButton extends StatelessWidget {
  final ProductModel product;

  const FavouriteButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedBloc, SavedState>(
      builder: (context, state) {
        final isSaved = state.savedProduct.any((p) => p.id == product.id);

        return IconButton(
          icon: Icon(
            isSaved ? Icons.favorite : Icons.favorite_border,
            color: isSaved ? Colors.red : Colors.grey,
          ),
          onPressed: () {
            context.read<SavedBloc>().toggleSave(product);
          },
        );
      },
    );
  }
}
