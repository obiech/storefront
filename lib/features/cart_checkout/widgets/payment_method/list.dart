import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/shared_widgets/bottom_sheet/dropezy_bottom_sheet.dart';
import '../../../../core/utils/bottom_sheet_utils.dart';
import '../../blocs/blocs.dart';
import '../../domain/domains.dart';

/// List of all payment methods currently supported
class PaymentMethodList extends StatelessWidget {
  /// Cubit for payment methods access
  ///
  /// Passed here because it's used in
  /// a bottom sheet hence a break in
  /// [BlocProvider] access
  final PaymentMethodCubit cubit;

  /// When a [PaymentMethod] is selected,
  /// this callback is triggered
  final Function(PaymentMethod paymentMethod)? onChange;

  const PaymentMethodList({
    Key? key,
    required this.cubit,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return makeDismissable(
      context: context,
      child: DraggableScrollableSheet(
        /// TODO - Set basing on number of payment methods
        maxChildSize: .8,
        builder: (_, controller) {
          return DropezyBottomSheet(
            marginTop: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              // controller: controller,
              children: [
                const Text(
                  'Pilih Metode Pembayaran',
                  style: DropezyTextStyles.subtitle,
                ),
                const SizedBox(
                  height: 16,
                ),
                // TODO - Revisit with ListView grouping by category
                //  Text(
                //   'E-Wallet',
                //   style: DropezyTextStyles.subtitle.copyWith(fontSize: 14),
                // ),
                // const SizedBox(
                //   height: 12,
                // ),
                Expanded(
                  child: BlocBuilder<PaymentMethodCubit, PaymentMethodState>(
                    bloc: cubit,
                    builder: (context, state) {
                      if (state is LoadingPaymentMethods) {
                        /// When payment methods are being loaded from cache
                        /// or network
                        ///
                        /// TODO - Use skeleton loader
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is ErrorLoadingPaymentMethods) {
                        /// When there is an error when loading payment methods
                        ///
                        /// TODO - Request design team for proper design
                        return const Center(
                          child: Text('Error loading Payment Methods'),
                        );
                      } else if (state is LoadedPaymentMethods) {
                        /// Display payment methods and their logos
                        return ListView.separated(
                          controller: controller,
                          itemBuilder: (BuildContext context, int index) {
                            final paymentMethod = state.methods[index];
                            return InkWell(
                              key: ValueKey('payment-method-$index'),
                              onTap: () => onChange?.call(paymentMethod),
                              child: SizedBox(
                                height: 52,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      paymentMethod.image,
                                      fit: BoxFit.contain,
                                      height: 36,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      paymentMethod.title,
                                      style:
                                          DropezyTextStyles.caption1.copyWith(
                                        fontWeight: FontWeight.w400,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            if (index != state.methods.length - 1) {
                              return const Divider(
                                color: DropezyColors.dividerColor,
                                height: 1,
                              );
                            }
                            return const SizedBox();
                          },
                          itemCount: state.methods.length,
                        );
                      } else {
                        /// Just in case the cubit state is none of the above
                        ///
                        /// TODO - Request design team for empty state of Payment methods
                        return const Center(
                          child: Text('No Payment Methods'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
