import 'dart:ui';

import 'package:flutter/rendering.dart';

import 'drawable_interface.dart';

class ImageBackgroundValue {
  final Image image;
  final BoxFit fit;

  ImageBackgroundValue({required this.image, required this.fit});

  ImageBackgroundValue copyWith({Image? image, BoxFit? fit}) =>
      ImageBackgroundValue(image: image ?? this.image, fit: this.fit);

  @override
  int get hashCode => Object.hash(image, fit);

  @override
  bool operator ==(Object other) {
    return other is ImageBackgroundValue && hashCode == other.hashCode;
  }
}

class ImageBackgroundDrawable extends Drawable {
  final Image image;
  final BoxFit fit;
  ImageBackgroundDrawable({required this.image, required this.fit});

  void _paintImage(Rect outputRect, Canvas canvas, Paint paint) {
    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());
    final FittedSizes sizes = applyBoxFit(fit, imageSize, outputRect.size);
    final Rect inputSubrect = Alignment.center.inscribe(sizes.source, Offset.zero & imageSize);
    final Rect outputSubrect = Alignment.center.inscribe(sizes.destination, outputRect);
    canvas.drawImageRect(image, inputSubrect, outputSubrect, paint);
  }

  @override
  void draw(Canvas canvas, Size size) {
    canvas.saveLayer(Offset.zero & size, Paint()..color = const Color.fromARGB(255, 0, 0, 0));
    final outputRectView = Rect.fromPoints(Offset.zero, Offset(size.width, size.height));
    _paintImage(outputRectView, canvas, Paint());
    canvas.restore();
  }
}
