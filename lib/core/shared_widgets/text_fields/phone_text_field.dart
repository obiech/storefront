import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/constants/assets_path.dart';
import '../../../core/constants/dropezy_colors.dart';
import '../../../core/constants/dropezy_text_styles.dart';

/// [TextFormField] for phone numbers
///
/// On left side [SvgPicture] that displays a Rounded Indonesian Flag.
/// On right side is a [TextFormField] that accepts the phone number input.
/// These two widgets are separated by a [VerticalDivider]
///
/// By default, [textInputAction] is set to [TextInputAction.done]
/// which will hide the system keyboard when tapped.
class PhoneTextField extends StatelessWidget {
  /// Excluding '0' or '+62'

  static const indonesiaMinPhoneNumLength = 9;
  static const indonesiaMaxPhoneNumLength = 13;

  static const errorPhoneNumberTooShort =
      'Nomor HP minimal $indonesiaMinPhoneNumLength angka';

  static final phoneNumberFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(indonesiaMaxPhoneNumLength),
  ];

  final TextEditingController controller;
  final TextInputAction? textInputAction;

  const PhoneTextField({
    Key? key,
    required this.controller,
    this.textInputAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: DropezyColors.textFieldBorderGrey),
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.transparent,
          ),
          child: IntrinsicHeight(
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    left: 12.0,
                    top: 12.0,
                    right: 10.0,
                    bottom: 12.0,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AssetsPath.icIndonesiaFlagRounded,
                        width: 20,
                        height: 20,
                      ),
                      const SizedBox(width: 10.0),
                      const Text(
                        '+62',
                        style: DropezyTextStyles.textFieldContent,
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(
                  width: 1.0,
                  thickness: 1.0,
                  color: DropezyColors.textFieldBorderGrey,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 12.0,
                      right: 10.0,
                    ),
                    child: TextFormField(
                      controller: controller,
                      keyboardType: TextInputType.phone,
                      textInputAction: textInputAction ?? TextInputAction.done,
                      inputFormatters: phoneNumberFormatters,
                      decoration: const InputDecoration.collapsed(
                        hintText: 'Ex. 81234567890',
                        hintStyle: DropezyTextStyles.textFieldHint,
                      ),
                      validator: (str) {
                        if (str == null) return null;

                        if (str.length < indonesiaMinPhoneNumLength) {
                          return errorPhoneNumberTooShort;
                        }

                        return null;
                      },
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
