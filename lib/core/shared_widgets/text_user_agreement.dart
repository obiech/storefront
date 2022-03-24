import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/config/external_url_config.dart';
import '../../core/constants/dropezy_text_styles.dart';

/// Text to confirm
class TextUserAgreement extends StatelessWidget {
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

  Future<void> _openTermsAndConditions() async {
    final url = ExternalUrlConfig.urlTermsConditions;
    if (await canLaunch(url)) {
      launch(url);
    }
  }

  Future<void> _openPrivacyPolicy() async {
    final url = ExternalUrlConfig.urlPrivacyPolicy;
    if (await canLaunch(url)) {
      launch(url);
    }
  }
}
