import 'package:color_spaces/byte_image.dart';
import 'package:color_spaces/first_task/bloc/grayscale_bloc.dart';
import 'package:color_spaces/third_task/bloc/hsv_bloc.dart';

abstract class BlocSingletons {
  static int? _grayscaleHashcode;
  static GrayscaleBloc? _grayscaleBloc;

  static GrayscaleBloc createGrayscaleBloc(ByteImage initialImage) {
    if (initialImage.hashCode == _grayscaleHashcode && _grayscaleBloc != null) {
      return _grayscaleBloc!;
    }
    else {
      _grayscaleHashcode = initialImage.hashCode;
      _grayscaleBloc = GrayscaleBloc(initialImage)..add(GrayscaleInit());
      return _grayscaleBloc!;
    }
  }

  static int? _hsvHashcode;
  static HsvBloc? _hsvBloc;

  static HsvBloc createHsvBloc(ByteImage initialImage) {
    if (initialImage.hashCode == _hsvHashcode && _hsvBloc != null) {
      return _hsvBloc!;
    }
    else {
      _hsvHashcode = initialImage.hashCode;
      _hsvBloc = HsvBloc()..add(HsvInit(initialImage));
      return _hsvBloc!;
    }
  }

  static void closeHsvBloc() => _hsvBloc?.close();
}