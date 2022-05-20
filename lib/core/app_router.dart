import 'package:auto_route/auto_route.dart';

import '../features/address/index.dart';
import '../features/auth/index.dart';
import '../features/cart_checkout/index.dart';
import '../features/child_categories/index.dart';
import '../features/home/index.dart';
import '../features/order/index.dart';
import '../features/product_search/index.dart';
import '../features/profile/index.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page|ScreenWrapper|Screen,Route',
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
    AutoRoute(page: RegistrationScreenWrapper),
    AutoRoute(page: LoginScreenWrapper),
    AutoRoute(page: OtpVerificationScreenWrapper),
    AutoRoute(page: PinInputScreenWrapper),

    /// Cart checkout
    AutoRoute(page: CartCheckoutScreenWrapper),
    AutoRoute(
      page: OrderStatusWrapperScreen,
      path: OrderStatusWrapperScreen.routeName,
      guards: [CheckOrderStatus],
    ),
    AutoRoute(page: OrderSuccessfulPage),
    AutoRoute(page: OrderFailurePage),
    AutoRoute(
      page: EmptyRouterPage,
      name: 'OrderRouter',
      children: [
        AutoRoute(page: OrderHistoryScreenWrapper),
        AutoRoute(page: OrderDetailsPage),
      ],
    ),

    /// Categories
    AutoRoute(page: ChildCategoriesPage),

    /// Address related
    AutoRoute(page: RequestLocationAccessPage),
    AutoRoute(page: SearchLocationPage),

    /// Profile related
    AutoRoute(page: EditProfilePage),
    AutoRoute(page: ChangeAddressPage),

    /// Global Search Navigation
    AutoRoute(
      page: SearchPage,
      name: 'GlobalSearchRoute',
    ),
  ],
)
class $AppRouter {}
