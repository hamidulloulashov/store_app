import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:store_app/core/lokal_data_storege/search_storage.dart';
import 'package:store_app/data/repostories/search_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchRepository repository;
  SearchBloc(this.repository) : super(const SearchState()) {
    on<SearchTextChanged>(_onTextChanged);
    on<ClearRecentSearches>(_onClearRecent);
    on<AddRecentSearch>(_onAddRecent);
    on<LoadRecentSearches>(_onLoadRecent);
  }

  Future<void> _onTextChanged(
      SearchTextChanged event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(state.copyWith(results: [], query: ''));
      return;
    }
    emit(state.copyWith(isLoading: true, query: query));
    try {
      final items = await repository.searchProducts(query);
      emit(state.copyWith(isLoading: false, results: items));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> _onClearRecent(
      ClearRecentSearches event, Emitter<SearchState> emit) async {
    await SearchHistory.clear();
    emit(state.copyWith(recent: []));
  }

  Future<void> _onAddRecent(
      AddRecentSearch event, Emitter<SearchState> emit) async {
    final newList = List<String>.from(state.recent);
    if (!newList.contains(event.term)) {
      newList.insert(0, event.term);
    }
    await SearchHistory.add(event.term); 
    emit(state.copyWith(recent: newList));
  }

  Future<void> _onLoadRecent(
      LoadRecentSearches event, Emitter<SearchState> emit) async {
    final saved = await SearchHistory.getAll();
    emit(state.copyWith(recent: saved));
  }
}
