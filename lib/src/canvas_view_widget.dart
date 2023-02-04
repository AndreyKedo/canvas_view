import 'package:flutter/gestures.dart';
import 'package:flutter/widgets.dart' hide Image;
import 'extension/build_context.dart';
import 'controller/painter_controller.dart';
import 'painter.dart';

class CanvasView extends StatelessWidget {
  final PainterController painterController;

  CanvasView(this.painterController) : super(key: ValueKey<PainterController>(painterController));

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: painterController,
      builder: (context, child) => InteractiveViewer(
        panEnabled: painterController.mode == CanvasModes.interactive,
        scaleEnabled: painterController.mode == CanvasModes.interactive,
        child: Builder(
          builder: (context) => RawGestureDetector(
              gestures: painterController.mode == CanvasModes.paint
                  ? {
                      _DragGestureDetector: GestureRecognizerFactoryWithHandlers<_DragGestureDetector>(
                          () => _DragGestureDetector(
                              onHorizontalDragDown: (Offset globalPosition) => _onPanStart(context, globalPosition),
                              onHorizontalDragUpdate: (Offset globalPosition) => _onPanUpdate(context, globalPosition),
                              onHorizontalDragUp: _onPanEnd),
                          (_) {})
                    }
                  : {},
              child: RepaintBoundary(
                key: painterController.repaintBoundaryKey,
                child: ClipRRect(
                  child: CustomPaint(
                    key: const ValueKey('canvas'),
                    willChange: true,
                    isComplex: true,
                    size: Size.infinite,
                    painter: CanvasPainter(painterController),
                  ),
                ),
              )),
        ),
      ),
    );
  }

  void _onPanStart(BuildContext context, Offset globalPosition) {
    final position = context.globalToLocal(globalPosition);
    painterController.addPosition(position);
  }

  void _onPanUpdate(BuildContext context, Offset globalPosition) {
    final position = context.globalToLocal(globalPosition);
    painterController.updatePosition(position);
  }

  void _onPanEnd() {
    painterController.finishDraw();
  }
}

class _DragGestureDetector extends OneSequenceGestureRecognizer {
  _DragGestureDetector({
    required this.onHorizontalDragDown,
    required this.onHorizontalDragUpdate,
    required this.onHorizontalDragUp,
  });

  final ValueSetter<Offset> onHorizontalDragDown;
  final ValueSetter<Offset> onHorizontalDragUpdate;
  final VoidCallback onHorizontalDragUp;

  bool _isTrackingGesture = false;

  @override
  void addPointer(PointerEvent event) {
    if (!_isTrackingGesture) {
      resolve(GestureDisposition.accepted);
      startTrackingPointer(event.pointer);
      _isTrackingGesture = true;
    } else {
      stopTrackingPointer(event.pointer);
    }
  }

  @override
  void handleEvent(PointerEvent event) {
    if (event is PointerDownEvent) {
      onHorizontalDragDown(event.position);
    } else if (event is PointerMoveEvent) {
      onHorizontalDragUpdate(event.position);
    } else if (event is PointerUpEvent) {
      onHorizontalDragUp();
      stopTrackingPointer(event.pointer);
      _isTrackingGesture = false;
    }
  }

  @override
  String get debugDescription => '_DragGestureDetector';

  @override
  void didStopTrackingLastPointer(int pointer) {}
}
