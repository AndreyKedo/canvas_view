import 'package:flutter/rendering.dart';

import 'controller/painter_controller.dart';

class CanvasPainter extends CustomPainter {
  final PainterController controller;

  CanvasPainter(this.controller) : super(repaint: controller.canvasNotifier);

  int repaintCount = 0;

  @override
  void paint(Canvas canvas, Size size) {
    for (var drawable in [controller.background, controller.paints]) {
      drawable.draw(canvas, size);
    }
  }

  @override
  bool shouldRepaint(covariant CanvasPainter oldDelegate) => false;
}
