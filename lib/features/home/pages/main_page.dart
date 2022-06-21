import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../../../di/injection.dart';
import '../../address/index.dart';
import '../../cart_checkout/index.dart';
import '../../discovery/index.dart';
import '../../profile/index.dart';
import '../index.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  const MainPage({Key? key}) : super(key: key);

  static void refreshPage(BuildContext context) {
    context.findAncestorStateOfType<_MainPageState>()?.refreshPage();
  }

  static void setToSearch(BuildContext context) {
    context
        .findAncestorStateOfType<_MainPageState>()
        ?.setActiveIndex(BottomNav.SEARCH.index);
  }

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AfterLayoutMixin {
  int activeIndex = 0;
  Key key = UniqueKey();

  /// Specifies whetever to return [CartSummary]
  /// based on tabs active index
  ///
  /// When this tab active show [CartSummary]
  /// 0 = HomeRoute()
  /// 1 = SearchRoute()
  bool _isShowCartSummary(int index) => index == 0 || index == 1;

  /// Rebuild the main page with different key
  /// and make it lose whole state
  void refreshPage() {
    setState(() {
      activeIndex = BottomNav.PROFILE.index;
      key = UniqueKey();
    });
  }

  void setActiveIndex(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  void afterFirstLayout(BuildContext context) {
    // initialize blocs or cubits that need to be present on app start
    // but require auth token to be present.
    context.read<DeliveryAddressCubit>().fetchDeliveryAddresses();
    // TODO(obella): Handle store retrieval failure
    getIt<IStoreRepository>().getStore();
    context.read<ProfileCubit>().fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return KeyedSubtree(
      key: key,
      child: AutoTabsRouter.declarative(
        activeIndex: activeIndex,
        navigatorObservers: () => [getIt<HomeNavObserver>()],
        routes: [
          const HomeRoute(),
          SearchRoute(isShowCartSummary: false),
          const ProfileRoute()
        ],
        builder: (context, child, animation) {
          final tabsRouter = AutoTabsRouter.of(context);

          return Scaffold(
            body: FadeTransition(
              opacity: animation,
              // the passed child is techinaclly our animated selected-tab page
              child: child,
            ),
            extendBody: true,
            floatingActionButton: _isShowCartSummary(tabsRouter.activeIndex)
                ? const CartSummary()
                : null,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            bottomNavigationBar: Container(
              decoration: res.styles.bottomSheetStyle,
              child: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                iconSize: 20,
                currentIndex: activeIndex,
                selectedLabelStyle: res.styles.caption3.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 12.9 / 10,
                ),
                unselectedLabelStyle: res.styles.caption3.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 12.9 / 10,
                ),
                unselectedItemColor: res.colors.grey5,
                onTap: setActiveIndex,
                items: [
                  BottomNavigationBarItem(
                    icon: const Icon(DropezyIcons.home),
                    activeIcon: const Icon(DropezyIcons.home_filled),
                    label: res.strings.home,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(DropezyIcons.search),
                    label: res.strings.search,
                  ),
                  BottomNavigationBarItem(
                    icon: const Icon(DropezyIcons.profile),
                    label: res.strings.profile,
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
