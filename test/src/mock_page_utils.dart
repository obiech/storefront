import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Use this to create a [MaterialApp] instance wrapped with a
/// [BlocProvider] with a minimal set of external dependencies
///
///
/// When [navigator] is not null, navigation will be mocked
/// and route pushes will not create a new [Widget].
///
/// In contrast, when it is null, route pushes will work normally
/// and will create a new [Widget]. Pass a [navigator] when trying to test
/// [SnackBar], [Dialog] or [BottomSheet].
Widget buildMockPageWithBlocProviderAndAutoRoute<T extends BlocBase>(
  T bloc,
  Widget page, [
  StackRouter? navigator,
]) {
  if (navigator == null) {
    return BlocProvider<T>(
      create: (_) => bloc,
      child: MaterialApp(
        home: page,
      ),
    );
  }

  return BlocProvider<T>(
    create: (_) => bloc,
    child: MaterialApp(
      home: StackRouterScope(
        controller: navigator,
        stateHash: 0,
        child: page,
      ),
    ),
  );
}

/// Use this to create a [MaterialApp] instance wrapped with a
/// [MultiBlocProvider] with a minimal set of external dependencies.
///
/// When [navigator] is not null, navigation will be mocked
/// and route pushes will not create a new [Widget].
///
/// In contrast, when it is null, route pushes will work normally
/// and will create a new [Widget]. Pass a [navigator] when trying to test
/// [SnackBar], [Dialog] or [BottomSheet].
Widget buildMockPageWithMultiBlocProviderAndAutoRoute(
  List<BlocProvider> providers,
  Widget page, [
  StackRouter? navigator,
]) {
  if (navigator == null) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        home: page,
      ),
    );
  }

  return MultiBlocProvider(
    providers: providers,
    child: MaterialApp(
      home: StackRouterScope(
        controller: navigator,
        stateHash: 0,
        child: page,
      ),
    ),
  );
}
