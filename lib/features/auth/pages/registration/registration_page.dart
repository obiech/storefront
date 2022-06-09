import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../../di/injection.dart';
import '../../blocs/blocs.dart';
import '../otp_verification/otp_verification_page.dart';
import 'phone_already_registered_bottom_sheet.dart';

part 'wrapper.dart';

class RegistrationPage extends StatefulWidget {
  /// setting [initialPhoneNumber] pre-fills [PhoneTextField] with
  /// [initialPhoneNumber].
  const RegistrationPage({
    Key? key,
    this.initialPhoneNumber,
  }) : super(key: key);
  static const routeName = '/registration';
  static const keyVerifyPhoneNumberButton =
      '${routeName}_button_verifyPhoneNumber';

  final String? initialPhoneNumber;

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
                    'Daftar',
                    style: DropezyTextStyles.title,
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Yuk daftar pakai nomor HP kamu',
                    style: DropezyTextStyles.caption1,
                  ),
                  const SizedBox(height: 24),
                  PhoneTextField(controller: _ctrlPhoneNumber),
                  const SizedBox(height: 26.5),
                  DropezyButton.primary(
                    key: const Key(
                      RegistrationPage.keyVerifyPhoneNumberButton,
                    ),
                    label: 'Lanjutkan',
                    onPressed: _verifyPhoneNumber,
                    isLoading: state is AccountAvailabilityLoading,
                  ),
                  const SizedBox(height: 24),
                  TextUserAgreement.registration(),
                ],
              ),
            ),
          ),
        );
      },
      listener: (context, state) {
        if (state is PhoneIsAvailable) {
          _navigateToOtpPage();
        } else if (state is PhoneIsAlreadyRegistered) {
          _showErrorPhoneAlreadyRegistered(enteredPhoneNumberInLocalFormat);
        } else if (state is AccountAvailabilityError) {
          showErrorBottomSheet(context, state.errorMsg);
        }
      },
    );
  }

  void _navigateToOtpPage() {
    context.router.push(
      OtpVerificationRoute(
        phoneNumberIntlFormat: enteredPhoneNumberInIntlFormat,
        successAction: OtpSuccessAction.goToPinPage,
        timeoutInSeconds: AuthConfig.otpTimeoutInSeconds,
        isRegistration: true,
      ),
    );
  }

  void _showErrorPhoneAlreadyRegistered(String phoneNumber) {
    showDropezyBottomSheet(context, (_) {
      return PhoneAlreadyRegisteredBottomSheet(
        phoneNumberLocalFormat: phoneNumber,
      );
    });
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
