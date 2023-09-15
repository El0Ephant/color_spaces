import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:color_spaces/byte_image.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';
import 'package:image/image.dart' as img;

part 'grayscale_event.dart';

part 'grayscale_state.dart';

class GrayscaleBloc extends Bloc<GrayscaleEvent, GrayscaleState> {
  final ByteImage initialImage;

  GrayscaleBloc(this.initialImage) : super(GrayscaleLoading()) {
    on<GrayscaleInit>((event, emit) async {
      final pixels =
          await compute(initialImage.extension.decoder, initialImage.bytes);
      if (pixels == null) {
        emit(const GrayscaleError());
        return;
      }

      final firstPixels = _toGrayscale(
        pixels,
        0.299,
        0.587,
        0.114,
      );

      final secondPixels = _toGrayscale(
        pixels,
        0.2126,
        0.7152,
        0.0722,
      );

      final subtractPixels = _normalisedSubtract(
        firstPixels,
        secondPixels,
      );

      Uint8List firstVersion = await compute(
        initialImage.extension.encoder,
        firstPixels,
      );

      Uint8List secondVersion = await compute(
        initialImage.extension.encoder,
        secondPixels,
      );

      Uint8List subtract = await compute(
        initialImage.extension.encoder,
        subtractPixels,
      );

      emit(
        GrayscaleLoaded(
          ByteImage(
            firstVersion,
            initialImage.extension,
          ),
          ByteImage(
            secondVersion,
            initialImage.extension,
          ),
          ByteImage(
            subtract,
            initialImage.extension,
          ),
        ),
      );
    });
  }

  img.Image _toGrayscale(
    img.Image pixels,
    double rWeight,
    double gWeight,
    double bWeight,
  ) {
    var result = img.Image.from(pixels);
    for (var pixel in result) {
      final intensity =
          pixel.r * rWeight + pixel.g * gWeight + pixel.b * bWeight;
      pixel.r = pixel.g = pixel.b = intensity;
    }
    return result;
  }

  img.Image _subtract(
    img.Image pixels1,
    img.Image pixels2,
  ) {
    var result = img.Image.from(pixels1);
    for (var i = 0; i < result.height * result.width; i++) {
      final x = i % result.width;
      final y = i ~/ result.width;

      final rgb = (
        r: (pixels1.getPixel(x, y).r - pixels2.getPixel(x, y).r).abs(),
        g: (pixels1.getPixel(x, y).g - pixels2.getPixel(x, y).g).abs(),
        b: (pixels1.getPixel(x, y).b - pixels2.getPixel(x, y).b).abs(),
      );

      result.setPixelRgb(
        x,
        y,
        rgb.r,
        rgb.g,
        rgb.b,
      );
    }
    return result;
  }

  img.Image _normalisedSubtract(
    img.Image pixels1,
    img.Image pixels2,
  ) {
    var result = img.Image.from(pixels1);
    num maxDiff = 0;
    List<({num r, num g, num b})> rgbValues =
        List.filled(result.width * result.height, (r: 0, g: 0, b: 0));

    for (var i = 0; i < result.height * result.width; i++) {
      final x = i % result.width;
      final y = i ~/ result.width;

      final rgb = (
        r: (pixels1.getPixel(x, y).r - pixels2.getPixel(x, y).r).abs(),
        g: (pixels1.getPixel(x, y).g - pixels2.getPixel(x, y).g).abs(),
        b: (pixels1.getPixel(x, y).b - pixels2.getPixel(x, y).b).abs(),
      );

      rgbValues[i] = rgb;

      if (rgb.r > maxDiff) maxDiff = rgb.r;
      if (rgb.g > maxDiff) maxDiff = rgb.g;
      if (rgb.b > maxDiff) maxDiff = rgb.b;
    }

    for (var i = 0; i < result.height * result.width; i++) {
      final x = i % result.width;
      final y = i ~/ result.width;

      result.setPixelRgb(
        x,
        y,
        rgbValues[i].r * 255 / maxDiff,
        rgbValues[i].g * 255 / maxDiff,
        rgbValues[i].b * 255 / maxDiff,
      );
    }

    return result;
  }
}
