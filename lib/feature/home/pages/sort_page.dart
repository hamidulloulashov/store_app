import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/feature/home/managers/home/product_bloc.dart' show ProductBloc;
import 'package:store_app/feature/home/managers/home/product_event.dart' show LoadSortedProductsEvent;
class FilterBottomSheet extends StatefulWidget {
  final int? currentCategoryId;
  final int? currentSizeId;
  final String? currentTitle;
  final double? currentMinPrice;
  final double? currentMaxPrice;
  final String? currentOrderBy;
  const FilterBottomSheet({
    Key? key,
    this.currentCategoryId,
    this.currentSizeId,
    this.currentTitle,
    this.currentMinPrice,
    this.currentMaxPrice,
    this.currentOrderBy,
  }) : super(key: key);
  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}
class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late TextEditingController _titleController;
  int? _selectedCategoryId;
  int? _selectedSizeId;
  double _minPrice = 0;
  double _maxPrice = 1000;
  String _selectedOrderBy = 'relevance';

  final List<String> _sortOptions = ['relevance', 'price_low_high', 'price_high_low'];
  final List<String> _sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL'];
  final List<String> _categories = ['T-Shirt', 'Polo', 'Hoodie', 'Jacket'];
  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.currentTitle ?? '');
    _selectedCategoryId = widget.currentCategoryId;
    _selectedSizeId = widget.currentSizeId;
    _minPrice = widget.currentMinPrice ?? 0;
    _maxPrice = widget.currentMaxPrice ?? 1000;
    _selectedOrderBy = widget.currentOrderBy ?? 'relevance';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildSortSection(),
                  _buildPriceSection(),
                  _buildSizeSection(),
                  _buildCategorySection(),
                ],
              ),
            ),
          ),
          _buildApplyButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Filters', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
        ],
      ),
    );
  }

  Widget _buildSortSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Sort By', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),
            Row(
              children: _sortOptions.map((option) {
                final label = option == 'relevance'
                    ? 'Relevance'
                    : option == 'price_low_high'
                        ? 'Price: Low-High'
                        : 'Price: High-Low';
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: _selectedOrderBy == option,
                    onSelected: (_) => setState(() => _selectedOrderBy = option),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Price', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          Text('\$${_minPrice.toInt()} - \$${_maxPrice.toInt()}'),
          RangeSlider(
            values: RangeValues(_minPrice, _maxPrice),
            min: 0,
            max: 2000,
            divisions: 100,
            onChanged: (values) => setState(() {
              _minPrice = values.start;
              _maxPrice = values.end;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeSection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('Size', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
          DropdownButton<int>(
            value: _selectedSizeId,
            hint: const Text('Select'),
            items: List.generate(_sizes.length, (i) {
              return DropdownMenuItem(value: i, child: Text(_sizes[i]));
            }),
            onChanged: (value) => setState(() => _selectedSizeId = value),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 8,
        children: List.generate(_categories.length, (i) {
          return FilterChip(
            label: Text(_categories[i]),
            selected: _selectedCategoryId == i,
            onSelected: (selected) => setState(() => _selectedCategoryId = selected ? i : null),
          );
        }),
      ),
    );
  }
  Widget _buildApplyButton(BuildContext context) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(16),
    child: ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(vertical: 16),
      ),
      onPressed: () {
        context.read<ProductBloc>().add(
          LoadSortedProductsEvent(
            title: _titleController.text.isEmpty ? null : _titleController.text,
            categoryId: _selectedCategoryId,
            sizeId: _selectedSizeId,
            minPrice: _minPrice,
            maxPrice: _maxPrice,
            orderBy: _selectedOrderBy,
          ),
        );
        Navigator.pop(context);
      },
      child: const Text(
        'Apply Filters',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
    ),
  );
}

}
