import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/core.dart';
import '../../../../di/injection.dart';
import 'keys.dart';

part 'parts/auth_buttons_section.dart';
part 'parts/dropezy_text_logo.dart';

/// The actual content for [OnboardingScreen]
/// Does not include black background / other decoration
class OnboardingView extends StatelessWidget {
  const OnboardingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 30),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const DropezyTextLogo(),
                    TextButtonSkip(
                      key: const ValueKey(
                        OnboardingViewKeys.buttonSkipOnboarding,
                      ),
                      onPressed: () => _skipOnboarding(context),
                    ),
                  ],
                ),
                const SizedBox(height: 20.0),
                Text(
                  context.res.strings.shoppingForDailyNeeds,
                  style: context.res.styles.caption1.copyWith(
                    fontWeight: FontWeight.w500,
                    color: context.res.colors.white,
                    height: 2.0,
                  ),
                ),
                Text(
                  '${context.res.strings.superEzyWith}\nDropezy',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: context.res.colors.white,
                    fontSize: 26,
                    height: 1.5,
                  ),
                ),
                // Shrink Image on smaller screens
                Flexible(
                  child: Image.asset(
                    'assets/images/splash_person.png',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24.0),
          Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: ButtonsSection(
              onRegisterTap: () => context.router.push(RegistrationRoute()),
              onLoginTap: () => context.router.push(LoginRoute()),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _skipOnboarding(BuildContext context) async {
    await getIt<IPrefsRepository>().setIsOnBoarded(true);
    context.router.replaceAll([const MainRoute()]);
  }
}
