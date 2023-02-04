import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart' hide Image;
import '../drawable/drawable.dart';
import 'canvas_state.dart';
import 'controller_impl.dart';
import 'paints_mixin.dart';

abstract class PainterController extends ValueNotifier<CanvasState> with PaintsMixin {
  PainterController(super.value, Drawable background)
      : _backgroundNotifier = ValueNotifier(background),
        _paintsNotifier = PaintsDrawable() {
    canvasNotifier = _MergingNotifier([_paintsNotifier, _backgroundNotifier]);
  }

  factory PainterController.create(
          {Color defaultBrushColor = const Color.fromARGB(255, 0, 0, 0),
          Color defaultBackgroundColor = const Color.fromARGB(255, 255, 255, 255),
          double defaultBrushThickness = 1.0,
          double defaultBrushOpacity = 1.0,
          double defaulErasetThinckness = 3.5,
          PaintToolType toolType = PaintToolType.brush,
          CanvasModes mode = CanvasModes.paint,
          Image? image,
          BoxFit fit = BoxFit.contain}) =>
      PainterControllerImpl(
          defaultBrushColor: defaultBrushColor,
          defaultBackgroundColor: defaultBackgroundColor,
          defaultBrushThickness: defaultBrushThickness,
          toolType: toolType,
          defaulErasetThinckness: defaulErasetThinckness,
          image: image,
          fit: fit,
          defaultBrushOpacity: defaultBrushOpacity,
          painterMode: mode);

  GlobalKey<State<StatefulWidget>> get repaintBoundaryKey;

  //Canvas layer notifiers
  late final PaintsDrawableBase _paintsNotifier;
  late final ValueNotifier<Drawable> _backgroundNotifier;

  //Canvas notfier
  late final ValueNotifier canvasNotifier;

  @override
  PaintsDrawableBase get paints => _paintsNotifier;

  //Get backgrond drawble layer
  Drawable get background => _backgroundNotifier.value;
  set background(Drawable background) => _backgroundNotifier.value = background;

  set backgroundColor(Color color);
  Future<void> backgroundImage(Uint8List image, {BoxFit fit = BoxFit.contain});

  CanvasModes get mode;
  set mode(CanvasModes value);

  Future<Image> renderImage([Size? size]);

  Future<Uint8List?> exportAsPNGBytes({double pixelRation = 1.0, ImageByteFormat format = ImageByteFormat.png});

  @override
  void dispose() {
    canvasNotifier.dispose();
    super.dispose();
  }
}

class _MergingNotifier extends ValueNotifier {
  _MergingNotifier(this._children) : super(null);

  final List<ChangeNotifier?> _children;

  @override
  void addListener(VoidCallback listener) {
    for (final ChangeNotifier? child in _children) {
      child?.addListener(listener);
    }
  }

  @override
  void removeListener(VoidCallback listener) {
    for (final ChangeNotifier? child in _children) {
      child?.removeListener(listener);
    }
  }

  @override
  void dispose() {
    for (final ChangeNotifier? child in _children) {
      child?.dispose();
    }
    super.dispose();
  }

  @override
  String toString() {
    return 'ValueNotifier.merge([${_children.join(", ")}])';
  }
}
