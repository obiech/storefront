import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/core.dart';
import '../index.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //TODO(Jeco): Better State Handling
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 24.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.profile.fullName.trim().isNotEmpty) ...[
                        Text(
                          context.res.strings.hiUser(state.profile.fullName),
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
                        state.profile.phoneNumber,
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
