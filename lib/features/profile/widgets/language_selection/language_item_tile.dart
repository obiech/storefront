part of 'language_selection_bottomsheet.dart';

class LanguageItemTile extends StatelessWidget {
  final String flagPath;
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const LanguageItemTile({
    Key? key,
    required this.flagPath,
    required this.title,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        highlightColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        onTap: onTap,
        child: Column(
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  flagPath,
                  width: 24,
                  height: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: context.res.styles.caption1,
                  ),
                ),
                RadioIcon(active: isActive)
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
