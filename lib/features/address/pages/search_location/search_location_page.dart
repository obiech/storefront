import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';
import 'package:storefront_app/features/address/index.dart';

part 'keys.dart';
part 'wrapper.dart';

class SearchLocationPage extends StatelessWidget {
  const SearchLocationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.whereIsYourAddress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          SearchLocationHeader(),
          ThickDivider(),
          Expanded(
            child: SearchLocationResult(),
          ),
        ],
      ),
    );
  }
}
