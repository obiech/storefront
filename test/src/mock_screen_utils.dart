import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockingjay/mockingjay.dart';

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
Widget buildMockScreenWithBlocProvider<T extends BlocBase>(
    T bloc, Widget screen,
    [MockNavigator? navigator]) {
  if (navigator == null) {
    return BlocProvider<T>(
      create: (_) => bloc,
      child: MaterialApp(
        home: screen,
      ),
    );
  }

  return BlocProvider<T>(
    create: (_) => bloc,
    child: MaterialApp(
      home: MockNavigatorProvider(
        navigator: navigator,
        child: screen,
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
Widget buildMockScreenWithMultiBlocProvider(
    List<BlocProvider> providers, Widget screen,
    [MockNavigator? navigator]) {
  if (navigator == null) {
    return MultiBlocProvider(
      providers: providers,
      child: MaterialApp(
        home: screen,
      ),
    );
  }

  return MultiBlocProvider(
    providers: providers,
    child: MaterialApp(
      home: MockNavigatorProvider(
        navigator: navigator,
        child: screen,
      ),
    ),
  );
}
