import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:storefront_app/constants/dimensions.dart';
import 'package:storefront_app/constants/dropezy_text_styles.dart';
import 'package:storefront_app/ui/widgets/dropezy_button.dart';

import 'drag_handle.dart';

/// Dropezy-themed [BottomSheet]
///
/// Contains a [Stack] with:
/// - [DragHandle] positioned at the top of [BottomSheet]
/// - a child [Widget] visually below the [DragHandle]
///
/// It is implemented using a [Stack] to allow a Scrollable [Widget]
/// as the [child]. This way, when [child] is scrolled, the [DragHandle]
/// will stay at the top of [BottomSheet].
///
/// [child] -- content to be shown
/// [marginTop] -- distance of [child] from the top of [BottomSheet]
/// which defaults to 32 units
///
class DropezyBottomSheet extends StatelessWidget {
  final Widget child;
  final double marginTop;

  const DropezyBottomSheet({
    Key? key,
    required this.child,
    this.marginTop = 32,
  }) : super(key: key);

  /// Bottom Sheet structure (from top to bottom):
  ///
  /// SvgPicture, [content], and a [DropezyButton.primary].
  ///
  /// [svgIconPath] -- location of SVG icon relative to the root folder
  /// [content] -- e.g. a paragraph explaining what happened
  /// [buttonOnLabel] -- label for the Primary Button
  /// [buttonOnPressed] -- callback for the Primary Button
  factory DropezyBottomSheet.singleButton({
    required String svgIconPath,
    required Widget content,
    required String buttonLabel,
    required VoidCallback buttonOnPressed,
    double marginTop = 32,
    bool isLoading = false,
  }) {
    return DropezyBottomSheet(
      marginTop: marginTop,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SvgPicture.asset(svgIconPath),
          const SizedBox(height: 16),
          content,
          const SizedBox(height: 16),
          DropezyButton.primary(
            label: buttonLabel,
            onPressed: buttonOnPressed,
            isLoading: isLoading,
          )
        ],
      ),
    );
  }
  factory DropezyBottomSheet.genericError({
    required BuildContext context,
    required String message,
    VoidCallback? buttonOnPressed,
    String buttonLabel = 'Tutup',
    double marginTop = 32,
    bool isLoading = false,
  }) {
    return DropezyBottomSheet(
      marginTop: marginTop,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Error',
            style: DropezyTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            message,
            style: DropezyTextStyles.caption2,
          ),
          const SizedBox(height: 16),
          DropezyButton.primary(
            label: buttonLabel,
            onPressed: buttonOnPressed ??
                () {
                  Navigator.of(context).pop();
                },
            isLoading: isLoading,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        left: Dimensions.bottomSheetHorizontalPadding,
        right: Dimensions.bottomSheetHorizontalPadding,
        bottom: Dimensions.pagePadding,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.0),
          topRight: Radius.circular(24.0),
        ),
      ),
      width: double.infinity,
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: [
          Container(
            margin: EdgeInsets.only(top: marginTop),
            child: child,
          ),
          const Positioned(
            top: 8,
            child: DragHandle(),
          ),
        ],
      ),
    );
  }
}
