import '../drawable/drawable.dart';

enum CanvasModes { paint, interactive }

class CanvasState {
  final BrushSettings brushSettings;
  final EraseSettings eraseSettings;
  final PaintToolType toolType;
  final CanvasModes mode;
  const CanvasState(
      {this.brushSettings = const BrushSettings(),
      this.eraseSettings = const EraseSettings(),
      this.toolType = PaintToolType.brush,
      this.mode = CanvasModes.paint});

  CanvasState copyWith(
          {BrushSettings? brushSettings, EraseSettings? eraseSettings, PaintToolType? toolType, CanvasModes? mode}) =>
      CanvasState(
          brushSettings: brushSettings ?? this.brushSettings,
          eraseSettings: eraseSettings ?? this.eraseSettings,
          toolType: toolType ?? this.toolType,
          mode: mode ?? this.mode);

  @override
  bool operator ==(Object other) {
    return other is CanvasState && hashCode == other.hashCode;
  }

  @override
  int get hashCode => Object.hash(mode, brushSettings, eraseSettings, toolType);
}
