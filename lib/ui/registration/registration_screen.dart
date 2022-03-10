import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/bloc/account_availability/account_availability.dart';
import 'package:storefront_app/constants/dropezy_text_styles.dart';
import 'package:storefront_app/ui/otp_verification/otp_verification.dart';
import 'package:storefront_app/ui/registration/phone_already_registered_bottom_sheet.dart';
import 'package:storefront_app/ui/widgets/dropezy_button.dart';
import 'package:storefront_app/ui/widgets/dropezy_scaffold.dart';
import 'package:storefront_app/ui/widgets/text_fields/phone_text_field.dart';
import 'package:storefront_app/ui/widgets/text_user_agreement.dart';
import 'package:storefront_app/utils/bottom_sheet_utils.dart';

class RegistrationScreen extends StatefulWidget {
  static const routeName = 'registration';
  static const keyVerifyPhoneNumberButton =
      '${routeName}_button_verifyPhoneNumber';

  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _ctrlPhoneNumber = TextEditingController();

  String get intlPhoneNumber => '+62${_ctrlPhoneNumber.text}';

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
                  key: const Key(RegistrationScreen.keyVerifyPhoneNumberButton),
                  label: 'Lanjutkan',
                  onPressed: _verifyPhoneNumber,
                  isLoading: state.status == AccountAvailabilityStatus.loading,
                ),
                const SizedBox(height: 24),
                TextUserAgreement.registration(),
              ],
            ),
          ),
        );
      },
      listener: (context, state) {
        switch (state.status as AccountAvailabilityStatus) {
          case AccountAvailabilityStatus.phoneIsAvailable:
            _navigateToOtpScreen();
            break;
          case AccountAvailabilityStatus.phoneAlreadyRegistered:
            final phone = '0${_ctrlPhoneNumber.text}';
            _showErrorPhoneAlreadyRegistered(phone);
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

  void _navigateToOtpScreen() {
    Navigator.of(context).pushNamed(
      OtpVerificationScreen.routeName,
      arguments: OtpVerificationScreenArgs(
        successAction: OtpSuccessAction.goToPinScreen,
        phoneNumberIntlFormat: intlPhoneNumber,
        registerAccountAfterSuccessfulOtp: true,
      ),
    );
  }

  void _showErrorPhoneAlreadyRegistered(String phoneNumber) {
    showDropezyBottomSheet(context, (_) {
      return PhoneAlreadyRegisteredBottomSheet(phoneNumber: phoneNumber);
    });
  }

  void _verifyPhoneNumber() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final phoneNumber = '+62${_ctrlPhoneNumber.text}';
    context
        .read<AccountAvailabilityCubit>()
        .checkPhoneNumberAvailability(phoneNumber);
  }
}
