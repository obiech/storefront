import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/home/domain/models/category_model.dart';
import 'package:storefront_app/features/home/domain/repository/i_parent_categories_repository.dart';

import '../../../../core/core.dart';
import '../../../../di/di_environment.dart';
import '../../../child_categories/domain/services/dummy_child_category_repository.dart';

/// Dummy [IParentCategoriesRepository].
///
/// Returns data for development purposes, hardcoded in class definition.
/// WARNING: DO NOT use in production!

@LazySingleton(as: IParentCategoriesRepository, env: [DiEnvironment.dummy])
class DummyParentCategoryRepository extends IParentCategoriesRepository {
  static const parentCategoryList = [
    ParentCategoryModel(
      id: '0',
      name: 'Sayuran',
      thumbnailUrl:
          'https://freepngimg.com/thumb/broccoli/12-broccoli-png-image-with-transparent-background-thumb.png',
      color: 'FEE5E4',
      childCategories: DummyChildCategoryRepository.childCategoryVeggies,
    ),
    ParentCategoryModel(
      id: '1',
      name: 'Buah',
      thumbnailUrl:
          'https://freepngimg.com/thumb/apple/88-png-apple-image-clipart-transparent-png-apple-thumb.png',
      color: 'DFEEFF',
      childCategories: DummyChildCategoryRepository.childCategoryFruits,
    ),
    ParentCategoryModel(
      id: '2',
      name: 'Roti, telur, susu',
      thumbnailUrl:
          'https://www.seekpng.com/png/full/27-271499_hormone-free-milk-milk-and-eggs-png.png',
      color: 'FFF1E1',
      childCategories: DummyChildCategoryRepository.childCategoryBreadMilk,
    ),
    ParentCategoryModel(
      id: '3',
      name: 'Daging dan Ikan',
      thumbnailUrl:
          'https://freepngimg.com/thumb/meat/34425-6-beef-meat-transparent-image-thumb.png',
      color: 'E3E0FB',
      childCategories: DummyChildCategoryRepository.childCategoryMeat,
    ),
    ParentCategoryModel(
      id: '4',
      name: 'Camilan',
      thumbnailUrl:
          'https://www.seekpng.com/png/full/292-2927506_cheetos-puffs-honey-bbq-cheese-flavored-snacks-reviews.png',
      color: 'E3E0FB',
      childCategories: DummyChildCategoryRepository.childCategoryVeggies,
    ),
    ParentCategoryModel(
      id: '5',
      name: 'Dapur & Bahan-Bahannya',
      thumbnailUrl:
          'https://www.seekpng.com/png/full/366-3665626_sunflower-oil-best-for-versalite-cooking-vitamin-e.png',
      color: 'FFF1E1',
      childCategories: DummyChildCategoryRepository.childCategoryVeggies,
    ),
    ParentCategoryModel(
      id: '6',
      name: 'Minuman',
      thumbnailUrl:
          'https://www.seekpng.com/png/full/273-2739600_learn-how-to-get-into-beverage-distribution-for.png',
      color: 'FEE5E4',
      childCategories: DummyChildCategoryRepository.childCategoryVeggies,
    ),
    ParentCategoryModel(
      id: '7',
      name: 'Bayi dan Ibu',
      thumbnailUrl:
          'https://www.seekpng.com/png/full/624-6245588_pants-diaper-medium-merries-tape-diaper-nappy-pants.png',
      color: 'DFEEFF',
      childCategories: DummyChildCategoryRepository.childCategoryVeggies,
    ),
    ParentCategoryModel(
      id: '8',
      name: 'Perawatan Pribadi dan Kesehatan',
      thumbnailUrl:
          'https://www.seekpng.com/png/full/272-2725150_fight-those-germs-lifebuoy-total-10-handwash.png',
      color: 'DFEEFF',
      childCategories: DummyChildCategoryRepository.childCategoryVeggies,
    ),
    ParentCategoryModel(
      id: '10',
      name: 'Kebersihan Rumah',
      thumbnailUrl:
          'https://www.pngitem.com/pimgs/b/121-1217601_clorox-bleach-png.png',
      color: 'FEE5E4',
      childCategories: DummyChildCategoryRepository.childCategoryVeggies,
    ),
    ParentCategoryModel(
      id: '11',
      name: 'Kebutuhan Lainnya',
      thumbnailUrl:
          'https://www.pngitem.com/pimgs/b/146-1469376_cardboard-box-png.png',
      color: 'FFF1E1',
      childCategories: DummyChildCategoryRepository.childCategoryVeggies,
    ),
  ];

  @override
  RepoResult<List<ParentCategoryModel>> getParentCategories() async {
    await Future.delayed(const Duration(seconds: 1));
    return right(parentCategoryList);
  }
}
