part of '../onboarding_view.dart';

class DropezyTextLogo extends StatelessWidget {
  const DropezyTextLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      'assets/images/dropezy_text_logo.svg',
      width: 144,
    );
  }
}
