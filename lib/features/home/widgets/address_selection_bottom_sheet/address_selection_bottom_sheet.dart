import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/core.dart';
import '../../../address/index.dart';
import '../../index.dart';

part 'parts/add_address.dart';
part 'parts/address_list.dart';
part 'parts/address_listview.dart';

class AddressSelectionBottomSheet extends StatelessWidget {
  const AddressSelectionBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyBottomSheet(
      marginTop: 28,
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: Text(
              context.res.strings.chooseAddress,
              style: DropezyTextStyles.subtitle,
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35,
            child: const AddressList(),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: AddAddress(),
          ),
        ],
      ),
    );
  }
}
