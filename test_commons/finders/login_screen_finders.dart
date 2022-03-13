import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/shared_widgets/text_fields/phone_text_field.dart';
import 'package:storefront_app/features/auth/screens/login/login_screen.dart';

Finder finderLoginScreen = find.byType(LoginScreen);
Finder finderInputPhoneNumber = find.byType(PhoneTextField);
Finder finderButtonVerifyPhone =
    find.byKey(const Key(LoginScreen.keyVerifyPhoneNumberButton));
Finder finderLoadingIndicator = find.byType(CircularProgressIndicator);
