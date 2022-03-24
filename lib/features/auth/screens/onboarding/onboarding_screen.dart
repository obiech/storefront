import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../../../../core/constants/constants.dart';
import 'button_login.dart';
import 'button_register.dart';
import 'button_skip_onboarding.dart';
import 'triangle_clipper.dart';

class OnboardingScreen extends StatelessWidget {
  static const routeName = 'onboarding';

  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Container(
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
          ),
          ClipPath(
            clipper: TriangleClipper(),
            child: Container(
              width: screenWidth * 0.85,
              height: screenHeight * 0.3125,
              color: Colors.black,
            ),
          ),
          _content()
        ],
      ),
    );
  }

  Widget _content() => SafeArea(
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
              _body(),
            ],
          ),
        ),
      );

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

  Widget _body() => Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Flexible(child: _upperSection()),
            Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: _buttons(),
            ),
          ],
        ),
      );

  Widget _upperSection() => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _dropezyLogo(),

              // TODO(leovinsen): Use TextButtonSkip instead
              const ButtonSkipOnboarding(),
            ],
          ),
          const SizedBox(height: 20.0),
          _firstLine(),
          _secondLine(),
          // Shrink Image on smaller screens
          Flexible(
            child: Image.asset(
              'assets/images/splash_person.png',
            ),
          ),
          // This is the minimum distance between Image and Buttons
          const SizedBox(height: 24.0),
        ],
      );

  Widget _dropezyLogo() => SvgPicture.asset(
        'assets/images/dropezy_text_logo.svg',
        width: 144,
      );

  Widget _firstLine() => const Text(
        'Belanja kebutuhan harian',
        style: TextStyle(
          fontWeight: FontWeight.w500,
          color: DropezyColors.white,
          fontSize: 16,
          height: 2.0,
        ),
      );

  Widget _secondLine() => const Text(
        'Super Ezy dengan \nDropezy',
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: DropezyColors.white,
          fontSize: 26,
          height: 1.5,
        ),
      );

  Widget _buttons() => Builder(
        builder: (context) {
          return Row(
            children: const [
              Expanded(
                child: ButtonRegister(),
              ),
              SizedBox(width: 12.0),
              Expanded(
                child: ButtonLogin(),
              ),
            ],
          );
        },
      );
}
