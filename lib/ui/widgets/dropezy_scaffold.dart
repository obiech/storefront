import 'package:flutter/material.dart';
import 'package:storefront_app/constants/dropezy_colors.dart';

/// Includes a Dropezy-themed [Scaffold] with [AppBar]
/// And a body that uses a rounded rectangle by default
///
/// [AppBar] is aware of whether it's pop-able
/// and uses Cupertino style back button
class DropezyScaffold extends StatelessWidget {
  const DropezyScaffold({
    Key? key,
    required this.child,
    required this.title,
    this.childPadding = 16.0,
    this.actions,
  }) : super(key: key);

  /// uses [Text] widget as AppBar title
  factory DropezyScaffold.textTitle({
    required Widget child,
    required String title,
    double childPadding = 16.0,
    List<Widget>? actions,
  }) {
    return DropezyScaffold(
      child: child,
      title: Text(title),
      childPadding: childPadding,
    );
  }

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
        leading: canPop ? _backButton(context) : null,
        actions: actions,
      ),
      body: Container(
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
      ),
    );
  }

  Widget _backButton(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        tooltip: MaterialLocalizations.of(context).backButtonTooltip,
        onPressed: () => Navigator.maybePop(context),
      );
}
