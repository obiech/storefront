part of '../english_faq.dart';

class _ExpenditureEnglish implements Expenditure {
  @override
  String get section => 'Expenditure';

  @override
  QuestionAndAnswer get isThereAMinimumOrder => QuestionAndAnswer(
        'Is There a minimum order?',
        'Shop at Dropezy without a minimum order.',
      );

  @override
  QuestionAndAnswer get whenCanWeReceiveTheItems => QuestionAndAnswer(
        'When can we receive the items?',
        'Order duration is counted after the payment is completed'
            ' and the order will be received within 15 minutes',
      );

  @override
  QuestionAndAnswer get howMuchIsTheShippingCost => QuestionAndAnswer(
        'How much is the shipping cost',
        'Dropezy provides free shipping costs for every shipment'
            ' in all Dropzy stores.',
      );

  @override
  QuestionAndAnswer get whatAreTheMethodsOfPaymentOfDropezy =>
      QuestionAndAnswer(
        'What are the methods of payment of Dropezy',
        'Dropezy provides a variety of payments, you can make payments for'
            ' your order by using BCA virtual account or Gopay',
      );

  @override
  QuestionAndAnswer get doDropezyAcceptCashOnDeliveryPayments =>
      QuestionAndAnswer(
        'Do Dropezy accept cash on delivery payments?',
        'Currently, we do not received payments using the'
            ' Cash On Delivery (COD) method',
      );

  @override
  QuestionAndAnswer get canTheOrderBeChangedAfterPayments => QuestionAndAnswer(
        'Can the order be changed/cancelled after payment?',
        '''
Orders that have been paid cannot be changed or canceled.
                                                                                       
For service assistance please contact Customer Service 081717173327''',
      );

  @override
  QuestionAndAnswer get canYouChangeTheAddressIfTheOrderIsRuning =>
      QuestionAndAnswer(
        'Can you change the Address if the order is runing?',
        '''
If the order is in process, you cannot change the address that you have listed.'
' Therefore, make sure the address listed is appropriate.

For service assistance please contact Customer Service 081717173327''',
      );
}
