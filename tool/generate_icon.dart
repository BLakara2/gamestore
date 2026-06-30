import 'dart:io';
import 'package:image/image.dart' as img;

void main() {
  const size = 1024;
  final image = img.Image(width: size, height: size, numChannels: 4);
  img.fill(image, color: img.ColorRgba8(0, 0, 0, 0));

  final cx = size / 2;
  final cy = size / 2;
  final scale = size * 0.38;

  for (int x = 0; x < size; x++) {
    for (int y = 0; y < size; y++) {
      final nx = (x - cx) / scale;
      final ny = (y - cy) / scale;
      final r2 = nx * nx + ny * ny;
      final val = (r2 - 1) * (r2 - 1) * (r2 - 1) - nx * nx * ny * ny * ny;
      if (val <= 0) {
        image.setPixelRgba(x, y, 255, 255, 255, 255);
      }
    }
  }

  final file = File('assets/icon_source.png');
  file.writeAsBytesSync(img.encodePng(image));
  print('Icon generated: assets/icon_source.png');
}
