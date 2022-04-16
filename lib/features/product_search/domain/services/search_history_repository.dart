import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storefront_app/core/core.dart';

import '../../config.dart';
import '../repository/i_search_history_repository.dart';

@LazySingleton(as: ISearchHistoryRepository)
class SearchHistoryRepository implements ISearchHistoryRepository {
  final SharedPreferences _preferences;

  SearchHistoryRepository(this._preferences);

  @override
  Future<List<String>> addSearchQuery(String query) async {
    var _queries = await getSearchQueries();

    final index = _queries.indexOf(query);
    if (index > -1) _queries.removeAt(index);
    _queries.insert(0, query);

    _queries = _queries.take(maxSearchHistory).toList();

    await _preferences.setStringList(
      PrefsKeys.kSearchQueries,
      _queries,
    );

    return _queries;
  }

  @override
  Future<List<String>> clearSearchQueries() async {
    await _preferences.remove(PrefsKeys.kSearchQueries);
    return [];
  }

  @override
  Future<List<String>> getSearchQueries() async {
    final _queries = _preferences.getStringList(PrefsKeys.kSearchQueries);
    return _queries ?? [];
  }

  @override
  Future<List<String>> removeSearchQuery(String query) async {
    final _queries = await getSearchQueries();

    if (_queries.contains(query)) {
      _queries.remove(query);
    }

    await _preferences.setStringList(PrefsKeys.kSearchQueries, _queries);
    return _queries;
  }
}
