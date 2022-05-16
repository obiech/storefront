import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../blocs/profile_cubit.dart';
import '../index.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final userName = state.name;
          return Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (userName != null) ...[
                        Text(
                          context.res.strings.hiUser(userName),
                          key: ProfilePageKeys.userName,
                          style: context.res.styles.subtitle.copyWith(
                            color: DropezyColors.white,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                      ],
                      Text(
                        state.phoneNumber,
                        key: ProfilePageKeys.userPhoneNumber,
                        style: context.res.styles.subtitle.copyWith(
                          color: DropezyColors.lightBlue,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                CircleAvatar(
                  child: IconButton(
                    key: ProfilePageKeys.editProfileButton,
                    onPressed: () {
                      context.pushRoute(const EditProfileRoute());
                    },
                    icon: const Icon(DropezyIcons.edit),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
