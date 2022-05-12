import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storefront_app/core/core.dart';

/// Widget for showing tappable menu tile on profile page
/// with [icon] on the left,
/// [title] on the center,
/// and chevron icon on the right
///
class ProfileMenuTile extends StatelessWidget {
  final Widget icon;
  final String title;
  final VoidCallback onTap;

  const ProfileMenuTile._({
    Key? key,
    required this.icon,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Row(
              children: [
                icon,
                const SizedBox(width: 20),
                Expanded(
                  child: Text(
                    title,
                    style: context.res.styles.subtitle.copyWith(fontSize: 14),
                  ),
                ),
                const Icon(
                  DropezyIcons.chevron_left,
                  color: DropezyColors.black,
                ),
              ],
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }

  /// Use [ProfileMenuTile.icon] factory to use
  /// icon with preset color
  factory ProfileMenuTile.icon({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ProfileMenuTile._(
      icon: Icon(
        icon,
        color: DropezyColors.black,
      ),
      title: title,
      onTap: onTap,
    );
  }

  /// Use [ProfileMenuTile.svgImage] factory to use
  /// svg asset with preset width instead of regular icon
  factory ProfileMenuTile.svgImage({
    required String assetPath,
    required String title,
    required VoidCallback onTap,
  }) {
    return ProfileMenuTile._(
      icon: SvgPicture.asset(
        assetPath,
        width: 24,
      ),
      title: title,
      onTap: onTap,
    );
  }
}
