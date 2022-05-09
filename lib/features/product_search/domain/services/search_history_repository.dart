import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';

import '../../index.dart';

@LazySingleton(as: ISearchHistoryRepository)
class SearchHistoryRepository implements ISearchHistoryRepository {
  /// Hive [Box] with key as search history query
  /// and value as the time the query was created
  final Box<DateTime> searchHistoryBox;

  /// List of all search events like deletion, insertion and update
  /// from Hive [Box] watch [Stream]
  late final List<SearchHistoryEvent> _queries;

  /// Listenable [Stream] with all changes and updates
  /// to the search history data
  late final BehaviorSubject<List<String>> _queryStream;

  /// [Stream] subscription to the Hive [Box] to be cancelled
  /// on dispose
  late final StreamSubscription<BoxEvent> _querySubscription;

  SearchHistoryRepository(this.searchHistoryBox) {
    _queries = searchHistoryBox.keys
        .map((key) => SearchHistoryEvent(key, searchHistoryBox.get(key)!))
        .toList();

    _queryStream = BehaviorSubject.seeded(_queries.getLatest);

    _querySubscription = searchHistoryBox.watch().listen(_handleBoxEvent);
  }

  /// Handle and transform box event
  void _handleBoxEvent(BoxEvent event) {
    if (event.deleted) {
      _queries.removeWhere((element) => element.query == event.key);
    } else {
      final historyEvent = SearchHistoryEvent(event.key, event.value!);

      final _index = _queries.indexWhere(
        (element) => element.query == event.key,
      );

      if (_index > -1) {
        _queries[_index] = historyEvent;
      } else {
        _queries.add(historyEvent);
      }
    }

    _queryStream.add(_queries.getLatest);
  }

  @override
  Future<void> addSearchQuery(String query) async {
    await searchHistoryBox.put(query, DateTime.now());
  }

  @override
  Future<void> clearSearchQueries() => searchHistoryBox.clear();

  @override
  Future<void> removeSearchQuery(String query) async {
    await searchHistoryBox.delete(query);
  }

  @disposeMethod
  @override
  void dispose() {
    _querySubscription.cancel();

    _cleanQueries().then((value) => searchHistoryBox.close());
  }

  /// Clean unused queries
  Future<void> _cleanQueries() async {
    for (final event in _queries.getExcess) {
      await searchHistoryBox.delete(event.query);
    }
  }

  @override
  Stream<List<String>> get observeHistoryStream => _queryStream;

  @visibleForTesting
  List<SearchHistoryEvent> get queries => _queries;
}
