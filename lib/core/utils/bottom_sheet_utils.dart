import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:storefront_app/core/core.dart';

typedef BottomSheetBuilder = Widget Function(BuildContext);

/// Convenience method for displaying a Bottom Sheet
/// with a title of 'Error'
/// and [errorMsg] as the content
void showErrorBottomSheet(BuildContext context, String errorMsg) {
  showDropezyBottomSheet(context, (_) {
    return DropezyBottomSheet.genericError(context: context, message: errorMsg);
  });
}

/// Convenience method for displaying a Bottom Sheet
/// Uses these presets:
/// - [enableDrag] -- true
/// - [expand] -- false
/// - [backgroundColor] -- [Colors.transparent] to disable the background
///   drawn by [BottomSheet].
/// - [barrierColor] -- the overlay color for [Widget] behind.
///
void showDropezyBottomSheet(BuildContext context, BottomSheetBuilder builder) {
  showMaterialModalBottomSheet(
    enableDrag: true,
    expand: false,
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: const Color(0x80000000),
    builder: builder,
  );
}
