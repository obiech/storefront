import 'package:dropezy_proto/v1/category/category.pbgrpc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grpc/grpc_or_grpcweb.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/home/domain/services/parent_categories_repository.dart';
import 'package:storefront_app/features/home/index.dart';

import '../../../../../test_commons/fixtures/category/category_pb_model.dart'
    as pb_categories;
import '../../../../src/mock_response_future.dart';
import '../../mocks.dart';

void main() {
  group('[ParentCategoriesRepository]', () {
    late CategoryServiceClient categoryServiceClient;
    late ParentCategoriesRepository repository;

    final mockPbCategory = pb_categories.categoryModel;
    final List<ParentCategoryModel> expectedParentModels = [];

    setUpAll(() {
      dotenv.testLoad(fileInput: '''ASSETS_URL=https://test.dropezy.com''');
      registerFallbackValue(GetRequest());
      categoryServiceClient = MockCategoryServiceClient();
      repository = ParentCategoriesRepository(categoryServiceClient);
      expectedParentModels
          .addAll(mockPbCategory.map(ParentCategoryModel.fromPb).toList());
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

        final result = await repository.getParentCategories();

        verify(() => categoryServiceClient.get(any())).called(1);

        final categories = result.getRight();

        expect(categories.length, expectedParentModels.length);
        expect(categories, expectedParentModels);
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

          final failure = result.getLeft();
          expect(failure, isA<NetworkFailure>());
          expect(failure.message, 'Categories not found');
        },
      );
    });
  });
}
