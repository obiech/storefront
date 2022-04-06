import 'dart:io';

import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/features/home/blocs/categories_one/cubit/categories_one_cubit.dart';
import 'package:storefront_app/features/home/domain/repository/i_categories_one_repository.dart';

class MockICategoriesOneRepository extends Mock
    implements ICategoriesOneRepository {}

class MockCategoriesOneCubit extends Mock implements CategoriesOneCubit {}

class MockHttpClient extends Mock implements HttpClient {}
