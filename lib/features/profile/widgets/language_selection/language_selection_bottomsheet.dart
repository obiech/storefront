import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:storefront_app/features/home/index.dart';

import '../../../../core/core.dart';
import '../../blocs/language_selection/language_selection_cubit.dart';
import 'keys.dart';

part 'language_item_tile.dart';

const Locale _id = Locale('id', 'ID');
const Locale _en = Locale('en', 'EN');

class LanguageSelectionBottomSheet extends StatelessWidget {
  final BuildContext mainContext;

  const LanguageSelectionBottomSheet({
    Key? key,
    required this.mainContext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<LanguageSelectionCubit, LanguageSelectionState>(
      listenWhen: (previous, current) => current.localeUpdated,
      listener: (context, state) {
        Navigator.pop(context);

        /// Refresh main page to get updated string
        /// and refresh C1 with updated locale
        MainPage.refreshPage(mainContext);
      },
      child: DropezyBottomSheet.singleButton(
        marginTop: 36,
        buttonLabel: context.res.strings.saveProfile,
        buttonOnPressed: context.read<LanguageSelectionCubit>().submitLocale,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.res.strings.selectLanguage,
              style: context.res.styles.subtitle,
            ),
            const SizedBox(height: 24),
            BlocBuilder<LanguageSelectionCubit, LanguageSelectionState>(
              builder: (context, state) {
                return LanguageItemTile(
                  key: LanguageSelectionKeys.idTile,
                  flagPath: AssetsPath.icIndonesiaFlagRounded,
                  title: 'Indonesia (IDN)',
                  isActive: state.locale == _id,
                  onTap: () => context
                      .read<LanguageSelectionCubit>()
                      .onLocaleChanged(_id),
                );
              },
            ),
            const SizedBox(height: 12),
            BlocBuilder<LanguageSelectionCubit, LanguageSelectionState>(
              builder: (context, state) {
                return LanguageItemTile(
                  key: LanguageSelectionKeys.enTile,
                  flagPath: AssetsPath.icEnglishFlagRounded,
                  title: 'English (EN)',
                  isActive: state.locale == _en,
                  onTap: () => context
                      .read<LanguageSelectionCubit>()
                      .onLocaleChanged(_en),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
