part of '../payment_instruction_english.dart';

class _BCAVirtualAccountEnglish implements BCAVirtualAccount {
  @override
  PaymentSteps get atm => PaymentSteps(
        title: 'ATM',
        steps: [
          'Select Other Transactions on the main menu.',
          'Select Transfer.',
          'Select To BCA Virtual Account.',
          'Insert BCA Virtual Account Number.',
          'Insert the payable amount. And confirm the payment.',
          'Confirm the payment.',
          'Payment complete.'
        ],
      );

  @override
  PaymentSteps get klikBCA => PaymentSteps(
        title: 'Klik BCA',
        steps: [
          'Select Fund Transfer.',
          'Select Transfer to BCA Virtual Account.',
          'Insert BCA Virtual Account Number.',
          'Insert the payable amount.',
          'Confirm the payment.',
          'Payment complete.'
        ],
      );

  @override
  PaymentSteps get mBCA => PaymentSteps(
        title: 'm-BCA',
        steps: [
          'Select m-Transfer.',
          'Select BCA Virtual Account.',
          'Insert BCA Virtual Account Number.',
          'Insert the payable amount.',
          'Confirm the payment.',
          'Payment complete.'
        ],
      );
}
