import 'dart:ui';

import 'package:flutter/foundation.dart';

import '../drawable.dart';

abstract class PaintsDrawableBase extends ChangeNotifier implements Drawable {
  final List<MapEntry<Path, Paint>> _paths = <MapEntry<Path, Paint>>[];
  final List<MapEntry<Path, Paint>> _undone = <MapEntry<Path, Paint>>[];

  PaintsDrawableBase();

  double _startX = 0.0; //start X with a tap
  double _startY = 0.0; //start Y with a tap

  bool _inDrag = false;
  bool _startFlag = false;
  bool _pathFound = false;

  List<MapEntry<Path, Paint>> get paths => _paths;

  Paint _brushPaint(BrushSettings brushSettings) => Paint()
    ..color = brushSettings.color.withOpacity(brushSettings.opacity)
    ..style = PaintingStyle.stroke
    ..strokeJoin = StrokeJoin.round
    ..strokeCap = StrokeCap.round
    ..strokeWidth = brushSettings.thickness
    ..isAntiAlias = true;

  Paint _erasePaint(EraseSettings settings) => Paint()
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round
    ..blendMode = BlendMode.clear
    ..isAntiAlias = false
    ..strokeWidth = settings.thickness;

  void add(Offset startPoint, PaintToolType toolType, EraseSettings eraseSettings, BrushSettings brushSettings) {
    if (!_inDrag) {
      _inDrag = true;
      Path path = Path();
      path.moveTo(startPoint.dx, startPoint.dy);
      _startX = startPoint.dx;
      _startY = startPoint.dy;
      _startFlag = true;
      paths.add(MapEntry<Path, Paint>(
          path, toolType == PaintToolType.eraser ? _erasePaint(eraseSettings) : _brushPaint(brushSettings)));
      notifyListeners();
    }
  }

  void updateCurrent(Offset nextPoint, PaintToolType toolType) {
    if (_inDrag) {
      Path path = paths.last.key;
      path.lineTo(nextPoint.dx, nextPoint.dy);
      _startFlag = false;

      // _pathFound = false;
      // if (toolType == PaintToolType.brush) {
      //   Path path = paths.last.key;
      //   path.lineTo(nextPoint.dx, nextPoint.dy);
      //   _startFlag = false;
      // } else {
      //   Path path = paths.last.key;
      //   path.lineTo(nextPoint.dx, nextPoint.dy);
      //   _startFlag = false;
      //   for (int i = 0; i < paths.length; i++) {
      //     _pathFound = false;
      //     for (double x = nextPoint.dx - eraseArea; x <= nextPoint.dx + eraseArea; x++) {
      //       for (double y = nextPoint.dy - eraseArea; y <= nextPoint.dy + eraseArea; y++) {
      //         if (paths[i].key.contains(Offset(x, y))) {
      //           _undone.add(paths.removeAt(i));
      //           i--;
      //           _pathFound = true;
      //           break;
      //         }
      //       }
      //       if (_pathFound) {
      //         break;
      //       }
      //     }
      //   }
      // }
      notifyListeners();
    }
  }

  void endCurrent(PaintToolType toolType) {
    Path path = paths.last.key;
    if ((_startFlag) && (toolType == PaintToolType.brush)) {
      path.addOval(Rect.fromCircle(center: Offset(_startX, _startY), radius: 1.0));
      _startFlag = false;
    }
    _inDrag = false;
    notifyListeners();
  }

  void undo() {
    if (!_inDrag && canUndo()) {
      _undone.add(paths.removeLast());
      notifyListeners();
    }
  }

  void redo() {
    if (!_inDrag && canRedo()) {
      paths.add(_undone.removeLast());
      notifyListeners();
    }
  }

  void clear() {
    if (!_inDrag) {
      paths.clear();
      _undone.clear();
      notifyListeners();
    }
  }

  bool canUndo() => paths.isNotEmpty;
  bool canRedo() => _undone.isNotEmpty;

  @override
  bool operator ==(Object other) {
    return other is PaintsDrawableBase && hashCode == other.hashCode;
  }

  @override
  int get hashCode => Object.hash(Object.hashAll(_paths), Object.hashAll(_undone));
}
