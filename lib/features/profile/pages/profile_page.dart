import 'package:flutter/material.dart';

import '../../../core/core.dart';

import '../widgets/widgets.dart';

part 'keys.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: 'Profile',
      header: const ProfileHeader(),
      child: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ProfileAccountSection(),
              const ThickDivider(),
              const ProfileGeneralSection(),
              Container(
                padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                width: double.infinity,
                child: DropezyButton.blueTint(
                  label: context.res.strings.signOut,
                  onPressed: () {
                    showDropezyBottomSheet(context, (_) {
                      return const ProfileSignOutBottomSheet();
                    });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
