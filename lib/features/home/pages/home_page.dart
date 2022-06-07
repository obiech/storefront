import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../di/injection.dart';
import '../../auth/domain/services/user_credentials_storage.dart';
import '../index.dart';

part 'keys.dart';

class HomePage extends StatelessWidget implements AutoRouteWrapper {
  static const routeName = 'home';

  const HomePage({Key? key}) : super(key: key);

  @override
  Widget wrappedRoute(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        /// Add another Bloc Provider here
        BlocProvider<ParentCategoriesCubit>(
          create: (_) =>
              getIt<ParentCategoriesCubit>()..fetchParentCategories(),
        ),
      ],
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Scaffold(
      appBar: HomeAppBar(
        userCredentialsStream: getIt<UserCredentialsStorage>().stream,
      ),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            children: [
              const SearchHeader(),
              Container(
                decoration: res.styles.bottomSheetStyle,
                padding: EdgeInsets.only(
                  left: res.dimens.spacingLarge,
                  right: res.dimens.spacingLarge,
                  bottom: 80,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    ParentCategoriesGrid(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
