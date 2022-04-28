import 'dart:convert';

import 'package:dropezy_proto/v1/search/search.pb.dart';

import '../fixture_reader.dart';

SearchInventoryResponse get searchInventory {
  final json = jsonDecode(fixture('product/inventory.json')) as List<dynamic>;
  final List<SearchInventoryResult> results = json
      .map(
        (e) => SearchInventoryResult.fromJson(
          jsonEncode(e as Map<String, dynamic>),
        ),
      )
      .toList();

  return SearchInventoryResponse(results: results);
}
