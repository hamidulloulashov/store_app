import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();
  @override
  List<Object?> get props => [];
}

class SearchTextChanged extends SearchEvent {
  final String query;
  const SearchTextChanged(this.query);
  @override
  List<Object?> get props => [query];
}

class ClearRecentSearches extends SearchEvent {
  const ClearRecentSearches();
}

class AddRecentSearch extends SearchEvent {
  final String term;
  const AddRecentSearch(this.term);
  @override
  List<Object?> get props => [term];
}

class LoadRecentSearches extends SearchEvent {
  const LoadRecentSearches();
}
