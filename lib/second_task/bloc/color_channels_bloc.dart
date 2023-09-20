import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:color_spaces/byte_image.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

part 'color_channels_event.dart';
part 'color_channels_state.dart';

class ColorChannelsBloc extends Bloc<ColorChannelsEvent, ColorChannelsState> {
  final ByteImage initialImage;

  ColorChannelsBloc(this.initialImage) : super(ColorChannelsLoading()) {
    on<ColorChannelsInit>(_onInit);
  }

  void _onInit(ColorChannelsInit event, Emitter emit) async {
    final pixels =
        await compute(initialImage.extension.decoder, initialImage.bytes);
    if (pixels == null) {
      emit(const ColorChannelsError());
      return;
    }

    var redImage = img.Image.from(pixels);
    for (var pixel in redImage) {
      pixel.g = pixel.b = 0;
    }

    var greenImage = img.Image.from(pixels);
    for (var pixel in greenImage) {
      pixel.r = pixel.b = 0;
    }

    var blueImage = img.Image.from(pixels);
    for (var pixel in blueImage) {
      pixel.g = pixel.r = 0;
    }

    Uint8List redVersion = await compute(
      initialImage.extension.encoder,
      redImage,
    );

    Uint8List greenVersion = await compute(
      initialImage.extension.encoder,
      greenImage,
    );

    Uint8List blueVersion = await compute(
      initialImage.extension.encoder,
      blueImage,
    );

var asyncList = [
compute((pixels) {
  var redPixels = List.filled(256, 0);
  for (var el in pixels.map((e) => e.r.toInt())) {
    redPixels[el] += 1;
  }
  return redPixels;
}, pixels),
compute((pixels) {
  var greenPixels = List.filled(256, 0);
  for (var el in pixels.map((e) => e.g.toInt())) {
    greenPixels[el] += 1;
  }
  return greenPixels;
}, pixels),
compute((pixels) {
  var bluePixels = List.filled(256, 0);
  for (var el in pixels.map((e) => e.b.toInt())) {
    bluePixels[el] += 1;
  }
  return bluePixels;
}, pixels),
];
final[redPixels, greenPixels, bluePixels] = await Future.wait(asyncList);

    emit(
      ColorChannelsLoaded(
        ByteImage(
          redVersion,
          initialImage.extension,
        ),
        ByteImage(
          greenVersion,
          initialImage.extension,
        ),
        ByteImage(
          blueVersion,
          initialImage.extension,
        ),
        redPixels,
        greenPixels,
        bluePixels,
      ),
    );
  }
}
