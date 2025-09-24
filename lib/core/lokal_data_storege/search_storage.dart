import 'package:shared_preferences/shared_preferences.dart';

class SearchHistory {
  static const _key = 'recent_searches';
  static Future<void> add(String term) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_key) ?? [];
    if (!list.contains(term)) {
      list.insert(0, term);
      await prefs.setStringList(_key, list.take(10).toList()); 
    }
  }
  static Future<List<String>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_key) ?? [];
  }
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
