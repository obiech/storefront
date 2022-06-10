import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storefront_app/core/core.dart';

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

  /// When [PaymentMethodDetails] is selected,
  /// this callback is triggered
  final Function(PaymentMethodDetails paymentMethod)? onChange;

  const PaymentMethodList({
    Key? key,
    required this.cubit,
    this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return DropezyDismissable(
      // TODO(obella) - Pass dynamic child size
      child: DraggableScrollableSheet(
        maxChildSize: context.methodCardSize(2),
        initialChildSize: context.methodCardSize(2),
        builder: (_, controller) {
          return DropezyBottomSheet(
            marginTop: 24,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  res.strings.choosePaymentMethod,
                  style: res.styles.subtitle,
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
                        return DropezyEmptyState(
                          message: state.message,
                          showRetry: true,
                          onRetry: () => context
                              .read<PaymentMethodCubit>()
                              .queryPaymentMethods(),
                        );
                      } else if (state is LoadedPaymentMethods &&
                          state.methods.isNotEmpty) {
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
                                    SvgPicture.asset(
                                      paymentMethod.image,
                                      height: 36,
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Text(
                                      paymentMethod.title,
                                      style: res.styles.caption1.copyWith(
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
                              return const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: Divider(
                                  color: DropezyColors.dividerColor,
                                  height: 1,
                                ),
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

extension PaymentBottomSheetSizeX on BuildContext {
  /// Get and fix initialChildSize & maxChildSize for bottom sheet
  double methodCardSize(int itemsCount) {
    final dividers = 9 * (itemsCount - 1);
    const topMargin = 24;

    final approxItemsHeight = 44.0 * itemsCount +
        topMargin +
        dividers +
        MediaQuery.of(this).padding.bottom;

    final height = MediaQuery.of(this).size.height;

    final error =
        MediaQuery.of(this).orientation == Orientation.landscape ? 0.125 : 0.07;

    final ratio = (approxItemsHeight / height) + error;

    return min(1, ratio);
  }
}
