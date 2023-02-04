import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../drawable/drawable.dart';
import 'canvas_state.dart';

mixin PaintsMixin on ValueNotifier<CanvasState> {
  PaintsDrawableBase get paints;

  void addPosition(Offset position) {
    paints.add(position, value.toolType, value.eraseSettings, value.brushSettings);
  }

  void updatePosition(Offset position) {
    paints.updateCurrent(position, value.toolType);
  }

  void finishDraw() => paints.endCurrent(value.toolType);

  Color get brushColor => value.brushSettings.color;
  set brushColor(Color color) {
    value = value.copyWith(brushSettings: value.brushSettings.copyWith(color: color));
  }

  double get brushThickness => value.brushSettings.thickness;
  set brushThickness(double t) {
    value = value.copyWith(brushSettings: value.brushSettings.copyWith(thickness: t));
  }

  double get eraseThickness => value.eraseSettings.thickness;
  set eraseThickness(double t) {
    value = value.copyWith(eraseSettings: value.eraseSettings.copyWith(thickness: t));
  }

  double get brushOpacity => value.brushSettings.opacity;
  set brushOpacity(double opacity) {
    value = value.copyWith(brushSettings: value.brushSettings.copyWith(opacity: opacity));
  }

  PaintToolType get currentTool => value.toolType;
  set currentTool(PaintToolType type) {
    value = value.copyWith(toolType: type);
  }

  void undoPaints() => paints.undo();

  void redoPaints() => paints.redo();

  bool get canPaintsUndo => paints.canUndo();
  bool get canPaintsRedo => paints.canRedo();
}
