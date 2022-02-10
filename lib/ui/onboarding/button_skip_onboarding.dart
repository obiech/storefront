import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storefront_app/bloc/onboarding/onboarding_cubit.dart';
import 'package:storefront_app/constants/dropezy_colors.dart';
import 'package:storefront_app/constants/dropezy_text_styles.dart';
import 'package:storefront_app/ui/home/home_screen.dart';

class ButtonSkipOnboarding extends StatelessWidget {
  const ButtonSkipOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => await _skipOnboarding(context),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Lewati',
            style: DropezyTextStyles.caption2.copyWith(
              color: DropezyColors.white,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8.0),
          SvgPicture.asset('assets/icons/ic_chevron_right.svg'),
        ],
      ),
    );
  }

  Future<void> _skipOnboarding(BuildContext context) async {
    context.read<OnboardingCubit>().finishOnboarding();
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }
}
