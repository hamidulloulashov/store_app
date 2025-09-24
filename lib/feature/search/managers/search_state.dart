import 'package:equatable/equatable.dart';

class SearchState extends Equatable {
  final bool isLoading;
  final List<Map<String, dynamic>> results;
  final List<String> recent;
  final String error;
  final String query;

  const SearchState({
    this.isLoading = false,
    this.results = const [],
    this.recent = const [],
    this.error = '',
    this.query = '',
  });

  SearchState copyWith({
    bool? isLoading,
    List<Map<String, dynamic>>? results,
    List<String>? recent,
    String? error,
    String? query,
  }) {
    return SearchState(
      isLoading: isLoading ?? this.isLoading,
      results: results ?? this.results,
      recent: recent ?? this.recent,
      error: error ?? this.error,
      query: query ?? this.query,
    );
  }

  @override
  List<Object?> get props => [isLoading, results, recent, error, query];
}
