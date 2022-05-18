import 'package:flutter/material.dart';

class AddressLoadingView extends StatelessWidget {
  const AddressLoadingView({Key? key}) : super(key: key);

  // TODO (Widy): Improve loading view
  @override
  Widget build(BuildContext context) {
    return const CircularProgressIndicator();
  }
}
