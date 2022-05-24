part of '../help_page.dart';

class _WhatsAppButton extends StatelessWidget {
  const _WhatsAppButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _openWhatsApp,
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: context.res.dimens.spacingMedium,
          horizontal: context.res.dimens.spacingLarge,
        ),
        decoration: BoxDecoration(
          color: context.res.colors.blue,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Icon(DropezyIcons.whatsapp),
              SizedBox(
                width: context.res.dimens.spacingSmall,
              ),
              Text(
                context.res.strings.whatsapp,
                style: context.res.styles.subtitle.copyWith(
                  fontSize: context.res.dimens.smallText,
                  color: context.res.colors.white,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

/// Used to Launch Whatsapp.
///
/// try and catch block was used instead of
/// await canLaunch(url)
/// due to a strange behaviour in urlLauncher that throws an
/// exception if the url is a deepLink.
Future<void> _openWhatsApp() async {
  final String whatsAppDeepLink = ExternalUrlConfig.whatsAppUniversalUrl +
      ExternalUrlConfig.customerServiceWhatsApp;
  try {
    await launch(whatsAppDeepLink);
  } catch (e) {
    log('Error :$e, Url : $whatsAppDeepLink', name: 'Error Launching WhatApp');
  }
}
