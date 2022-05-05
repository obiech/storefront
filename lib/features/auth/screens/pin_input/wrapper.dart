part of 'pin_input_screen.dart';

/// Wrapper for providing [PinRegistrationCubit] to
/// [PinInputScreen].
///
/// With this approach, [PinInputScreen] can be tested
/// separately from DI setup.
class PinInputScreenWrapper extends StatelessWidget
    implements AutoRouteWrapper {
  const PinInputScreenWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const PinInputScreen();
  }

  @override
  Widget wrappedRoute(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<PinRegistrationCubit>(),
      child: this,
    );
  }
}
