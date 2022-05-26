import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/shared_widgets/text_fields/phone_text_field.dart';
import 'package:storefront_app/features/auth/pages/registration/registration_page.dart';

Finder finderRegistrationPage = find.byType(RegistrationPage);
Finder finderInputPhoneNumber = find.byType(PhoneTextField);
Finder finderButtonVerifyPhone =
    find.byKey(const Key(RegistrationPage.keyVerifyPhoneNumberButton));
Finder finderLoadingIndicator = find.byType(CircularProgressIndicator);
