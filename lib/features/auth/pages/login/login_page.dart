import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';

import '../../../../di/injection.dart';
import '../../index.dart';
import 'phone_not_registered_bottom_sheet.dart';

part 'wrapper.dart';

class LoginPage extends StatefulWidget {
  /// setting [initialPhoneNumber] pre-fills [PhoneTextField] with
  /// [initialPhoneNumber].
  const LoginPage({
    Key? key,
    this.initialPhoneNumber,
  }) : super(key: key);

  static const keyInputPhoneNumber = 'LoginPage_inputPhoneNumber';
  static const keyVerifyPhoneNumberButton = 'LoginPage_buttonVerifyPhoneNumber';

  final String? initialPhoneNumber;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _ctrlPhoneNumber = TextEditingController();

  String get enteredPhoneNumber => _ctrlPhoneNumber.text;

  String get enteredPhoneNumberInIntlFormat =>
      trimAndTransformPhoneToIntlFormat(enteredPhoneNumber);

  String get enteredPhoneNumberInLocalFormat =>
      trimAndTransformPhoneToLocalFormat(enteredPhoneNumber);

  @override
  void initState() {
    super.initState();

    // Pre-fill phone number input
    _ctrlPhoneNumber.text = widget.initialPhoneNumber ?? '';
  }

  @override
  void dispose() {
    _ctrlPhoneNumber.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AccountAvailabilityCubit, AccountAvailabilityState>(
      builder: (context, state) {
        return DropezyScaffold.textTitle(
          title: 'Akun',
          child: Padding(
            padding: EdgeInsets.only(
              left: context.res.dimens.spacingMlarge,
              right: context.res.dimens.spacingMlarge,
              top: context.res.dimens.spacingMlarge,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Masuk',
                    style: DropezyTextStyles.title,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Masukkan nomor HP kamu yang sudah terdaftar',
                    style: DropezyTextStyles.caption1,
                  ),
                  const SizedBox(height: 24),
                  PhoneTextField(
                    key: const Key(LoginPage.keyInputPhoneNumber),
                    controller: _ctrlPhoneNumber,
                  ),
                  const SizedBox(height: 26.5),
                  DropezyButton.primary(
                    key: const Key(LoginPage.keyVerifyPhoneNumberButton),
                    label: 'Lanjutkan',
                    onPressed: _verifyPhoneNumber,
                    isLoading: state is AccountAvailabilityLoading,
                  ),
                  const SizedBox(height: 24),
                  TextUserAgreement.login(),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is PhoneIsAvailable) {
          _showDialogPhoneNotRegistered(enteredPhoneNumberInLocalFormat);
        } else if (state is PhoneIsAlreadyRegistered) {
          _goToOtpPage();
        } else if (state is AccountAvailabilityError) {
          showErrorBottomSheet(context, state.errorMsg);
        }
      },
    );
  }

  void _showDialogPhoneNotRegistered(String phoneNumber) {
    showDropezyBottomSheet(context, (_) {
      return PhoneNotRegisteredBottomSheet(phoneNumberLocalFormat: phoneNumber);
    });
  }

  void _goToOtpPage() {
    context.router.push(
      OtpVerificationRoute(
        phoneNumberIntlFormat: enteredPhoneNumberInIntlFormat,
        successAction: OtpSuccessAction.goToHomePage,
        timeoutInSeconds: AuthConfig.otpTimeoutInSeconds,
      ),
    );
  }

  void _verifyPhoneNumber() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context
        .read<AccountAvailabilityCubit>()
        .checkPhoneNumberAvailability(enteredPhoneNumberInIntlFormat);
  }
}
