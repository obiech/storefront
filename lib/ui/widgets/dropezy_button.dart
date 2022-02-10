import 'package:flutter/material.dart';
import 'package:storefront_app/constants/dropezy_colors.dart';
import 'package:storefront_app/constants/dropezy_text_styles.dart';

class DropezyButton extends StatelessWidget {
  const DropezyButton({
    Key? key,
    required this.label,
    required this.textStyle,
    required this.backgroundColor,
    this.onPressed,
  }) : super(key: key);

  factory DropezyButton.primary({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return DropezyButton(
      label: label,
      backgroundColor: DropezyColors.blue,
      onPressed: onPressed,
      textStyle: DropezyTextStyles.button.copyWith(
        color: DropezyColors.white,
      ),
    );
  }

  factory DropezyButton.secondary({
    required String label,
    required VoidCallback? onPressed,
  }) {
    return DropezyButton(
      label: label,
      backgroundColor: DropezyColors.white,
      onPressed: onPressed,
      textStyle: DropezyTextStyles.button.copyWith(
        color: DropezyColors.blue,
      ),
    );
  }

  final String label;
  final TextStyle? textStyle;
  final Color backgroundColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        label,
        style: textStyle,
      ),
      style: ElevatedButton.styleFrom(
        primary: backgroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 16.0,
        ),
        shape: const StadiumBorder(),
      ),
    );
  }
}
