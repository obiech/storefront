import 'package:flutter/cupertino.dart' show CupertinoIcons;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/dropezy_colors.dart';
import '../../../../res/resources.dart';
import '../../blocs/blocs.dart';
import '../../domain/domains.dart';
import 'keys.dart';
import 'list.dart';

/// Helps toggle different payment providers
class PaymentMethodSelector extends StatelessWidget {
  /// Callback to handle payment method change
  final Function(PaymentMethodDetails paymentMethod) onChange;

  const PaymentMethodSelector({Key? key, required this.onChange})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final res = Resources.of(context);
    return Container(
      decoration: BoxDecoration(
        color: res.colors.white,
        boxShadow: const [
          BoxShadow(
            offset: Offset(-1, 0),
            color: Color(0xFFE6EDF5),
          )
        ],
      ),
      child: TextButton.icon(
        key: const ValueKey(PaymentMethodKeys.button),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: Colors.transparent,
            builder: (ctx) {
              final paymentMethodCubit = context.read<PaymentMethodCubit>();
              return PaymentMethodList(
                cubit: paymentMethodCubit,
                onChange: (PaymentMethodDetails paymentMethod) {
                  paymentMethodCubit.setPaymentMethod(paymentMethod);
                  Navigator.of(context).pop();
                },
              );
            },
          );
        },
        icon: BlocBuilder<PaymentMethodCubit, PaymentMethodState>(
          builder: (context, state) {
            if (state is! LoadedPaymentMethods) {
              return Text('${res.strings.loading} ...');
            } else {
              return Padding(
                padding: const EdgeInsets.fromLTRB(8, 4, 10, 4),
                child: SvgPicture.asset(
                  state.activePaymentMethod.image,
                  height: 40,
                  key: const ValueKey(PaymentMethodKeys.logo),
                ),
              );
            }
          },
        ),
        label: const Icon(
          CupertinoIcons.chevron_down,
          size: 15,
          color: DropezyColors.black,
        ),
      ),
    );
  }
}
