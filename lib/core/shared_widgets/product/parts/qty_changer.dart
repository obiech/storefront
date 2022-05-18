part of '../product_item_card.dart';

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

  /// Widget, Scale factor
  final double scaleFactor;

  const QtyChanger({
    Key? key,
    required this.onQtyChanged,
    this.value = 1,
    required this.maxValue,
    this.iconSize = 20,
    this.scaleFactor = 1,
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
            child: FloatingActionButton(
              backgroundColor: res.colors.blue,
              elevation: 0,
              onPressed: () {
                if (_valueNotifier.value > 0) {
                  _valueNotifier.value--;
                  widget.onQtyChanged(_valueNotifier.value);
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
            child: FloatingActionButton(
              backgroundColor: res.colors.blue,
              elevation: 0,
              onPressed: () {
                if (_valueNotifier.value < widget.maxValue) {
                  _valueNotifier.value++;
                  widget.onQtyChanged(_valueNotifier.value);
                } else {
                  context
                      .showToast(res.strings.thatIsAllTheStockWeHave)
                      .closed
                      .then(
                        (_) => ScaffoldMessenger.of(context).clearSnackBars(),
                      );
                }
              },
              child: Icon(
                DropezyIcons.plus,
                size: widget.iconSize * widget.scaleFactor,
              ),
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
}