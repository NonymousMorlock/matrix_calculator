import 'package:flutter/material.dart';

extension WidgetExt on Widget {
  Widget expand({bool expand = true, int flex = 1}) =>
      expand ? Expanded(flex: flex, child: this) : this;
}
