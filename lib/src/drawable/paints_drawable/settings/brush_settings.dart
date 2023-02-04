import 'dart:ui';

class BrushSettings {
  final Color color;
  final double opacity;
  final double thickness;

  const BrushSettings({this.color = const Color.fromRGBO(255, 255, 255, 1), this.opacity = 1, this.thickness = 1});

  BrushSettings copyWith({Color? color, double? opacity, double? thickness}) => BrushSettings(
      color: color ?? this.color, opacity: opacity ?? this.opacity, thickness: thickness ?? this.thickness);

  @override
  bool operator ==(Object other) {
    return other is BrushSettings && hashCode == other.hashCode;
  }

  @override
  int get hashCode => Object.hash(color, opacity, thickness);
}
