import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:storefront_app/core/core.dart';

class DropezyTextFormField extends StatelessWidget {
  final Key? fieldKey;
  final String label;
  final String hintText;
  final String? initialValue;
  final Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter>? inputFormatters;

  /// Form Field validation
  ///
  /// If null, it will only check for empty field validation
  /// ex: '${label} can not be empty'
  final FormFieldValidator? validator;

  const DropezyTextFormField({
    Key? key,
    this.fieldKey,
    required this.label,
    required this.hintText,
    this.initialValue,
    this.onChanged,
    this.onFieldSubmitted,
    this.validator,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ).withLineHeight(16),
        ),
        const SizedBox(height: 8),
        TextFormField(
          inputFormatters: inputFormatters,
          textCapitalization: textCapitalization,
          initialValue: initialValue,
          key: fieldKey,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.all(12.0),
            hintText: hintText,
            hintStyle: DropezyTextStyles.textFieldHint.copyWith(fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onChanged: onChanged,
          onFieldSubmitted: onFieldSubmitted,
          validator: validator ??
              (value) {
                if (value == null || value.isEmpty) {
                  return context.res.strings.cannotBeEmpty(label);
                }
                return null;
              },
        ),
      ],
    );
  }
}
