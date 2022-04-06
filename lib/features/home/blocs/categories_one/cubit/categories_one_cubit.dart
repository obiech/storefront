import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/home/domain/models/categories_one.dart';
import 'package:storefront_app/features/home/domain/repository/i_categories_one_repository.dart';

part 'categories_one_state.dart';

@injectable
class CategoriesOneCubit extends Cubit<CategoriesOneState> {
  CategoriesOneCubit(this.categoriesOneRepository)
      : super(InitialCategoriesOneState());

  final ICategoriesOneRepository categoriesOneRepository;

  Future<void> fetchCategoriesOne() async {
    emit(LoadingCategoriesOneState());

    try {
      final categoryOne = await categoriesOneRepository.getCategoryOnes();
      emit(LoadedCategoriesOneState(categoryOne));
    } catch (_) {
      emit(const ErrorLoadingCategoriesOneState('Error loading page'));
    }
  }
}
