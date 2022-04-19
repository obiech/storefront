import 'package:flutter/material.dart';
import 'package:storefront_app/core/core.dart';

/// [TextField] For all search functionality across the app
/// this will be used.
///
/// A [DropezyIcons.search_alt] on the left
/// A [DropezyIcons.cross_circled] on right for clearing
///
/// It should be able to
/// * Return search text in buffers when longer than X letters
/// * Clear search text when it's more than a digit
/// * Fire callback when focus is toggled
class SearchTextField extends StatefulWidget {
  /// The leading icon
  final IconData? leadingIcon;

  /// The placeholder text
  final String? placeholder;

  /// The text change callback
  final Function(String)? onTextChanged;

  /// When the clear button should be shown
  final bool showClearButton;

  /// The clear icon
  final IconData? clearIcon;

  /// Clear Icon color
  final Color? clearIconColor;

  /// Character count before [onTextChanged] can be fired
  final int bufferSize;

  /// If the search field should be automatically focused
  final bool autoFocus;

  /// Callback for focus change
  final Function(bool)? onFocusChanged;

  /// If the search field should be enabled
  final bool isEnabled;

  /// Callback to handle the search action
  final Function(String)? onSearch;

  /// FocusNode to toggle focus
  final FocusNode? focusNode;

  /// Text Controller
  final TextEditingController? controller;

  const SearchTextField({
    Key? key,
    this.leadingIcon = DropezyIcons.search_alt,
    this.placeholder,
    this.onTextChanged,
    this.showClearButton = true,
    this.clearIcon = DropezyIcons.cross_circled,
    this.clearIconColor,
    this.bufferSize = 3,
    this.autoFocus = false,
    this.onFocusChanged,
    this.isEnabled = true,
    this.onSearch,
    this.focusNode,
    this.controller,
  }) : super(key: key);

  @override
  State<SearchTextField> createState() => _SearchTextFieldState();
}

class _SearchTextFieldState extends State<SearchTextField> {
  late TextEditingController _controller;
  late ValueNotifier<String> _textNotifier;

  @override
  void initState() {
    _controller = widget.controller ?? TextEditingController();
    _textNotifier = ValueNotifier<String>('');
    _controller.addListener(() {
      _updateValueNotifier();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;

    return Focus(
      onFocusChange: widget.onFocusChanged,
      child: TextField(
        textInputAction: TextInputAction.search,
        focusNode: widget.focusNode,
        readOnly: !widget.isEnabled,
        enabled: widget.isEnabled,
        controller: _controller,
        autofocus: widget.autoFocus,
        decoration: res.styles.roundedInputStyle.copyWith(
          hintText: widget.placeholder,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 5,
          ),
          prefixIcon:
              Icon(widget.leadingIcon, color: res.colors.black, size: 18),
          suffixIcon: AnimatedBuilder(
            animation: _textNotifier,
            builder: (_, __) {
              return _textNotifier.value.isNotEmpty && widget.showClearButton
                  ? IconButton(
                      onPressed: () {
                        _controller.clear();
                        _updateValueNotifier();
                      },
                      icon: Icon(widget.clearIcon),
                      iconSize: 18,
                      color: widget.clearIconColor ?? res.colors.grey6,
                    )
                  : const SizedBox();
            },
          ),
        ),
        onChanged: (value) {
          if (value.length >= widget.bufferSize) {
            widget.onTextChanged?.call(value);
          }
          _updateValueNotifier();
        },
        onSubmitted: (value) {
          widget.onSearch?.call(value);
          _controller.clear();
          _updateValueNotifier();
        },
        style: res.styles.caption1,
        cursorColor: res.colors.black,
      ),
    );
  }

  void _updateValueNotifier() {
    _textNotifier.value = _controller.text;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
