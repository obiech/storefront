import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:storefront_app/di/injection.dart';

import '../../../../core/core.dart';
import '../../index.dart';

part 'keys.dart';
part 'wrapper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return DropezyScaffold.textTitle(
      title: context.res.strings.editProfile,
      child: MultiBlocListener(
        listeners: blocListenerHandler,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(context.res.dimens.pagePadding),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        DropezyTextFormField(
                          fieldKey: EditProfilePageKeys.fullNameField,
                          label: context.res.strings.name(),
                          hintText: context.res.strings.enterYourName(),
                          onChanged: (fullName) => context
                              .read<EditProfileBloc>()
                              .add(FullNameChanged(fullName)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                decoration: context.res.styles.bottomSheetStyle,
                padding: const EdgeInsets.all(8),
                child: BlocBuilder<EditProfileBloc, EditProfileState>(
                  buildWhen: (previous, current) =>
                      previous.loading != current.loading,
                  builder: (context, state) {
                    return DropezyButton.primary(
                      key: EditProfilePageKeys.saveProfileButton,
                      label: context.res.strings.saveProfile,
                      isLoading: state.loading,
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }
                        context
                            .read<EditProfileBloc>()
                            .add(const FormSubmitted());
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final blocListenerHandler = [
    /// Handle when error occurred
    BlocListener<EditProfileBloc, EditProfileState>(
      listenWhen: (previous, current) => current.errorMessage != null,
      listener: (context, state) {
        final errorMessage = state.errorMessage;
        if (errorMessage != null) {
          ScaffoldMessenger.of(context)
            ..removeCurrentSnackBar()
            ..showSnackBar(
              DropezySnackBar.info(
                errorMessage,
              ),
            );
        }
      },
    ),

    /// Handle when name updated
    BlocListener<EditProfileBloc, EditProfileState>(
      listenWhen: (previous, current) => current.profileUpdated,
      listener: (context, state) {
        // Refresh loaded profile with new full name
        context.read<ProfileCubit>().refreshUpdatedName(state.fullName);
        context.popRoute();
        ScaffoldMessenger.of(context)
          ..removeCurrentSnackBar()
          ..showSnackBar(
            DropezySnackBar.info(
              context.res.strings.savedProfileSnackBarContent,
            ),
          );
      },
    ),
  ];
}
