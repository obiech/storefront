import 'package:flutter/material.dart';
import 'package:storefront_app/constants/dropezy_colors.dart';

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
/// Setting [useWhiteBody] to [true] will use a Rounded White Rectangle
/// as the parent of the [child].
class DropezyScaffold extends StatelessWidget {
  const DropezyScaffold({
    Key? key,
    required this.useWhiteBody,
    required this.child,
    required this.title,
    this.childPadding = 24.0,
    this.actions,
  }) : super(key: key);

  /// uses [Text] widget as AppBar title
  factory DropezyScaffold.textTitle({
    required Widget child,
    required String title,
    bool useWhiteBody = true,
    double childPadding = 24.0,
    List<Widget>? actions,
  }) {
    return DropezyScaffold(
      useWhiteBody: useWhiteBody,
      child: child,
      title: Text(title),
      childPadding: childPadding,
      actions: actions,
    );
  }

  final bool useWhiteBody;
  final Widget child;
  final Widget title;
  final double childPadding;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    return Scaffold(
      appBar: AppBar(
        title: title,
        leading: canPop
            ? Container(
                margin: const EdgeInsets.only(
                  left: 16,
                  right: 12,
                ),
                child: _backButton(context),
              )
            : null,
        leadingWidth: canPop ? 40 : null,
        actions: actions,
      ),
      resizeToAvoidBottomInset: true,
      body: useWhiteBody
          ? Container(
              decoration: const BoxDecoration(
                color: DropezyColors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24.0),
                  topRight: Radius.circular(24.0),
                ),
              ),
              width: double.infinity,
              height: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.only(
                left: childPadding,
                right: childPadding,
                top: childPadding,
              ),
              child: child,
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
