import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

class MainScreen extends StatefulWidget {
  static const routeName = '/main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return AutoTabsRouter(
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
