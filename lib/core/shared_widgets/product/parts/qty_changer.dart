part of '../product_item_card.dart';

/// Increment & Decrement product quantity
class QtyChanger extends StatefulWidget {
  /// Callback for changed quantity
  final Function(int) onQtyChanged;

  /// Callback Fired when a product's maximum
  /// available quantity is reached
  final Function(bool)? onMaxAvailableQtyChanged;

  /// Initial value
  final int value;

  /// Max value
  ///
  /// Maximum value that a user can purchase
  final int? maxValue;

  /// Stock value
  ///
  /// To fix amount in stock
  final int stock;

  /// The increment and decrement icon size
  final double iconSize;

  /// Widget, Scale factor
  final double scaleFactor;

  const QtyChanger({
    Key? key,
    required this.onQtyChanged,
    this.value = 1,
    required this.stock,
    this.iconSize = 20,
    this.scaleFactor = 1,
    this.onMaxAvailableQtyChanged,
    this.maxValue,
    // required this.stock,
  }) : super(key: key);

  @override
  State<QtyChanger> createState() => _QtyChangerState();
}

class _QtyChangerState extends State<QtyChanger> {
  late ValueNotifier<int> _valueNotifier;

  @override
  void initState() {
    _valueNotifier = ValueNotifier<int>(max(widget.value, 0));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          res.dimens.spacingXlarge * widget.scaleFactor,
        ),
        border: Border.all(color: const Color(0xFFE5E5E7)),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: RawMaterialButton(
              fillColor: res.colors.blue,
              elevation: 0,
              shape: const CircleBorder(),
              onPressed: () {
                if (_valueNotifier.value > 0) {
                  _valueNotifier.value--;
                  widget.onQtyChanged(_valueNotifier.value);

                  if (_valueNotifier.value + 1 == widget.maxValue) {
                    widget.onMaxAvailableQtyChanged?.call(false);
                  }
                }
              },
              child: Icon(
                DropezyIcons.minus,
                size: widget.iconSize * widget.scaleFactor,
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (_, value, __) {
                return Text(
                  '$value',
                  textAlign: TextAlign.center,
                  style: res.styles.subtitle.copyWith(fontSize: 11),
                );
              },
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: ValueListenableBuilder(
              valueListenable: _valueNotifier,
              builder: (_, ___, __) {
                return RawMaterialButton(
                  fillColor: !hasReachedMaximumValue
                      ? res.colors.blue
                      : res.colors.grey2,
                  elevation: 0,
                  shape: const CircleBorder(),
                  onPressed: !hasReachedMaximumValue
                      ? () {
                          if (_valueNotifier.value < widget.stock) {
                            _valueNotifier.value++;
                            widget.onQtyChanged(_valueNotifier.value);
                          }

                          if (hasReachedMaximumValue) {
                            context
                                .showToast(res.strings.thatIsAllTheStockWeHave)
                                .closed
                                .then(
                                  (_) => ScaffoldMessenger.of(context)
                                      .clearSnackBars(),
                                );

                            // Maximum Quantity Reached
                            if (isAtMaxQty) {
                              widget.onMaxAvailableQtyChanged?.call(true);
                            }
                          }
                        }
                      : () {},
                  child: Icon(
                    DropezyIcons.plus,
                    size: widget.iconSize * widget.scaleFactor,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _valueNotifier.dispose();
    super.dispose();
  }

  bool get isAtMaxQty =>
      widget.maxValue != null && widget.stock > widget.maxValue!;

  /// Check if maximum quantity has been reached
  bool get hasReachedMaximumValue {
    // If maximum product quantity is provided, compare with it
    if (isAtMaxQty) {
      return _valueNotifier.value >= widget.maxValue!;
    }

    // else compare with stock
    return _valueNotifier.value >= widget.stock;
  }
}
