import 'package:flutter/material.dart';
import 'package:storefront_app/constants/dropezy_text_styles.dart';
import 'package:url_launcher/url_launcher.dart';

/// Text to confirm
class TextUserAgreement extends StatelessWidget {
  // TODO: use Environment variables for URL
  static const urlTermsAndConditions = 'https://dropezy.com';
  static const urlPrivacyPolicy = 'https://dropezy.com';

  final String userAction;

  const TextUserAgreement({
    Key? key,
    required this.userAction,
  }) : super(key: key);

  factory TextUserAgreement.login() {
    const action = 'Dengan masuk, maka kamu setuju dengan';

    return const TextUserAgreement(userAction: action);
  }

  factory TextUserAgreement.registration() {
    const action = 'Dengan daftar, maka kamu setuju dengan';

    return const TextUserAgreement(userAction: action);
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        text: 'Dengan daftar, maka kamu setuju dengan ',
        children: [
          WidgetSpan(
            child: InkWell(
              onTap: _openTermsAndConditions,
              child: const Text(
                'Ketentuan Layanan',
                style: DropezyTextStyles.clickableText,
              ),
            ),
          ),
          const TextSpan(text: ' dan '),
          WidgetSpan(
            child: InkWell(
              onTap: _openPrivacyPolicy,
              child: const Text(
                'Kebijakan Privasi',
                style: DropezyTextStyles.clickableText,
              ),
            ),
          ),
          const TextSpan(text: ' Dropezy.'),
        ],
      ),
      style: DropezyTextStyles.caption2.copyWith(height: 1.5),
    );
  }

  void _openTermsAndConditions() async {
    if (await canLaunch(urlTermsAndConditions)) {
      launch(urlTermsAndConditions);
    }
  }

  void _openPrivacyPolicy() async {
    if (await canLaunch(urlTermsAndConditions)) {
      launch(urlTermsAndConditions);
    }
  }
}
