import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/auth/screens/otp_verification/otp_input_field.dart';
import 'package:storefront_app/features/auth/screens/otp_verification/otp_verification_screen.dart';

Finder finderOtpVerificationScreen = find.byType(OtpVerificationScreen);
Finder finderInputOtp = find.byType(OtpInputField);
Finder finderInputOtpTextField =
    find.byKey(const Key(OtpInputField.keyInputField));
