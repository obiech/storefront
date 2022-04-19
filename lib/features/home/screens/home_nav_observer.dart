import 'package:auto_route/auto_route.dart';
import 'package:injectable/injectable.dart';
import 'package:storefront_app/features/home/blocs/home_nav/home_nav_cubit.dart';

/// In order to watch the status of the home page tabs
/// we have this [AutoRouteObserver] that works
/// hand in hand with the [HomeNavCubit] to provide
/// flawless events when the tab changes or is revisited
@singleton
class HomeNavObserver extends AutoRouteObserver {
  /// [Cubit] to handle home tabs navigation
  final HomeNavCubit cubit;

  HomeNavObserver(this.cubit);

  @override
  void didInitTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    cubit.routeChanged(HomeNavState(PageState.DID_INIT_TAB_ROUTE, route.name));
  }

  @override
  void didChangeTabRoute(TabPageRoute route, TabPageRoute previousRoute) {
    cubit
        .routeChanged(HomeNavState(PageState.DID_CHANGE_TAB_ROUTE, route.name));
  }
}
