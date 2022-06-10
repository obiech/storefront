import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mocktail/mocktail.dart';
import 'package:storefront_app/core/core.dart';

import '../../test/src/mock_customer_service_client.dart';

void setUpLocaleInjection() {
  final mockPrefs = MockIPrefsRepository();
  final getIt = GetIt.instance;
  if (!getIt.isRegistered<IPrefsRepository>()) {
    when(() => mockPrefs.getDeviceLocale())
        .thenReturn(const Locale('en', 'EN'));
    getIt.registerSingleton<IPrefsRepository>(mockPrefs);
  }
}
