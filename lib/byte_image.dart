import 'dart:typed_data';

import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

class ByteImage {
  const ByteImage(this.bytes, this.extension);

  final Uint8List bytes;
  final ImageExtension extension;
}

typedef Decoder = img.Image? Function(Uint8List bytes);
typedef Encoder = img.Image? Function(Uint8List bytes);

enum ImageExtension {
  jpg,
  png;

  static ImageExtension fromString(String title) {
    return switch (title) {
      ".jpg" => ImageExtension.jpg,
      ".png" => ImageExtension.png,
      String() => throw UnsupportedFileTypeException(),
    };
  }

  Decoder get decoder => switch (this) {
        ImageExtension.jpg => img.decodeJpg,
        ImageExtension.png => img.decodePng,
      };

  dynamic get encoder => switch (this) {
        ImageExtension.jpg => img.encodeJpg,
        ImageExtension.png => img.encodePng,
      };
}

class UnsupportedFileTypeException implements Exception {}

