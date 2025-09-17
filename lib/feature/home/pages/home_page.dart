import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/client.dart';
import '../../../data/model/home_model.dart/product_detail_model.dart';
import '../../../data/repostories/home_repostrory.dart';
import '../managers/product_detail_view_model.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProductViewModel(ProductRepositoryImpl(ApiClient()))
        ..loadCategories()
        ..loadProducts(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Discover",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.notifications_none),
            ),
          ],
        ),
        body: Consumer<ProductViewModel>(
          builder: (context, vm, _) {
            if (vm.isLoading && vm.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (vm.errorMessage != null) {
              return Center(child: Text(vm.errorMessage!));
            }

            return Column(
              children: [
                // 🔍 Search bar
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search for clothes...",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.filter_list),
                        onPressed: () {},
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),

                // 🔘 Categories
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: vm.categories.length,
                    itemBuilder: (context, index) {
                      final cat = vm.categories[index];
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(cat.title),
                          selected: vm.selectedCategoryId == cat.id,
                          onSelected: (_) {
                            vm.changeCategory(cat.id);
                          },
                          selectedColor: Colors.black,
                          labelStyle: TextStyle(
                            color: vm.selectedCategoryId == cat.id
                                ? Colors.white
                                : Colors.black,
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 10),

                // 🛍 Products Grid
                Expanded(
                  child: vm.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: vm.products.length,
                          itemBuilder: (context, index) {
                            final product = vm.products[index];
                            return _ProductCard(product: product);
                          },
                        ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: 0,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
            BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border), label: "Saved"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;

  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProductViewModel>(context, listen: false);
    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                    ),
                    child: Center(
                      child: product.imageUrl.isNotEmpty
                          ? Image.network(product.imageUrl, fit: BoxFit.cover)
                          : const Icon(Icons.image,
                              size: 80, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () {
                        vm.toggleLikeProduct(product.id);
                      },
                      icon: Icon(
                        product.isLiked
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: product.isLiked ? Colors.red : Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 📌 Title
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title,
                style:
                    const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // 💲 Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "\$${product.price.toStringAsFixed(0)}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}
