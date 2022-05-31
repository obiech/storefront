part of '../english_faq.dart';

class _AboutDropezyEnglish implements AboutDropezy {
  @override
  String get section => 'About Dropezy';
  @override
  QuestionAndAnswer get howDoIContactDropezy => QuestionAndAnswer(
        'How do I contact Dropezy',
        'Dropezy is always there for you, whenever you need a'
            ' Dropezy. You can contact us via our WhatsApp: 081717173327',
      );

  @override
  QuestionAndAnswer get whenAreDropezyOpeningHours => QuestionAndAnswer(
        "When are Dropezy's opening hours",
        'Dropezy is open 24 hours for several stores.'
            ' Our operational hours start'
            ' from 08.00-12.00. We remain open on weekends'
            ' and national holidays.',
      );
}
