import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../constants/dropezy_colors.dart';

/// Wrapper [Widget] for [PinCodeTextField] themed and purposed for entering
/// PIN, so text is by default obscured and length is enforced to 6.
///
/// To size this Widget, wrap it in a [SizedBox].
///
/// TODO (leovinsen): current implementation UX needs improvement. Approaches:
/// 1) Create our own Widget
/// 2) Use [PinCodeTextField] but use only 1 controller, and save text in
/// another variable. This way keyboard will not get dismissed when changing
/// from PIN to Confirm PIN
class PinInputField extends StatelessWidget {
  const PinInputField({
    Key? key,
    required this.controller,
    required this.focusNode,
    required this.onChanged,
    this.pinTheme,
    this.errorAnimationController,
  }) : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;
  final ValueChanged<String> onChanged;
  final PinTheme? pinTheme;
  final StreamController<ErrorAnimationType>? errorAnimationController;

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      controller: controller,
      autoDisposeControllers: false,
      appContext: context,
      pinTheme: defaultTheme,
      keyboardType: TextInputType.number,
      length: 6,
      focusNode: focusNode,
      obscureText: true,
      obscuringCharacter: ' ',
      showCursor: false,
      animationType: AnimationType.none,
      useHapticFeedback: true,
      autoFocus: false,
      enableActiveFill: true,
      errorAnimationController: errorAnimationController,
      errorAnimationDuration: 200,
      onChanged: onChanged,
    );
  }

  PinTheme get defaultTheme => PinTheme(
        activeColor: Colors.transparent,
        selectedColor: Colors.transparent,
        activeFillColor: DropezyColors.blue,
        selectedFillColor: DropezyColors.lightBlue,
        inactiveFillColor: DropezyColors.lightBlue,
        borderWidth: 1,
        inactiveColor: Colors.transparent,
        shape: PinCodeFieldShape.circle,
        fieldHeight: 16,
        fieldWidth: 16,
        errorBorderColor: DropezyColors.orange,
      );
}
