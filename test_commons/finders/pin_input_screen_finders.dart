import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/auth/screens/pin_input/pin_input_screen.dart';

Finder finderPinInputScreen = find.byType(PinInputScreen);
Finder finderInputPin = find.byKey(const Key(PinInputScreen.keyInputPin));
Finder finderInputConfirmPin =
    find.byKey(const Key(PinInputScreen.keyInputConfirmPin));
