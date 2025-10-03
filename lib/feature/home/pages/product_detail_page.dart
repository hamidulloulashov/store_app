import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:store_app/data/model/home/product_model.dart';
import 'package:store_app/data/model/home/review_model.dart';
import 'package:store_app/data/repostories/home_repostrory.dart';
import 'package:store_app/feature/card/managers/card_bloc.dart' show CartBloc;
import 'package:store_app/feature/card/managers/card_event.dart';
import 'package:store_app/feature/card/pages/my_cart_page.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/common/widget/favourite_wigdet.dart';
import 'package:store_app/feature/home/managers/product_detail/product_detail_bloc.dart';
import 'package:store_app/feature/home/managers/product_detail/product_detail_event.dart' show LoadProductDetail;
import 'package:store_app/feature/home/managers/product_detail/product_detail_state.dart' show ProductDetailState, ProductDetailLoading, ProductDetailLoaded, ProductDetailError;
import 'package:store_app/feature/home/managers/review/review_event.dart' show FetchReviews;
import '../../../core/client.dart';
import '../../../data/repostories/rews_repository.dart';
import '../managers/review/review_bloc.dart';
import '../managers/review/review_state.dart';
class ProductDetailWithReviewsPage extends StatefulWidget {
  final int productId;
  const ProductDetailWithReviewsPage({super.key, required this.productId});

  @override
  State<ProductDetailWithReviewsPage> createState() =>
      _ProductDetailWithReviewsPageState();
}

class _ProductDetailWithReviewsPageState
    extends State<ProductDetailWithReviewsPage> {
  int? selectedSizeId; 
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductDetailBloc(context.read<ProductRepository>())
            ..add(LoadProductDetail(widget.productId)),
        ),
        BlocProvider(
          create: (context) => ReviewBloc(
            ReviewRepository(apiClient: context.read<ApiClient>()),
          )..add(FetchReviews(widget.productId)),
        ),
      ],
      child: Scaffold(
        appBar: CustomAppBar(
          arrow: "assets/arrow.png",
          first: "assets/notifaction.png",
          title: "Details",
        ),
        body: BlocBuilder<ProductDetailBloc, ProductDetailState>(
          builder: (context, productState) {
            if (productState is ProductDetailLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (productState is ProductDetailLoaded) {
              final product = productState.product;

              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            product.productImages.isNotEmpty
                                ? product.productImages.first.image
                                : "",
                            height: 368,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 0,
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
                    const SizedBox(height: 16),

                    Text(product.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(product.description),
                    const SizedBox(height: 12),

                    _buildProductRating(context, product),
                    const SizedBox(height: 20),

                    const Text("Choose size:"),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children: product.productSizes.map((size) {
                        final isSelected = selectedSizeId == size.id;
                        return ChoiceChip(
                          label: Text(size.title),
                          selected: isSelected,
                          onSelected: (_) {
                            setState(() {
                              selectedSizeId = size.id;
                            });
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Price"),
                            Text(
                              "\$${product.price.toStringAsFixed(0)}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              if (selectedSizeId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text("Iltimos, razmerni tanlang.")),
                                );
                                return;
                              }

                              context.read<CartBloc>().add(
                                    AddCartItem(
                                      productId: product.id,
                                      quantity: 1,
                                      sizeId:selectedSizeId!,
                                    ),
                                  );

                           
                              GoRouter.of(context).push("/mycart");
                            },
                            icon: const Icon(Icons.shopping_cart_outlined),
                            label: const Text("Add to Cart"),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),
                    const Divider(),
                    const SizedBox(height: 10),

                    const Text("Reviews",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    BlocBuilder<ReviewBloc, ReviewState>(
                      builder: (context, state) {
                        if (state is ReviewInitial || state is ReviewLoading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        if (state is ReviewLoaded) {
                          if (state.reviews.isEmpty) {
                            return const Text('Hozircha sharh yo‘q');
                          }
                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.reviews.length,
                            itemBuilder: (context, i) =>
                                _buildSingleReview(context, state.reviews[i]),
                          );
                        }
                        if (state is ReviewError) {
                          return Text('Xatolik: ${state.message}');
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              );
            } else if (productState is ProductDetailError) {
              return Center(child: Text("Error: ${productState.message}"));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildProductRating(BuildContext context, dynamic product) {
    return Row(
      children: [
        Row(
          children: List.generate(
            5,
            (index) => Icon(
              index < product.rating ? Icons.star : Icons.star_border,
              color: Colors.amber,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text("(${product.reviewsCount} reviews)"),
      ],
    );
  }

  Widget _buildSingleReview(BuildContext context, ReviewModel review) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: isDark ? Colors.grey[700]! : Colors.grey[300]!,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: List.generate(5, (i) {
              return Icon(
                Icons.star,
                color: i < review.rating.round()
                    ? Colors.orange
                    : (isDark ? Colors.grey[600] : Colors.grey[300]),
                size: 16,
              );
            }),
          ),
          const SizedBox(height: 6),
          Text(review.comment),
        ],
      ),
    );
  }
}
