import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/shared_widgets/text_fields/phone_text_field.dart';
import 'package:storefront_app/features/auth/pages/login/login_page.dart';

Finder finderLoginPage = find.byType(LoginPage);
Finder finderInputPhoneNumber = find.byType(PhoneTextField);
Finder finderButtonVerifyPhone =
    find.byKey(const Key(LoginPage.keyVerifyPhoneNumberButton));
Finder finderLoadingIndicator = find.byType(CircularProgressIndicator);
