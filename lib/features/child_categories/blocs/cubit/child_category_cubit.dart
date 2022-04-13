import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../home/index.dart';

part 'child_category_state.dart';

@injectable
class ChildCategoryCubit extends Cubit<ChildCategoryState> {
  ChildCategoryCubit(@factoryParam this.childCategoriesList)
      : super(
          ChildCategoryState(
            childCategoriesList,
            childCategoriesList[0],
          ),
        );

  late List<ChildCategoryModel> childCategoriesList;

  void setActiveChildCategory(ChildCategoryModel activeChildCategory) {
    emit(
      ChildCategoryState(
        state.childCategoriesList,
        activeChildCategory,
      ),
    );
  }
}
