part of 'pin_input_page.dart';

/// Wrapper for providing [PinRegistrationCubit] to
/// [PinInputPage].
///
/// With this approach, [PinInputPage] can be tested
/// separately from DI setup.
class PinInputPageWrapper extends StatelessWidget implements AutoRouteWrapper {
  const PinInputPageWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PinInputPage();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PinRegistrationCubit>(),
      child: this,
    );
  }
}
