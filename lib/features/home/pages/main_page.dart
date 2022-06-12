import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import '../../address/index.dart';
import '../../cart_checkout/index.dart';
import '../../discovery/index.dart';
import '../index.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with AfterLayoutMixin {
  /// Specifies whetever to return [CartSummary]
  /// based on tabs active index
  ///
  /// When this tab active show [CartSummary]
  /// 0 = HomeRoute()
  /// 1 = SearchRoute()
  bool _isShowCartSummary(int index) => index == 0 || index == 1;

  @override
  void afterFirstLayout(BuildContext context) {
    // initialize blocs or cubits that need to be present on app start
    // but require auth token to be present.
    context.read<DeliveryAddressCubit>().fetchDeliveryAddresses();
    context.read<DiscoveryCubit>().loadStore();
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return AutoTabsRouter(
      navigatorObservers: () => [getIt<HomeNavObserver>()],
      routes: const [HomeRoute(), SearchRoute(), ProfileRoute()],
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
              currentIndex: tabsRouter.activeIndex,
              selectedLabelStyle: res.styles.caption3.copyWith(
                fontWeight: FontWeight.w600,
                height: 12.9 / 10,
              ),
              unselectedLabelStyle: res.styles.caption3.copyWith(
                fontWeight: FontWeight.w500,
                height: 12.9 / 10,
              ),
              unselectedItemColor: res.colors.grey5,
              onTap: (int index) => tabsRouter.setActiveIndex(index),
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
    );
  }
}
