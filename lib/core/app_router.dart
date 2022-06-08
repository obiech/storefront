import 'package:auto_route/auto_route.dart';

import '../features/address/index.dart';
import '../features/auth/index.dart';
import '../features/cart_checkout/index.dart';
import '../features/child_categories/index.dart';
import '../features/help/index.dart';
import '../features/home/index.dart';
import '../features/order/index.dart';
import '../features/product/index.dart';
import '../features/product_search/index.dart';
import '../features/profile/index.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'PageWrapper|Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      page: MainPage,
      initial: true,
      guards: [CheckAuthStatus],
      children: [
        AutoRoute(page: HomePage),
        AutoRoute(page: SearchPage),
        AutoRoute(page: ProfilePage),
        // TODO - Add remaining pages here
      ],
    ),
    AutoRoute(page: OnboardingPage),
    AutoRoute(page: RegistrationPageWrapper),
    AutoRoute(page: LoginPageWrapper),
    AutoRoute(page: OtpVerificationPageWrapper),
    AutoRoute(page: PinInputPageWrapper),

    /// Cart checkout
    AutoRoute(page: CartCheckoutPageWrapper),
    AutoRoute(
      page: OrderStatusWrapperPage,
      path: OrderStatusWrapperPage.routeName,
      guards: [CheckOrderStatus],
    ),
    AutoRoute(page: OrderSuccessfulPage),
    AutoRoute(page: OrderFailurePage),

    AutoRoute(
      page: EmptyRouterPage,
      name: 'OrderRouter',
      children: [
        AutoRoute(page: OrderHistoryPageWrapper),
        AutoRoute(page: OrderDetailsPage),
      ],
    ),

    /// Categories
    AutoRoute(page: ChildCategoriesPage),

    /// Product
    AutoRoute(page: ProductDetailPage),

    /// Address related
    AutoRoute(page: RequestLocationAccessPage),
    AutoRoute(page: SearchLocationPageWrapper),
    AutoRoute(page: AddressDetailPageWrapper),
    AutoRoute(page: AddressPinpointPage),

    /// Profile related
    AutoRoute(page: EditProfilePageWrapper),
    AutoRoute(page: ChangeAddressPage),

    /// Help
    AutoRoute(page: HelpPage),

    /// Payment Instruction
    AutoRoute(page: PaymentInstructionsPage),

    /// Global Search Navigation
    AutoRoute(
      page: SearchPage,
      name: 'GlobalSearchRoute',
    ),
  ],
)
class $AppRouter {}
