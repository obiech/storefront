import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storefront_app/core/core.dart';
import 'package:storefront_app/features/cart_checkout/index.dart';

class CartBodyEmptyFinders {
  static Finder get imageAsset => find.byWidgetPredicate(
        (widget) =>
            widget.key == CartBodyEmptyKeys.imageAsset && widget is SvgPicture,
        description: 'Empty Cart - Image Asset',
      );

  static Finder get buttonShopNow => find.byWidgetPredicate(
        (widget) =>
            widget.key == CartBodyEmptyKeys.buttonShopNow &&
            widget is DropezyButton,
        description: 'Empty Cart - Button that redirects to Home page',
      );
}
