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

    var redPixelsRaw =
        await compute((_) => pixels.map((e) => e.r).toList(), null);
    var redPixels = List.filled(256, 0);
    for (var i = 0; i < 256; i++) {
      redPixels[i] = redPixelsRaw.where((el) => el == i).length;
    }

    var greenPixelsRaw =
        await compute((_) => pixels.map((e) => e.g).toList(), null);
    var greenPixels = List.filled(256, 0);
    for (var i = 0; i < 256; i++) {
      greenPixels[i] = greenPixelsRaw.where((el) => el == i).length;
    }

    var bluePixelsRaw =
        await compute((_) => pixels.map((e) => e.b).toList(), null);
    var bluePixels = List.filled(256, 0);
    for (var i = 0; i < 256; i++) {
      bluePixels[i] = bluePixelsRaw.where((el) => el == i).length;
    }

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
