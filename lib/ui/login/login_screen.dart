import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/account_availability/account_availability.dart';
import '../../constants/dropezy_text_styles.dart';
import '../../utils/bottom_sheet_utils.dart';
import '../../utils/phone_number_transformer.dart';
import '../otp_verification/otp_verification.dart';
import '../widgets/dropezy_button.dart';
import '../widgets/dropezy_scaffold.dart';
import '../widgets/text_fields/phone_text_field.dart';
import '../widgets/text_user_agreement.dart';
import 'phone_not_registered_bottom_sheet.dart';

class LoginScreen extends StatefulWidget {
  /// setting [initialPhoneNumber] pre-fills [PhoneTextField] with
  /// [initialPhoneNumber].
  const LoginScreen({
    Key? key,
    this.initialPhoneNumber,
  }) : super(key: key);

  static const routeName = 'login';
  static const keyInputPhoneNumber = 'LoginScreen_inputPhoneNumber';
  static const keyVerifyPhoneNumberButton =
      'LoginScreen_buttonVerifyPhoneNumber';

  final String? initialPhoneNumber;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
                  key: const Key(LoginScreen.keyInputPhoneNumber),
                  controller: _ctrlPhoneNumber,
                ),
                const SizedBox(height: 26.5),
                DropezyButton.primary(
                  key: const Key(LoginScreen.keyVerifyPhoneNumberButton),
                  label: 'Lanjutkan',
                  onPressed: _verifyPhoneNumber,
                  isLoading: state.status == AccountAvailabilityStatus.loading,
                ),
                const SizedBox(height: 24),
                TextUserAgreement.login(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        switch (state.status as AccountAvailabilityStatus) {
          case AccountAvailabilityStatus.phoneIsAvailable:
            _showDialogPhoneNotRegistered(enteredPhoneNumberInLocalFormat);
            break;
          case AccountAvailabilityStatus.phoneAlreadyRegistered:
            _goToOtpPage();
            break;
          case AccountAvailabilityStatus.error:
            final errMsg = state.errStatusCode != null
                ? '${state.errStatusCode}, ${state.errMsg}'
                : state.errMsg!;

            showErrorBottomSheet(context, errMsg);
            break;
          default:
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
    final args = OtpVerificationScreenArgs(
      phoneNumberIntlFormat: enteredPhoneNumberInIntlFormat,
      successAction: OtpSuccessAction.goToHomeScreen,
    );
    Navigator.of(context).pushNamed(
      OtpVerificationScreen.routeName,
      arguments: args,
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
