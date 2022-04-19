import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/home/domain/models/categories_one.dart';
import 'package:storefront_app/features/home/index.dart';

import '../mocks.dart';
import 'home_screen_finder.dart';

void main() {
  late CategoriesOneCubit categoriesOneCubit;
  late HttpClient httpClient;

  const List<CategoryOneModel> mockCategoryOneList = [
    CategoryOneModel(
      id: '0',
      name: 'Sayuran',
      thumbnailUrl:
          'https://freepngimg.com/thumb/broccoli/12-broccoli-png-image-with-transparent-background-thumb.png',
      color: 'FEE5E4',
    ),
  ];

  const mockErrorMessage = 'Fake Error';

  setUp(() {
    categoriesOneCubit = MockCategoriesOneCubit();
    httpClient = MockHttpClient();
  });

  Future<void> pumpCategoriesOneScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider<CategoriesOneCubit>(
            create: (_) => categoriesOneCubit,
            child: const HomePage(),
          ),
        ),
      ),
    );
  }

  group('Categories One Screen Home', () {
    testWidgets(
        'display a loading indicator when state is [LoadingCategoriesOneState]',
        (tester) async {
      whenListen(
        categoriesOneCubit,
        Stream.fromIterable([LoadingCategoriesOneState()]),
      );

      when(() => categoriesOneCubit.close()).thenAnswer((_) async {});

      when(() => categoriesOneCubit.state)
          .thenAnswer((invocation) => LoadingCategoriesOneState());

      await pumpCategoriesOneScreen(tester);

      expect(HomeScreenFinders.loadingCategoryOneWidget, findsOneWidget);
    });

    testWidgets(
        'display list of CategoriesOne when state is [LoadedCategoriesOneState]',
        (tester) async {
      HttpOverrides.runZoned(
        // Run your tests.
        () async {
          whenListen(
            categoriesOneCubit,
            Stream.fromIterable(
              [const LoadedCategoriesOneState(mockCategoryOneList)],
            ),
          );

          when(() => categoriesOneCubit.close()).thenAnswer((_) async {});

          when(() => categoriesOneCubit.state).thenAnswer(
            (invocation) => const LoadedCategoriesOneState(
              mockCategoryOneList,
            ),
          );

          await pumpCategoriesOneScreen(tester);

          expect(HomeScreenFinders.gridCategoryOneWidget, findsOneWidget);
        },
        createHttpClient: (securityContext) => httpClient,
      );
    });

    testWidgets(
      'should display error message when state is [ErrorLoadingCategoriesOneState]',
      (tester) async {
        whenListen(
          categoriesOneCubit,
          Stream.fromIterable(
            [const ErrorLoadingCategoriesOneState(mockErrorMessage)],
          ),
        );

        when(() => categoriesOneCubit.close()).thenAnswer((_) async {});

        when(() => categoriesOneCubit.state).thenAnswer(
          (_) => const ErrorLoadingCategoriesOneState(mockErrorMessage),
        );

        await pumpCategoriesOneScreen(tester);

        expect(HomeScreenFinders.errorCategoryOneWidget, findsOneWidget);
        expect(find.text(mockErrorMessage), findsOneWidget);
      },
    );
  });
}
