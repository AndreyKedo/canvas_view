class EraseSettings {
  final double opacity; //TODO: do not use
  final double thickness;

  const EraseSettings({this.opacity = 1, this.thickness = 6});

  EraseSettings copyWith({double? opacity, double? thickness}) =>
      EraseSettings(opacity: opacity ?? this.opacity, thickness: thickness ?? this.thickness);

  @override
  bool operator ==(Object other) {
    return other is EraseSettings && hashCode == other.hashCode;
  }

  @override
  int get hashCode => Object.hash(opacity, thickness);
}
