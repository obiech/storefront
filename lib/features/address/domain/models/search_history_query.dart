import 'package:equatable/equatable.dart';

class SearchHistoryQuery extends Equatable {
  final String query;
  final DateTime createdAt;

  const SearchHistoryQuery({
    required this.query,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [query, createdAt];
}
