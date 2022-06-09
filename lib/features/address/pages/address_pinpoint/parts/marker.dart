part of '../address_pinpoint_page.dart';

class DropezyMarker extends StatelessWidget {
  const DropezyMarker({
    Key? key,
  }) : super(key: key);

  static const double markerSize = 34;
  // To ensure the marker's tip points to the current location.
  static const double markerOffset = markerSize / 2;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Transform.translate(
        offset: const Offset(0, -markerOffset),
        child: Icon(
          Icons.location_on_rounded,
          color: context.res.colors.blue,
          size: markerSize,
        ),
      ),
    );
  }
}
