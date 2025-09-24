import 'package:equatable/equatable.dart';

import '../../../data/model/home/product_model.dart';

class SavedState extends Equatable {
  final String? errorMessage;
  final bool loading;
  final List<ProductModel> savedProduct;

  const SavedState({
    required this.errorMessage,
    required this.loading,
    required this.savedProduct,
  });

  factory SavedState.initial() => SavedState(
    errorMessage: null,
    loading: true,
    savedProduct: [],
  );

  SavedState copyWith({
    String? errorMessage,
    bool? loading,
    List<ProductModel>? savedProduct,
  }) => SavedState(
    errorMessage: errorMessage ?? this.errorMessage,
    loading: loading ?? this.loading,
    savedProduct: savedProduct ?? this.savedProduct,
  );

  @override
  List<Object?> get props => [errorMessage, loading, savedProduct];
}
