import 'package:auto_route/auto_route.dart';
import 'package:storefront_app/core/core.dart';

class CheckAuthStatus extends AutoRouteGuard {
  final IPrefsRepository prefs;

  CheckAuthStatus(this.prefs);

  @override
  Future<void> onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) async {
    // Check if Onboarded & Authenticated
    final isOnboarded = await prefs.isOnBoarded();

    /// TODO - Add [FirebaseAuth] status check

    if (!isOnboarded) {
      router.replaceAll([const OnboardingRoute()]);
    } else {
      resolver.next();
    }
  }
}
