import 'package:flutter/material.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';

// TODO(Obiechina) Replace PlacesAutoCompleteResult.
class PlaceSuggestionTile extends StatelessWidget {
  final PlacesAutoCompleteResult place;
  final VoidCallback? onTap;
  final IconData? icon;

  const PlaceSuggestionTile({
    Key? key,
    required this.place,
    this.onTap,
    this.icon = DropezyIcons.pin_outlined,
  }) : super(key: key);

  factory PlaceSuggestionTile.address({
    required String mainAddress,
    required String description,
  }) {
    return PlaceSuggestionTile(
      place: PlacesAutoCompleteResult(
        mainText: mainAddress,
        description: description,
      ),
    );
  }

  factory PlaceSuggestionTile.history({
    required PlacesAutoCompleteResult place,
    VoidCallback? onTap,
  }) {
    return PlaceSuggestionTile(
      place: place,
      icon: DropezyIcons.history,
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Icon(
              icon,
              color: context.res.colors.black,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.mainText ?? '',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ).withLineHeight(15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.description ?? '',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ).withLineHeight(16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
