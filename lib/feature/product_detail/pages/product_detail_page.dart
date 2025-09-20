import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/model/home_model.dart/product_model.dart';
import 'package:store_app/data/repostories/home_repostrory.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/common/widget/favourite_wigdet.dart';
import '../../review/pages/review_page.dart';
import '../managers/product_detail_bloc.dart';
import '../managers/product_detail_event.dart';
import '../managers/product_detail_state.dart';

class ProductDetailPage extends StatelessWidget {
  final int productId;
  const ProductDetailPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductDetailBloc(context.read<ProductRepository>())
        ..add(LoadProductDetail(productId)),
      child: Scaffold(
        appBar: CustomAppBar(
          arrow: "assets/arrow.png",
          first: "assets/notifaction.png",
          title: "Details",
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, state) {
            if (state is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ProductDetailLoaded) {
              final product = state.product;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              product.productImages.isNotEmpty
                                  ? product.productImages.first.image
                                  : "",
                              height: 368,
                              width: 341,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 310, top: 15),
                          child: FavouriteButton(
                            product: ProductModel(
                              id: product.id,
                              title: product.title,
                              price: product.price,
                              image: product.productImages.isNotEmpty
                                  ? product.productImages.first.image
                                  : "",
                              categoryId: 0,
                              isLiked: false,
                              discount: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.title,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(product.description),
                          const SizedBox(height: 12),
                          Text(
                            "Price: \$${product.price.toStringAsFixed(0)}",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ReviewPage(productId: product.id),
                                    ),
                                  );
                                },
                                child: Row(
                                  children: List.generate(5, (index) {
                                    return Icon(
                                      index < product.rating
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                    );
                                  }),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text("(${product.reviewsCount} reviews)"),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Text("Choose size:"),
                          Wrap(
                            spacing: 8,
                            children: product.productSizes.map((size) {
                              return ChoiceChip(
                                label: Text(size.title),
                                selected: false,
                                onSelected: (_) {},
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.inverseSurface,
                              minimumSize: const Size(double.infinity, 48),
                            ),
                            child: Text(
                              "Add to Cart",
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onErrorContainer,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ProductDetailError) {
              return Center(child: Text("Error: ${state.message}"));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
