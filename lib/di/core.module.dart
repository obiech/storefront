import 'package:injectable/injectable.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/auth/domain/domain.dart';

import '../features/cart_checkout/index.dart';

@module
abstract class CoreModule {
  AppRouter router(IPrefsRepository prefs) {
    return AppRouter(
      checkOrderStatus: CheckOrderStatus(),
      checkAuthStatus: CheckAuthStatus(prefs),
    );
  }
}
