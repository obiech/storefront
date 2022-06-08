import 'package:flutter/material.dart';
import 'package:places_service/places_service.dart';
import 'package:storefront_app/core/core.dart';

class PlaceSuggestionTile extends StatelessWidget {
  final PlacesAutoCompleteResult place;

  const PlaceSuggestionTile({
    Key? key,
    required this.place,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          DropezyIcons.pin_outlined,
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
    );
  }
}
