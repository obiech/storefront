import 'package:flutter/material.dart';

import '../utils/build_context.ext.dart';

/// Includes a Dropezy-themed [Scaffold] with [AppBar]
/// And a body that uses a rounded rectangle by default
///
/// [AppBar] is aware of whether it's pop-able
/// and uses Cupertino style back button
///
/// Leading [IconButton] for Navigation has the following dimensions:
/// - Content padding of [EdgeInsets.all(8.0)]
/// - Left Margin of 16 units
/// - Right Margin of 12 units
///
/// In total it has a distance of 24 units from left side of screen
/// And a distance of 20 units from [AppBar] title
///
/// Setting [useRoundedBody] to [true] will use a Rounded White Rectangle
/// as the parent of the [child].
class DropezyScaffold extends StatelessWidget {
  const DropezyScaffold({
    Key? key,
    required this.useRoundedBody,
    required this.child,
    required this.title,
    this.childPadding,
    this.actions,
    this.centerTitle = false,
    this.bodyColor = Colors.white,
    this.toolbarHeight,
    this.bodyAlignment,
  }) : super(key: key);

  /// uses [Text] widget as AppBar title
  factory DropezyScaffold.textTitle({
    required Widget child,
    required String title,
    bool useWhiteBody = true,
    bool centerTitle = false,
    EdgeInsets? childPadding,
    bodyColor = Colors.white,
    List<Widget>? actions,
    double? toolBarHeight,
    Alignment? bodyAlignment,
  }) {
    return DropezyScaffold(
      useRoundedBody: useWhiteBody,
      title: Text(title),
      childPadding: childPadding,
      centerTitle: centerTitle,
      bodyColor: bodyColor,
      actions: actions,
      toolbarHeight: toolBarHeight,
      bodyAlignment: bodyAlignment,
      child: child,
    );
  }

  /// Set to [true] when the [AppBar] title
  /// should be centered
  final bool centerTitle;

  /// Set the [Color] of the rounded [Scaffold] body
  final Color bodyColor;

  /// Set a custom toolbar height
  final double? toolbarHeight;

  final Alignment? bodyAlignment;

  final bool useRoundedBody;
  final Widget child;
  final Widget title;
  final EdgeInsets? childPadding;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;
    final res = context.res;

    return Scaffold(
      appBar: AppBar(
        title: title,
        centerTitle: centerTitle,
        toolbarHeight: toolbarHeight,
        leading: canPop
            ? Container(
                margin: EdgeInsets.only(
                  left: res.dimens.spacingLarge,
                ),
                child: _backButton(context),
              )
            : null,
        leadingWidth: canPop ? res.dimens.leadingWidth : null,
        actions: actions,
      ),
      resizeToAvoidBottomInset: true,
      body: useRoundedBody
          ? ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft:
                    Radius.circular(res.dimens.bottomSheetHorizontalPadding),
                topRight:
                    Radius.circular(res.dimens.bottomSheetHorizontalPadding),
              ),
              child: Container(
                color: bodyColor,
                width: double.infinity,
                height: double.infinity,
                alignment: bodyAlignment ?? Alignment.center,
                padding: childPadding,
                child: child,
              ),
            )
          : child,
    );
  }

  Widget _backButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => Navigator.maybePop(context),
      );
}
