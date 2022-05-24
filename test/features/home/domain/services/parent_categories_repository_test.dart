import 'package:dropezy_proto/v1/category/category.pbgrpc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/home/domain/services/parent_categories_repository.dart';

import '../../../../../test_commons/fixtures/category/category_pb_model.dart'
    as pb_categories;
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group('[ParentCategoriesRepository]', () {
    late CategoryServiceClient categoryServiceClient;
    late ParentCategoriesRepository repository;

    final mockPbCategory = pb_categories.categoryModel;

    setUp(() {
      registerFallbackValue(GetRequest());
      categoryServiceClient = MockCategoryServiceClient();
      repository = ParentCategoriesRepository(categoryServiceClient);
    });

    group('[getParentCategories()]', () {
      test('Retrieve a list of categories from [CategoryServiceClient]',
          () async {
        when(() => categoryServiceClient.get(any())).thenAnswer(
          (_) => MockResponseFuture.value(
            GetResponse(
              categories: mockPbCategory,
            ),
          ),
        );

        // memory cache should be initially empty
        expect(repository.parentCategoryModels, isEmpty);

        final result = await repository.getParentCategories();

        verify(() => categoryServiceClient.get(any())).called(1);

        result.fold(
          (l) => throw TestFailure(
            '[getParentCategories] should map to OrderModels on a '
            'successful request ',
          ),
          (r) {
            expect(r.length, mockPbCategory.length);
            // results should be stored in memory
            expect(
              repository.parentCategoryModels,
              isNotEmpty,
            );
            expect(r, repository.parentCategoryModels);
          },
        );
      });

      test(
        'should map Exceptions to Failure',
        () async {
          // ARRANGE
          when(() => categoryServiceClient.get(any())).thenAnswer(
            (_) => MockResponseFuture.error(
              GrpcError.notFound('Categories not found'),
            ),
          );

          // ACT
          final result = await repository.getParentCategories();

          // ASSERT
          verify(() => categoryServiceClient.get(any())).called(1);

          //TODO(valcons97): update to use latest Dartz extension
          result.fold(
            (l) {
              expect(l, isA<NetworkFailure>());
              expect(l.message, 'Categories not found');
            },
            (r) => throw TestFailure(
              '[getParentCategories] failed to map exception into Failure',
            ),
          );
        },
      );
    });
  });
}
