import 'package:auto_route/auto_route.dart';

import '../features/auth/index.dart';
import '../features/cart_checkout/index.dart';
import '../features/child_categories/index.dart';
import '../features/home/index.dart';
import '../features/order/index.dart';
import '../features/product_search/index.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Screen|Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: MainScreen,
      initial: true,
      guards: [CheckAuthStatus],
      children: [
        AutoRoute(page: HomePage),
        AutoRoute(page: SearchPage),
        AutoRoute(page: ProfilePage),
        // TODO - Add remaining pages here
      ],
    ),
    AutoRoute(page: OnboardingScreen),
    AutoRoute(page: RegistrationScreen),
    AutoRoute(page: LoginScreen),
    AutoRoute(page: OtpVerificationScreenWrapper),
    AutoRoute(page: PinInputScreen),

    /// Cart checkout
    AutoRoute(page: CartCheckoutPage),
    AutoRoute(
      page: OrderStatusWrapperScreen,
      path: OrderStatusWrapperScreen.routeName,
      guards: [CheckOrderStatus],
    ),
    AutoRoute(page: OrderSuccessfulPage),
    AutoRoute(page: OrderFailurePage),
    AutoRoute(page: OrderHistoryScreen),
    AutoRoute(page: OrderDetailsPage),

    /// Categories
    AutoRoute(page: ChildCategoriesPage)
  ],
)
class $AppRouter {}
