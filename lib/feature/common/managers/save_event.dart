
import 'package:equatable/equatable.dart';
import 'package:store_app/data/model/home/product_model.dart' show ProductModel;

abstract class SavedEvent extends Equatable {
  const SavedEvent();

  @override
  List<Object?> get props => [];
}

class LoadSavedProducts extends SavedEvent {
  const LoadSavedProducts();
}

class ToggleSaveProduct extends SavedEvent {
  final ProductModel product;

  const ToggleSaveProduct({required this.product});

  @override
  List<Object?> get props => [product];
}

class ClearAllSavedProducts extends SavedEvent {
  const ClearAllSavedProducts();
}

class FetchSavedProducts extends SavedEvent {
  const FetchSavedProducts();
}
