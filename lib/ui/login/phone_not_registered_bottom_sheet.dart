import 'package:flutter/material.dart';
import 'package:storefront_app/constants/assets_path.dart';
import 'package:storefront_app/constants/dropezy_text_styles.dart';
import 'package:storefront_app/ui/registration/registration_screen.dart';
import 'package:storefront_app/ui/widgets/bottom_sheet/dropezy_bottom_sheet.dart';

/// [DropezyBottomSheet] for notifying user that their phone number
/// is not found in Dropezy database, and they should instead register
/// their phone number.
///
/// When user clicks on the button:
/// 1) This [BottomSheet] will be dismissed
/// 2) App will navigate to [RegistrationScreen]
class PhoneNotRegisteredBottomSheet extends StatelessWidget {
  final String phoneNumber;

  const PhoneNotRegisteredBottomSheet({
    Key? key,
    required this.phoneNumber,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyBottomSheet.singleButton(
      svgIconPath: AssetsPath.icPhoneVerification,
      content: _content(phoneNumber),
      buttonLabel: 'Daftar Sekarang',
      buttonOnPressed: () {
        Navigator.of(context).pop();
        Navigator.of(context).pushNamed(RegistrationScreen.routeName);
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
                    text: ' belum terdaftar di Dropezy. \nYuk, daftarin dulu!'),
              ],
            ),
            style: DropezyTextStyles.caption2.copyWith(height: 1.5),
            textAlign: TextAlign.center,
          )
        ],
      );
}
