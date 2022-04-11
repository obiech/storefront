import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/di/injection.dart';

class ButtonSkipOnboarding extends StatelessWidget {
  const ButtonSkipOnboarding({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async => _skipOnboarding(context),
      child: Row(
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
    await getIt<IPrefsRepository>().setIsOnBoarded(true);
    context.router.replaceAll([const MainRoute()]);
  }
}
