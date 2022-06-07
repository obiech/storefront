import 'package:auto_route/auto_route.dart';
import 'package:storefront_app/core/core.dart';

class CheckAuthStatus extends AutoRouteGuard {
  final IPrefsRepository prefs;

  CheckAuthStatus(this.prefs);

  @override
  void onNavigation(
    NavigationResolver resolver,
    StackRouter router,
  ) {
    // Check if Onboarded & Authenticated
    final isOnboarded = prefs.isOnBoarded();

    /// TODO - Add [FirebaseAuth] status check

    if (!isOnboarded) {
      router.replaceAll([const OnboardingRoute()]);
    } else {
      resolver.next();
    }
  }
}
