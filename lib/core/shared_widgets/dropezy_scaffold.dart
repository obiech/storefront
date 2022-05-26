import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../utils/_exporter.dart';

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
/// In total it has a distance of 24 units from left side of page
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
    this.header,
  }) : super(key: key);

  /// uses [Text] widget as AppBar title
  factory DropezyScaffold.textTitle({
    Widget? header,
    required String title,
    required Widget child,
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
      header: header,
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

  /// Widget that will be shown below app bar
  /// and above the white rounded body
  final Widget? header;

  final bool useRoundedBody;
  final Widget child;
  final Widget title;
  final EdgeInsets? childPadding;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    late bool canPop;
    if (kTestMode) {
      // Some tests do not wrap a StackRouter around the Page
      // Hence we are using te default Flutter ModalRoute to avoid
      // breaking the tests.
      final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
      canPop = parentRoute?.canPop ?? false;
    } else {
      final routeController = RouterScope.of(context).controller;

      // routeController.canNavigateBack still returns true if we are in MainPage
      // so we need to explicitly disable pop on Tabs inside MainPage
      canPop =
          routeController is! TabsRouter && routeController.canNavigateBack;
    }

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
          ? Column(
              children: [
                header ?? const SizedBox.shrink(),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(
                        res.dimens.bottomSheetHorizontalPadding,
                      ),
                      topRight: Radius.circular(
                        res.dimens.bottomSheetHorizontalPadding,
                      ),
                    ),
                    child: Container(
                      color: bodyColor,
                      width: double.infinity,
                      height: double.infinity,
                      alignment: bodyAlignment ?? Alignment.center,
                      padding: childPadding,
                      child: child,
                    ),
                  ),
                ),
              ],
            )
          : child,
    );
  }

  Widget _backButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => context.router.pop(),
      );
}
