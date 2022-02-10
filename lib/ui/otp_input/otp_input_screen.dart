import 'package:flutter/material.dart';
import 'package:storefront_app/ui/widgets/dropezy_scaffold.dart';

class OtpInputScreen extends StatelessWidget {
  static const routeName = 'otp-input';

  const OtpInputScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: 'Kode OTP',
      child: const Center(child: Text('OTP Placeholder')),
    );
  }
}
