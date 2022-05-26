import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/core.dart';

part 'keys.dart';

/// Page that displays the rationale for requesting Location Access.
///
/// User can choose to grant the permissions, or skip the process altogether.
class RequestLocationAccessPage extends StatelessWidget {
  const RequestLocationAccessPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pageWidth = MediaQuery.of(context).size.width;
    final imageSize = 0.42 * pageWidth;

    return DropezyScaffold.textTitle(
      childPadding: EdgeInsets.all(context.res.dimens.spacingMlarge),
      title: context.res.strings.locationAccess,
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SvgPicture.asset(
                context.res.paths.imageLocationAccess,
                key: const ValueKey(
                  RequestLocationAccessPageKeys.assetImage,
                ),
                width: imageSize,
                height: imageSize,
              ),
              SizedBox(height: context.res.dimens.spacingMxlarge),
              Text(
                context.res.strings.locationAccessRationale,
                textAlign: TextAlign.center,
                style: context.res.styles.subtitle.copyWith(
                  fontWeight: FontWeight.w500,
                  height: 24 / 16,
                ),
              ),
              SizedBox(height: context.res.dimens.spacingMlarge),
              SizedBox(
                width: double.maxFinite,
                child: DropezyButton.primary(
                  key: const ValueKey(
                    RequestLocationAccessPageKeys.buttonGrantAccess,
                  ),
                  label: context.res.strings.activateNow,
                  onPressed: _requestLocationAccess,
                ),
              ),
              SizedBox(height: context.res.dimens.spacingSmall),
              TextButton(
                key: const ValueKey(
                  RequestLocationAccessPageKeys.buttonSkipProcess,
                ),
                child: Text(
                  context.res.strings.later,
                  style: context.res.styles.caption1.copyWith(
                    fontWeight: FontWeight.w600,
                    color: context.res.colors.blue,
                  ),
                ),
                onPressed: () => _skipProcess(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _requestLocationAccess() {
    // TODO (leovinsen): request location access
  }

  void _skipProcess(BuildContext context) {
    context.router.replace(const SearchLocationRoute());
  }
}
