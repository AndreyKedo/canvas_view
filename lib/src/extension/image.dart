import 'dart:typed_data';
import 'dart:ui';

extension ImageExt on Image {
  Future<Uint8List?> getBytes({ImageByteFormat format = ImageByteFormat.png}) async {
    final res = await toByteData(format: format);
    return res?.buffer.asUint8List();
  }
}
