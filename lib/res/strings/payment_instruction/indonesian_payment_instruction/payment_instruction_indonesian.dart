import '../payment_instructions.dart';

part './part/bca_virtual_account_indonesian.dart';

class PaymentInstructionIndonesian extends PaymentInstructions {
  @override
  BCAVirtualAccount get virtualAccount => BCAVirtualAccountIndonesian();
}
