part of './edit_profile_page.dart';

class EditProfilePageWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const EditProfilePageWrapper({Key? key}) : super(key: key);
  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<EditProfileBloc>(),
      child: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return const EditProfilePage();
  }
}
