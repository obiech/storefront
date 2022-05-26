import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../registration/registration_page.dart';

/// [DropezyBottomSheet] for notifying user that their phone number
/// is not found in Dropezy database, and they should instead register
/// their phone number.
///
/// When user clicks on the button:
/// 1) This [BottomSheet] will be dismissed.
/// 2) App will navigate to [RegistrationPage] with [phoneNumberLocalFormat] without
/// leading zero as pre-filled phone number.
class PhoneNotRegisteredBottomSheet extends StatelessWidget {
  /// [phoneNumberLocalFormat] will be displayed in the error message.
  PhoneNotRegisteredBottomSheet({
    Key? key,
    required this.phoneNumberLocalFormat,
  })  : assert(phoneNumberLocalFormat.startsWith('0')),
        super(key: key);

  final String phoneNumberLocalFormat;

  @override
  Widget build(BuildContext context) {
    return DropezyBottomSheet.singleButton(
      svgIconPath: AssetsPath.icPhoneVerification,
      content: _content(phoneNumberLocalFormat),
      buttonLabel: 'Daftar Sekarang',
      buttonOnPressed: () {
        // Pops the BottomSheet
        Navigator.of(context).pop();

        // Pop current route and push RegistrationPage
        context.router.replaceAll([
          RegistrationRoute(
            initialPhoneNumber: phoneNumberLocalFormat.substring(1),
          )
        ]);
      },
    );
  }

  Widget _content(String phoneNumber) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sepertinya kamu masih baru',
            style: DropezyTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text.rich(
            TextSpan(
              text: 'Nomor HP ',
              children: [
                TextSpan(
                  text: phoneNumber,
                  style: DropezyTextStyles.caption2
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                const TextSpan(
                  text: ' belum terdaftar di Dropezy. \nYuk, daftarin dulu!',
                ),
              ],
            ),
            style: DropezyTextStyles.caption2.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          )
        ],
      );
}
