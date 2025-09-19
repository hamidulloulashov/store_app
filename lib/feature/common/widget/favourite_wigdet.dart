import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/utils/app_colors.dart';
import '../../../data/model/home_model.dart/product_model.dart';
import '../managers/favourite_cubit.dart';
import '../managers/favourite_state.dart';

class FavouriteButton extends StatelessWidget {
  final ProductModel product;

  const FavouriteButton({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SavedCubit, SavedState>(
      builder: (context, savedState) {
        final isLiked = savedState.savedProduct.any((p) => p.id == product.id);

        return Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColors.white),
          child: Center(
            child: IconButton(
  padding: EdgeInsets.zero, 
  constraints: const BoxConstraints(), 
  icon: Icon(
    isLiked ? Icons.favorite : Icons.favorite_border,
    color: Colors.red,
    size: 20, 
  ),
  onPressed: () {
    context.read<SavedCubit>().toggleSave(product);
  },
),

          ),
        );
      },
    );
  }
}

