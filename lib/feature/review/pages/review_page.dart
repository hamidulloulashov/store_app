import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/data/model/home_model.dart/review_model.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import '../../../core/client.dart';
import '../../../data/repostories/rews_repository.dart';
import '../managers/review_bloc.dart';
import '../managers/review_event.dart';
import '../managers/review_state.dart';

class ReviewPage extends StatelessWidget {
  final int productId;
  const ReviewPage({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReviewBloc(
        ReviewRepository(apiClient: context.read<ApiClient>()),
      )..add(FetchReviews(productId)),
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: CustomAppBar(
          title: "Reviews",
          arrow: "assets/arrow.png",
          first: "assets/notifaction.png",
        ),
        body: BlocBuilder<ReviewBloc, ReviewState>(
          builder: (context, state) {
            if (state is ReviewInitial || state is ReviewLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is ReviewLoaded) {
              if (state.reviews.isEmpty) {
                return Center(
                  child: Text(
                    'Hozircha hech qanday sharh yo\'q',
                    style: TextStyle(
                      fontSize: 16,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                );
              }
              return SingleChildScrollView(
                child: Column(
                  children: [
                    _buildRatingSummary(context, state.reviews),
                    const SizedBox(height: 20),
                    _buildRatingDistribution(context),
                    const SizedBox(height: 20),
                    _buildReviewsList(context, state.reviews),
                  ],
                ),
              );
            } else if (state is ReviewError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Xatolik: ${state.message}',
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        context.read<ReviewBloc>().add(FetchReviews(productId));
                      },
                      child: const Text('Qayta urinish'),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildRatingSummary(BuildContext context, List<ReviewModel> reviews) {
    double average = reviews.isNotEmpty
        ? reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length
        : 0;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            average.toStringAsFixed(1),
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).textTheme.headlineLarge?.color,
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index < average.round()
                          ? Colors.orange
                          : (isDark ? Colors.grey[600] : Colors.grey[300]),
                      size: 20,
                    );
                  }),
                ),
                const SizedBox(height: 4),
                Text(
                  '${reviews.length} Ratings',
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.color
                        ?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingDistribution(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          _buildRatingBar(context, 5, 0.8),
          _buildRatingBar(context, 4, 0.6),
          _buildRatingBar(context, 3, 0.3),
          _buildRatingBar(context, 2, 0.1),
          _buildRatingBar(context, 1, 0.05),
        ],
      ),
    );
  }

  Widget _buildRatingBar(BuildContext context, int stars, double percentage) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Row(
            children: List.generate(stars, (index) {
              return const Icon(
                Icons.star,
                color: Colors.orange,
                size: 16,
              );
            }),
          ),
          Row(
            children: List.generate(5 - stars, (index) {
              return Icon(
                Icons.star_border,
                color: isDark ? Colors.grey[600] : Colors.grey[400],
                size: 16,
              );
            }),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              height: 8,
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[800] : Colors.grey[200],
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: percentage,
                child: Container(
                  decoration: BoxDecoration(
                    color: isDark ? Colors.white : Colors.black,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewsList(BuildContext context, List<ReviewModel> reviews) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: reviews.map((review) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                bottom: BorderSide(
                  color: isDark ? Colors.grey[700]! : Colors.grey[200]!,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      color: index < review.rating.round()
                          ? Colors.orange
                          : (isDark ? Colors.grey[600] : Colors.grey[300]),
                      size: 16,
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  review.comment,
                  style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 12),
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
        }).toList(),
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
