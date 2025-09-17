import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import '../../../core/client.dart';
import '../../../data/model/home_model.dart/product_detail_model.dart';
import '../../../data/repostories/home_repostrory.dart';
import '../../common/widget/favourite_wigdet.dart';
import '../managers/product_cubit.dart';
import '../managers/product_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
  }

  void _listen() async {
    if (!_isListening) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
            _controller.text = _text;
            _controller.selection = TextSelection.fromPosition(
              TextPosition(offset: _controller.text.length),
            );
          });
          context.read<ProductCubit>().searchProducts(_text);
        });
      }
    } else {
      setState(() => _isListening = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(ProductRepositoryImpl(ApiClient()))
        ..loadCategories()
        ..loadProducts(),
      child: Scaffold(
        appBar: const CustomAppBar(title: "Discover"),
        body: BlocBuilder<ProductCubit, ProductState>(
          builder: (context, state) {
            if (state.status == ProductStatus.loading &&
                state.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ProductStatus.failure &&
                state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) {
                      context.read<ProductCubit>().searchProducts(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search for clothes...",
                      hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
                      prefixIcon: const Icon(Icons.search),
                      prefixIconColor:  Theme.of(context).colorScheme.onSecondary,
                      suffixIcon: IconButton(
                        icon: Icon(
                            _isListening ? Icons.mic : Icons.mic_none,
                            color: _isListening ? Colors.red : Colors.black),
                        onPressed: _listen,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.grey[100],
                    ),
                  ),
                ),

               SizedBox(
  height: 40,
  child: ListView.builder(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    itemCount: state.categories.length,
    itemBuilder: (context, index) {
      final cat = state.categories[index];
      final isSelected = state.selectedCategoryId == cat.id;

       return Container(
  margin: const EdgeInsets.only(right: 8),
  child: ChoiceChip(
    label: Text(
      cat.title,
      style: TextStyle(
        color: isSelected ? Colors.white : Colors.black, 
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
    ),
    selected: isSelected,
    onSelected: (_) {
      context.read<ProductCubit>().changeCategory(cat.id);
    },
    showCheckmark: false,
    selectedColor: Colors.black,
    backgroundColor: Colors.white, 
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
      side: BorderSide(
        color: isSelected ? Colors.black : Colors.grey.shade300, 
      ),
    ),
  ),
);

    },
  ),
),



                const SizedBox(height: 10),

                Expanded(
                  child: state.status == ProductStatus.loading
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
                          itemCount: state.products.length,
                          itemBuilder: (context, index) {
                            final product = state.products[index];
                            return _ProductCard(product: product);
                          },
                        ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: const BottomNavigatorNews(),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ProductCubit>();
    return GestureDetector(
      onTap: () {
      },
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
            FavouriteWidget(
              imageUrl: product.imageUrl,
              isLiked: product.isLiked,
              onLikeToggle: () {
                cubit.toggleLikeProduct(product.id);
              },
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                product.title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "\$${product.price.toStringAsFixed(0)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        ),
      ),
    );
  }
}

