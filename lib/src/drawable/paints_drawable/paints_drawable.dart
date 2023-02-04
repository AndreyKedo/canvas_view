import 'dart:ui';

import 'paints_base.dart';

export 'paints_base.dart';
export 'settings/brush_settings.dart';
export 'settings/erase_settings.dart';
export 'tool_types.dart';

class PaintsDrawable extends PaintsDrawableBase {
  PaintsDrawable();

  @override
  void draw(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint()..color = const Color.fromARGB(255, 0, 0, 0));
    for (MapEntry<Path, Paint> path in paths) {
      canvas.drawPath(path.key, path.value);
    }
    canvas.restore();
  }
}
