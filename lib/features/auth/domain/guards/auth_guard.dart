import 'package:auto_route/auto_route.dart';
import 'package:storefront_app/core/core.dart';

import '../services/auth_service.dart';

class CheckAuthStatus extends AutoRouteGuard {
  final AuthService authService;

  CheckAuthStatus(this.authService);

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    final token = await authService.getToken();

    if (token == null) {
      router.replaceAll([OnboardingRoute()]);
    } else {
      resolver.next();
    }
  }
}
