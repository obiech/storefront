import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../constants/assets_path.dart';
import '../../../constants/dropezy_colors.dart';
import '../../../constants/dropezy_text_styles.dart';

class TextButtonSkip extends StatelessWidget {
  const TextButtonSkip({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  static const labelSkip = 'Lewati';

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labelSkip,
            style: DropezyTextStyles.caption2.copyWith(
              color: DropezyColors.white,
              height: 1.0,
            ),
          ),
          const SizedBox(width: 8.0),
          SvgPicture.asset(AssetsPath.icChevronRight),
        ],
      ),
    );
  }
}
