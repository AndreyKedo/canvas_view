import 'package:flutter/widgets.dart';

extension BuildContextExt on BuildContext {
  Offset globalToLocal(Offset global) => (findRenderObject() as RenderBox).globalToLocal(global);
}
