import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:store_app/feature/common/widget/bottom_navigator.dart';
import 'package:store_app/feature/common/widget/custom_appbar.dart';
import 'package:store_app/feature/home/widgets/product_card_widgete.dart';
import '../../../core/client.dart';
import '../../../data/model/home_model.dart/product_model.dart';
import '../../../data/repostories/home_repostrory.dart';
import '../managers/product_bloc.dart';
import '../managers/product_event.dart';
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
  List<ProductModel> _allProducts = [];

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
          context.read<ProductBloc>().add(SearchProductsEvent(_text, _allProducts));
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
      create: (_) => ProductBloc(ProductRepositoryImpl(ApiClient()))
        ..add(LoadCategoriesEvent())
        ..add(LoadProductsEvent()),
      child: Scaffold(
        appBar: const CustomAppBar(
          title: "Discover",
          first: "assets/notifaction.png",
        ),
        body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, state) {
            if (state.products.isNotEmpty && _allProducts.isEmpty) {
              _allProducts = List.from(state.products);
            }

            if (state.status == ProductStatus.loading && state.products.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.status == ProductStatus.failure && state.errorMessage != null) {
              return Center(child: Text(state.errorMessage!));
            }

            return Column(
              children: [
                _buildSearchField(),
                _buildCategories(state),
                const SizedBox(height: 10),
                _buildProductsGrid(state),
              ],
            );
          },
        ),
        bottomNavigationBar: const BottomNavigatorNews(),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: TextField(
        controller: _controller,
        onChanged: (value) {
          context.read<ProductBloc>().add(SearchProductsEvent(value, _allProducts));
        },
        decoration: InputDecoration(
          hintText: "Search for clothes...",
          hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
          prefixIcon: const Icon(Icons.search),
          prefixIconColor: Theme.of(context).colorScheme.onSecondary,
          suffixIcon: IconButton(
            icon: Icon(
              _isListening ? Icons.mic : Icons.mic_none,
              color: _isListening ? Colors.red : Colors.black,
            ),
            onPressed: _listen,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey[100],
        ),
      ),
    );
  }

  Widget _buildCategories(ProductState state) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 10),
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
                _controller.clear();
                context
                    .read<ProductBloc>()
                    .add(ChangeCategoryEvent(cat.id, _allProducts));
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
    );
  }

  Widget _buildProductsGrid(ProductState state) {
    return Expanded(
      child: state.status == ProductStatus.loading
          ? const Center(child: CircularProgressIndicator())
          : state.products.isEmpty
              ? const Center(
                  child: Text(
                    "Hech qanday mahsulot topilmadi",
                    style: TextStyle(fontSize: 16),
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 10,
                    childAspectRatio: 0.70,
                  ),
                  itemCount: state.products.length,
                  itemBuilder: (context, index) {
                    final product = state.products[index];
                    return ProductCard(product: product);
                  },
                ),
    );
  }
}
