import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/auth/pages/otp_verification/otp_input_field.dart';
import 'package:storefront_app/features/auth/pages/otp_verification/otp_verification_page.dart';

Finder finderOtpVerificationPage = find.byType(OtpVerificationPage);
Finder finderInputOtp = find.byType(OtpInputField);
Finder finderInputOtpTextField =
    find.byKey(const Key(OtpInputField.keyInputField));
