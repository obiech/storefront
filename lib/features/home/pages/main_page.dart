import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

import '../../cart_checkout/widgets/cart_summary/cart_summary.dart';
import '../index.dart';

class MainPage extends StatefulWidget {
  static const routeName = '/main';

  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  /// Specifies whetever to return [CartSummary]
  /// based on tabs active index
  ///
  /// When this tab active show [CartSummary]
  /// 0 = HomeRoute()
  /// 1 = SearchRoute()
  bool _isShowCartSummary(int index) => index == 0 || index == 1;

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
