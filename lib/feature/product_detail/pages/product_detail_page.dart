import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/model/home_model.dart/product_model.dart';
import 'package:store_app/data/model/home_model.dart/review_model.dart';
import 'package:store_app/data/repostories/home_repostrory.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/common/widget/favourite_wigdet.dart';
import 'package:store_app/feature/product_detail/managers/review_event.dart' show FetchReviews;
import '../../../core/client.dart';
import '../../../data/repostories/rews_repository.dart';
import '../managers/review_bloc.dart';
import '../managers/review_state.dart';
import '../managers/product_detail_bloc.dart';
import '../managers/product_detail_event.dart';
import '../managers/product_detail_state.dart';

class ProductDetailWithReviewsPage extends StatelessWidget {
  final int productId;
  const ProductDetailWithReviewsPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ProductDetailBloc(context.read<ProductRepository>())
            ..add(LoadProductDetail(productId)),
        ),
        BlocProvider(
          create: (context) => ReviewBloc(
            ReviewRepository(apiClient: context.read<ApiClient>()),
          )..add(FetchReviews(productId)),
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
                child: Padding(
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
                      Text(
                        product.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(product.description),
                      const SizedBox(height: 12),
                      
                      const SizedBox(height: 12),
                      _buildProductRating(context, product),
                      const SizedBox(height: 20),
                      const Text("Choose size:"),
                      const SizedBox(height: 8),
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
                      Row(
  children: [
    Column(
      children: [
        Text("Price", ),
    Text(
      "\$${product.price.toStringAsFixed(0)}",
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 18,
      ),
    ),
      ],
    ),
    const SizedBox(width: 16),
    Expanded(
      child: ElevatedButton.icon(
        onPressed: () {},
        icon:  Icon(Icons.shopping_cart_outlined, color: Theme.of(context).colorScheme.onErrorContainer,),
        label:  Text("Add to Cart", style: TextStyle(color: Theme.of(context).colorScheme.onErrorContainer,),),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.inverseSurface,
          minimumSize: const Size(double.infinity, 48),
        ),
      ),
    ),
  ],
),

                      const SizedBox(height: 30),
                      const Divider(),
                      const SizedBox(height: 10),
                      Text(
                        "Reviews",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.headlineMedium?.color,
                        ),
                      ),
                      const SizedBox(height: 10),
                      BlocBuilder<ReviewBloc, ReviewState>(
                        builder: (context, reviewState) {
                          if (reviewState is ReviewInitial ||
                              reviewState is ReviewLoading) {
                            return const Center(child: CircularProgressIndicator());
                          } else if (reviewState is ReviewLoaded) {
                            if (reviewState.reviews.isEmpty) {
                              return Text(
                                'Hozircha hech qanday sharh yo\'q',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              );
                            }
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: reviewState.reviews.length,
                              itemBuilder: (context, index) {
                                final review = reviewState.reviews[index];
                                return _buildSingleReview(context, review);
                              },
                            );
                          } else if (reviewState is ReviewError) {
                            return Text(
                              'Xatolik: ${reviewState.message}',
                              style: TextStyle(
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
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
        GestureDetector(
          onTap: () {},
          child: Row(
            children: List.generate(5, (index) {
              return Icon(
                index < product.rating ? Icons.star : Icons.star_border,
                color: Colors.amber,
              );
            }),
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
            width: 1,
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
          Text(
            review.comment,
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context).textTheme.bodyLarge?.color,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                review.userFullName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '• ${_formatDate(review.created)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays < 1) {
      if (difference.inHours < 1) return '${difference.inMinutes} minutes ago';
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} weeks ago';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} months ago';
    } else {
      return '${(difference.inDays / 365).floor()} years ago';
    }
  }
}
