import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

import '../../widgets/onboarding/onboarding_view.dart';
import 'triangle_clipper.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({
    Key? key,
    this.isUserSignOut = false,
  }) : super(key: key);

  final bool isUserSignOut;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with AfterLayoutMixin {
  @override
  void afterFirstLayout(BuildContext context) {
    if (widget.isUserSignOut == true) {
      context.showToast(
        context.res.strings.youveLogoutSuccesfully,
        color: DropezyColors.green,
        leading: const Icon(DropezyIcons.radio_checked),
        duration: const Duration(seconds: 2),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const _GradientBackground(),
          const _BlackTriangleWidget(),
          SafeArea(
            bottom: false,
            child: SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Stack(
                children: [
                  Positioned(
                    bottom: 14,
                    left: 0,
                    child: _paprika(),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    child: _meat(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _broccoli(),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: _tomato(),
                  ),
                  const OnboardingView(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _paprika() => Image.asset(
        'assets/images/splash_paprika.png',
        width: 36,
        height: 110,
      );

  Widget _meat() => Image.asset(
        'assets/images/splash_meat.png',
        width: 144,
        height: 139,
      );

  Widget _broccoli() => Image.asset(
        'assets/images/splash_broccoli.png',
        width: 101,
        height: 133,
      );

  Widget _tomato() => Image.asset(
        'assets/images/splash_tomato.png',
        width: 110,
        height: 65,
      );
}

/// Background with dark bluish [LinearGradient]
class _GradientBackground extends StatelessWidget {
  const _GradientBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF11142C).withOpacity(0.7),
            const Color(0xFF115DCC).withOpacity(0.7),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: const [0.30, 1.0],
        ),
      ),
    );
  }
}

/// A black triangle located at top left of page
class _BlackTriangleWidget extends StatelessWidget {
  const _BlackTriangleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final pageHeight = MediaQuery.of(context).size.height;
    return ClipPath(
      clipper: TriangleClipper(),
      child: Container(
        width: pageWidth * 0.85,
        height: pageHeight * 0.3125,
        color: Colors.black,
      ),
    );
  }
}
