import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/home/domain/models/category_model.dart';
import 'package:storefront_app/features/home/domain/repository/i_parent_categories_repository.dart';

part 'parent_categories_state.dart';

@injectable
class ParentCategoriesCubit extends Cubit<ParentCategoriesState> {
  ParentCategoriesCubit(this.categoriesOneRepository)
      : super(InitialParentCategoriesState());

  final IParentCategoriesRepository categoriesOneRepository;

  Future<void> fetchCategoriesOne() async {
    emit(LoadingParentCategoriesState());

    try {
      final parentCategory =
          await categoriesOneRepository.getParentCategories();
      emit(LoadedParentCategoriesState(parentCategory));
    } catch (_) {
      emit(const ErrorLoadingParentCategoriesState('Error loading page'));
    }
  }
}
