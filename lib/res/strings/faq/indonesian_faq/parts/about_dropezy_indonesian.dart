part of '../indonesian_faq.dart';

class _AboutDropezyIndonesian implements AboutDropezy {
  @override
  String get section => 'Tentang Dropezy';

  @override
  QuestionAndAnswer get howDoIContactDropezy => QuestionAndAnswer(
        'Bagaimana cara menghubungi Dropezy? ',
        'Dropezy selalu ada untukmu, kapanpun kamu membutuhkan Dropezy.'
            ' Kamu bisa menghubungi kami melalui WhatsApp kami: 081717173327',
      );

  @override
  QuestionAndAnswer get whenAreDropezyOpeningHours => QuestionAndAnswer(
        'Kapan jam buka Dropezy?',
        'Dropezy buka 24 jam untuk beberapa store. Operasional jam kerja'
            ' kami mulai dari pukul 08.00-00.00.  Kami tetap buka di akhir'
            ' pekan dan hari libur nasional.',
      );
}
