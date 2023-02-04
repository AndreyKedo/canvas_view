import 'dart:ui';

import 'drawable_interface.dart';

class ColorBackgroundDrawable extends Drawable {
  final Paint settings;

  ColorBackgroundDrawable(Color color) : settings = Paint()..color = color;

  @override
  void draw(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, settings);
    canvas.drawRect(Rect.largest, settings..blendMode = BlendMode.src);
    canvas.restore();
  }
}
