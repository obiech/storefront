import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/address/index.dart';

class SearchLocationHeader extends StatelessWidget {
  const SearchLocationHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.res.dimens.pagePadding),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                onPressed: () {
                  // TODO (widy): handle use current location
                  // https://dropezy.atlassian.net/browse/STOR-623
                },
                icon: const Icon(DropezyIcons.pin),
                label: Text(context.res.strings.useCurrentLocation),
              ),
              DropezyChip.primary(
                res: context.res,
                label: context.res.strings.viewMap,
                leading: Icon(
                  DropezyIcons.map,
                  color: context.res.colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SearchTextField(
            placeholder: context.res.strings.typeYourAddress,
            onTextChanged: (query) {
              context.read<SearchLocationBloc>().add(QueryChanged(query));
            },
            onCleared: () {
              context.read<SearchLocationBloc>().add(const QueryDeleted());
            },
          ),
        ],
      ),
    );
  }
}
