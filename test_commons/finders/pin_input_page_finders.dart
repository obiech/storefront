import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/features/auth/pages/pin_input/pin_input_page.dart';

Finder finderPinInputPage = find.byType(PinInputPage);
Finder finderInputPin = find.byKey(const Key(PinInputPage.keyInputPin));
Finder finderInputConfirmPin =
    find.byKey(const Key(PinInputPage.keyInputConfirmPin));
