part of 'product_item_card.dart';

/// Increment & Decrement product quantity
class QtyChanger extends StatefulWidget {
  /// Callback for changed quantity
  final Function(int) onQtyChanged;

  /// Initial value
  final int value;

  /// Max value
  ///
  /// To fix amount in stock
  final int maxValue;

  /// The increment and decrement icon size
  final double iconSize;

  const QtyChanger({
    Key? key,
    required this.onQtyChanged,
    this.value = 1,
    required this.maxValue,
    this.iconSize = 20,
  }) : super(key: key);

  @override
  State<QtyChanger> createState() => _QtyChangerState();
}

class _QtyChangerState extends State<QtyChanger> {
  late ValueNotifier<int> _valueNotifier;

  @override
  void initState() {
    _valueNotifier = ValueNotifier<int>(widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final res = context.res;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(res.dimens.spacingLarge),
        border: Border.all(color: const Color(0xFFE5E5E7)),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 1,
            child: FloatingActionButton(
              backgroundColor: res.colors.blue,
              elevation: 0,
              onPressed: () {
                if (_valueNotifier.value >= 2) {
                  _valueNotifier.value--;
                }
              },
              child: Icon(
                DropezyIcons.minus,
                size: widget.iconSize,
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
            child: FloatingActionButton(
              backgroundColor: res.colors.blue,
              elevation: 0,
              onPressed: () {
                if (_valueNotifier.value < widget.maxValue) {
                  _valueNotifier.value++;
                }
              },
              child: Icon(
                DropezyIcons.plus,
                size: widget.iconSize,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
