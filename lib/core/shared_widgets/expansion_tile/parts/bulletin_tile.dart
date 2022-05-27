part of '../dropezy_expansion_tile.dart';

class _BulletinTile extends StatelessWidget {
  final String bulletinText;
  const _BulletinTile({Key? key, required this.bulletinText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 5),
          child: Icon(
            Icons.circle,
            size: 5,
            color: context.res.colors.black,
          ),
        ),
        Expanded(
          child: Text(
            bulletinText,
            style: context.res.styles.caption1
                .copyWith(fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }
}
