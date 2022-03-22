import 'package:flutter/material.dart';
import 'package:storefront_app/constants/assets_path.dart';
import 'package:storefront_app/constants/dropezy_text_styles.dart';
import 'package:storefront_app/ui/login/login_screen.dart';
import 'package:storefront_app/ui/widgets/bottom_sheet/dropezy_bottom_sheet.dart';

/// [DropezyBottomSheet] for notifying user that their phone number
/// has already been registered in Dropezy database.
///
/// When user clicks on the button:
/// 1) This [BottomSheet] will be dismissed.
/// 2) App will navigate to [LoginScreen] with [phoneNumberLocalFormat] without
/// leading zero as pre-filled phone number.
class PhoneAlreadyRegisteredBottomSheet extends StatelessWidget {
  /// [phoneNumberLocalFormat] will be displayed in the error message.
  PhoneAlreadyRegisteredBottomSheet({
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
      buttonLabel: 'Masuk',
      buttonOnPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(
          LoginScreen.routeName,
          arguments: phoneNumberLocalFormat.substring(1), // Remove leading zero
        );
      },
    );
  }

  Widget _content(String phoneNumber) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Sepertinya kamu sudah terdaftar',
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
                  text: ' sudah terdaftar di Dropezy. \nYuk, masuk aja!',
                ),
              ],
            ),
            style: DropezyTextStyles.caption2.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          )
        ],
      );
}
