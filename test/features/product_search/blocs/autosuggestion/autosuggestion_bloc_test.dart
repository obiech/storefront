import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/product_search/index.dart';

import '../../fixtures.dart';
import '../../mocks.dart';

void main() {
  late AutosuggestionBloc bloc;
  late IProductSearchRepository repository;

  setUp(() {
    repository = MockProductSearchRepository();
    bloc = AutosuggestionBloc(repository);
  });

  test('Default state should be [AutosuggestionInitial]', () {
    expect(bloc.state, isA<AutoSuggestionInitial>());
  });

  /// GetSuggestion
  const _consecutiveQueries = ['bea', 'bean', 'beans', 'green beans'];
  final List<String> _repoRequests = [];

  blocTest<AutosuggestionBloc, AutosuggestionState>(
    'GetSuggestions is buffered when called concurrently within a short period '
    'then called with a loading state emitted first '
    'and when successful, [LoadedAutosuggestions] is emitted with full list of suggestions.',
    setUp: () {
      /// arrange
      when(() => repository.getSearchSuggestions(any()))
          .thenAnswer((invocation) async {
        _repoRequests.add(invocation.positionalArguments[0].toString());
        return right(autosuggestions);
      });
    },
    build: () => bloc,
    act: (bloc) {
      for (final query in _consecutiveQueries) {
        bloc.add(GetSuggestions(query));
      }
    },
    expect: () {
      verify(() => repository.getSearchSuggestions(any())).called(1);

      /// Only the final query hits the server from all consecutive queries
      expect(_repoRequests.length, 1);
      expect(_repoRequests.first, _consecutiveQueries.last);

      return [
        isA<GettingAutosuggestions>(),
        const LoadedAutosuggestions(autosuggestions),
      ];
    },
  );

  blocTest<AutosuggestionBloc, AutosuggestionState>(
    'When an exception occurs during [GetSuggestions], an error is returned',
    setUp: () {
      /// arrange
      when(() => repository.getSearchSuggestions(any()))
          .thenAnswer((_) async => left(NetworkError(Exception().toFailure)));
    },
    build: () => bloc,
    act: (bloc) => bloc.add(GetSuggestions('beans')),
    expect: () => [
      isA<GettingAutosuggestions>(),
      isA<ErrorGettingAutosuggestions>(),
    ],
  );

  blocTest<AutosuggestionBloc, AutosuggestionState>(
    'When ResetSuggestions is called, the Bloc is reset to initial state',
    build: () => bloc,
    act: (bloc) => bloc.add(ResetSuggestions()),
    expect: () => [
      isA<AutoSuggestionInitial>(),
    ],
  );
}
