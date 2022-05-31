part of '../english_faq.dart';

class _PaymentRefundEnglish implements PaymentRefund {
  @override
  String get section => 'Payment Refund';

  @override
  QuestionAndAnswer get refundPeriod => QuestionAndAnswer(
        'Refund Period',
        'The process of refund through wallet (Wallet Ezy, and gopay) will'
            ' take 2x 24 hours on weekdays (not including Saturday, Sunday,'
            ' and national holidays) while the refund process through Bank will'
            ' take 3x24 hours on weekdays (not including Saturday,'
            ' Sunday and National Holidays).',
      );

  @override
  QuestionAndAnswer get whatAreTheCriteriaThatMustBeMetToCancelOrder =>
      QuestionAndAnswer(
        'What are the criteria that must be met to cancel (refund) order?',
        '''
The following are the criteria for the cancellation:
1. The product you ordered is not available
2. The number of products sent does not match the order
3. The product you receive is damaged, defective and not suitable'''
            '''
 for consumption or use.
4. Placement of Pin Point is not appropriate''',
      );

  @override
  QuestionAndAnswer get howTheMethodOfRefundingProcess => QuestionAndAnswer(
        'How the method of refunding process',
        '''
How to refund:
For you to request a refund, you can send photos and videos after your order'''
            '''
 is received to our WhatsApp: 081717173327.
Then, for refund partial (refund several products) and refund'''
            '''
 because the indication of the abuse of vouchers will be automatically'''
            '''
 returned to the Wallet Ezy each customer.
Then, for the refund due to a personal mistake which is adding the'''
            '''
 wrong pinpoint (the address point is not correct), the refund will'''
            '''
 only be processed to the Wallet Ezy.

Dropezy will refund or cancel an order if Dropezy's side detects'''
            ''' any abuse on the voucher/coupon''',
      );

  @override
  QuestionAndAnswer get whatIsTheProcessOfRefundWalletEzy => QuestionAndAnswer(
        'What is the process of refund wallet ezy?',
        'The refund process through the Wallet Ezy will only be processed'
            ' back to the Wallet Ezy number that has been registered in the'
            ' Dropezy account, refund through Wallet Ezy with an estimated'
            ' time of 2 working days (not counted as Saturday, Sunday, and'
            ' National Holidays).',
      );

  @override
  QuestionAndAnswer get whatIsTheBankTransferProcess => QuestionAndAnswer(
        'What is the bank transfer Process?',
        '''
The refund process through Bank, please inform the following data:
1. Name of the account owner
2. Account Number
3. Bank

For information to refund to a bank account, it will take 3 working days'
' (not as of Saturday, Sunday, and National Holidays).''',
      );

  @override
  QuestionAndAnswer get whatIsTheRefundProcessOfGopay => QuestionAndAnswer(
        'What is the refund process of Gopay?',
        'The Gopay refund process will automatically refund by including'
            ' the customer payment ID in the application, so the customer'
            ' does not need to re-inform the Gopay account number. Refund'
            ' through Gopay with an estimated time of 2 working days (not'
            ' as of Saturday, Sunday, and National Holidays).',
      );
}
