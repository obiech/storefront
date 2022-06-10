import '../payment_instructions.dart';

part './part/bca_virtual_account_english.dart';

class PaymentInstructionEnglish extends PaymentInstructions {
  @override
  BCAVirtualAccount get virtualAccount => _BCAVirtualAccountEnglish();
}
