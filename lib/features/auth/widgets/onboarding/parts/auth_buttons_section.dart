part of '../onboarding_view.dart';

/// a [Row] containing buttons 'Register' and 'Login'
class ButtonsSection extends StatelessWidget {
  const ButtonsSection({
    Key? key,
    required this.onRegisterTap,
    required this.onLoginTap,
  }) : super(key: key);

  /// Callback when button 'Register' is tapped
  final VoidCallback onRegisterTap;

  /// Callback when button 'Login' is tapped
  final VoidCallback onLoginTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: DropezyButton.secondary(
            key: const ValueKey(OnboardingViewKeys.buttonRegister),
            label: context.res.strings.register,
            onPressed: onRegisterTap,
          ),
        ),
        const SizedBox(width: 12.0),
        Expanded(
          child: DropezyButton.primary(
            key: const ValueKey(OnboardingViewKeys.buttonLogin),
            label: context.res.strings.login,
            onPressed: onLoginTap,
          ),
        ),
      ],
    );
  }
}
