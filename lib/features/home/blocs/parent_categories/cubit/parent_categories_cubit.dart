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

  Future<void> fetchParentCategories() async {
    emit(LoadingParentCategoriesState());

    final result = await categoriesOneRepository.getParentCategories();

    final state = result.fold(
      (failure) => ErrorLoadingParentCategoriesState(failure.message),
      (categories) => LoadedParentCategoriesState(categories),
    );

    emit(state);
  }
}
