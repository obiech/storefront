part of '../appbar.dart';

/// [Text] that prompts user to login or register a new account
/// shown in [HomeAppBar].
///
/// Will be displayed when user is logged out.
/// Otherwise, [AddressSelection] will be displayed instead.
class PromptLoginOrRegister extends StatelessWidget {
  @visibleForTesting
  const PromptLoginOrRegister({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            context.res.strings.promptLoginOrRegister,
            style: context.res.styles.caption1.copyWith(
              fontWeight: FontWeight.w600,
              color: context.res.colors.white,
            ),
          ),
          const SizedBox(width: 4),
          const Icon(
            DropezyIcons.chevron_down,
            size: 16,
          ),
        ],
      ),
    );
  }
}
