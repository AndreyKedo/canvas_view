import 'dart:ui';

import 'package:canvas_view/src/extension/image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart' hide Image;

import '../drawable/drawable.dart';
import '../painter.dart';
import 'canvas_state.dart';
import 'painter_controller.dart';

class PainterControllerImpl extends PainterController {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  PainterControllerImpl(
      {required Color defaultBrushColor,
      required Color defaultBackgroundColor,
      required double defaultBrushThickness,
      required double defaultBrushOpacity,
      required double defaulErasetThinckness,
      required PaintToolType toolType,
      Image? image,
      required BoxFit fit,
      required CanvasModes painterMode})
      : super(
            CanvasState(
                brushSettings: BrushSettings(
                    color: defaultBrushColor, opacity: defaultBrushOpacity, thickness: defaultBrushThickness),
                eraseSettings: EraseSettings(thickness: defaulErasetThinckness),
                toolType: toolType,
                mode: painterMode),
            image != null
                ? ImageBackgroundDrawable(image: image, fit: fit)
                : ColorBackgroundDrawable(defaultBackgroundColor));

  @override
  GlobalKey<State<StatefulWidget>> get repaintBoundaryKey => _repaintBoundaryKey;

  @override
  CanvasModes get mode => value.mode;

  @override
  set mode(CanvasModes mode) => value = value.copyWith(mode: mode);

  @override
  set backgroundColor(Color color) {
    background = ColorBackgroundDrawable(color);
  }

  @override
  Future<void> backgroundImage(Uint8List image, {BoxFit fit = BoxFit.contain}) async {
    final imgObj = await decodeImageFromList(image);
    background = ImageBackgroundDrawable(image: imgObj, fit: fit);
  }

  @override
  Future<Image> renderImage([Size? size]) async {
    final sizeRenderBox = _repaintBoundaryKey.currentContext?.size;
    assert(sizeRenderBox == null || size == null, 'Размер холста не известен');

    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final painter = CanvasPainter(this);
    painter.paint(canvas, size ?? sizeRenderBox!);
    final width = size?.width.floor() ?? sizeRenderBox!.width.floor();
    final height = size?.height.floor() ?? sizeRenderBox!.height.floor();
    return await recorder.endRecording().toImage(width, height);
  }

  @override
  Future<Uint8List?> exportAsPNGBytes({double pixelRation = 1.0, ImageByteFormat format = ImageByteFormat.png}) async {
    final boundary = _repaintBoundaryKey.currentContext?.findRenderObject() as RenderRepaintBoundary?;

    if (boundary == null) return null;

    try {
      final image = await boundary.toImage(pixelRatio: pixelRation);
      final byteData = await image.getBytes(format: format);
      return byteData?.buffer.asUint8List();
    } catch (e) {
      FlutterError.dumpErrorToConsole(FlutterErrorDetails(exception: e));
      return null;
    }
  }
}
