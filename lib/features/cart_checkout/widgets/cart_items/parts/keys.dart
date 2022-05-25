part of '../cart_items_section.dart';

class CartItemsSectionKeys {
  CartItemsSectionKeys._internal(); // prevent initialization

  static const _base = 'CartItemsSection';

  /// to generate unique key for Qty Changer in [CartItemTile].
  static ValueKey qtyChanger(String variantId) =>
      ValueKey('${_base}_${variantId}_QtyChanger');

  /// to generate unique key for Delete Button in [CartItemTile].
  static ValueKey deleteButton(String variantId) =>
      ValueKey('${_base}_${variantId}_DeleteButton');
}
