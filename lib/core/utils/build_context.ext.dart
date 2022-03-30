import 'package:flutter/cupertino.dart';

import '../../res/resources.dart';

extension BuildContextX on BuildContext {
  Resources get res => Resources.of(this);
}
