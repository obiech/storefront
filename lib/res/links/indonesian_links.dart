import 'base_links.dart';

class IndonesianLinks implements BaseLinks {
  @override
  String get policy => '';

  @override
  String get terms => '';

  @override
  String whatsappDeeplink(String phoneIntlFormat) {
    final phone = phoneIntlFormat.startsWith('+')
        ? phoneIntlFormat.substring(1)
        : phoneIntlFormat;

    return 'https://wa.me/$phone';
  }
}
