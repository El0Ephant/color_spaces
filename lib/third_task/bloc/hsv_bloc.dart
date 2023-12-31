import 'dart:math';
import 'dart:typed_data';

import 'package:color_spaces/byte_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:image/image.dart' as img;
import 'package:bloc/bloc.dart';

part 'hsv_event.dart';
part 'hsv_state.dart';



class HsvBloc extends Bloc<HsvEvent, HsvState> {
  HsvBloc() : super(const HsvLoading(_initialColor)) {
    on<HsvUpdate>(_onUpdate);
    on<HsvInit>(_onInit);
  }
  late final img.Image _originalImage;
  late final ImageExtension _originalExtension;
  static const _initialColor = HSVColor.fromAHSV(1, 180, 0.5, 0.5);
  var _pickerColor = _initialColor;

  void _onInit(HsvInit event, Emitter emit) async{
    _originalExtension = event.byteImage.extension;
    final result = await compute(_originalExtension.decoder, event.byteImage.bytes);
    if (result == null){
      emit(HsvError(_pickerColor, "Не удалось декодировать изображение"));
      return;
    }
    _originalImage = result;
    emit(HsvLoaded(_pickerColor, await compute(_originalExtension.encoder, result)));
  }

  static img.Image _applyFilter(final (img.Image, HSVColor) message){
    final (originalImage, filter) = message;
    final newImage = img.Image.from(originalImage);
    for (var pixel in newImage){
      final pixelHSV = _rgbToHsv(pixel);
      final newPixelHSV = _updateHsv(pixelHSV, filter);
      final (r, g, b) = _hsvToRgb(newPixelHSV);
      pixel.r = r;
      pixel.g = g;
      pixel.b = b;
    }
    return newImage;
  }

  void _onUpdate(HsvUpdate event, Emitter emit) async {
    _pickerColor = event.color;
    print(event.color);
    emit(HsvLoading(_pickerColor));
    final newImage = await compute(_applyFilter, (_originalImage, event.color));
    final newImageBytes = await compute(_originalExtension.encoder, newImage);
    emit(HsvLoaded(_pickerColor, newImageBytes));
  }

  static HSVColor _rgbToHsv(img.Pixel pixel){
    double r = pixel.r/255.0, g = pixel.g/255.0, b = pixel.b/255.0;
    double maxChannel = max(r, max(g, b)), minChannel = min(r, min(g, b));
    double s = maxChannel == 0 ? 0:(1 - minChannel/maxChannel), v = maxChannel;
    late double h;
    if (maxChannel == minChannel){
      h = 0;
    } else if (maxChannel == r && g >= b){
      h = 60 * (g - b)/(maxChannel - minChannel) + 0;
    } else if(maxChannel == r && g < b){
      h = 60 * (g - b)/(maxChannel - minChannel) + 360;
    } else if(maxChannel == g) {
      h = 60 * (b - r)/(maxChannel - minChannel) + 120;
    } else {
      h = 60 * (r - g)/(maxChannel - minChannel) + 240;
    }
    return HSVColor.fromAHSV(1.0, h, s, v);
  }

  static (num, num, num) _hsvToRgb(HSVColor hsvColor){
    const double ratio = 255/100;
    double h = hsvColor.hue, s = hsvColor.saturation * 100, v = hsvColor.value * 100;
    final hInd = (h ~/ 60) % 6;
    double vMin = (100 - s) * v / 100,
      a = (v - vMin) * (h % 60) / 60,
      vInc = vMin + a,
      vDec = v - a;
    v *= ratio;
    vMin *= ratio;
    vInc *= ratio;
    vDec *= ratio;
    switch (hInd){
      case 0: return (v, vInc, vMin);
      case 1: return (vDec, v, vMin);
      case 2: return (vMin, v, vInc);
      case 3: return (vMin, vDec, v);
      case 4: return (vInc, vMin, v);
      default: return (v, vMin, vDec);
    }
  }

  static HSVColor _updateHsv(HSVColor pixel, HSVColor delta){
    double h = (delta.hue - 180),
      s = delta.saturation * 2,
      v = delta.value * 2;
    return HSVColor.fromAHSV(
      1,
      (pixel.hue + h) % 360,
      min(pixel.saturation * s, 1),
      min(pixel.value * v, 1)
    );
  }

}
