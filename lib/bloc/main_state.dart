part of 'main_bloc.dart';

@immutable
sealed class MainState {
  const MainState([this.image]);
  final Uint8List? image;
}

class MainImageLoad extends MainState {
  const MainImageLoad([super.image]);
}

class MainFirstTask extends MainState {
  const MainFirstTask(this.image);

  @override
  final Uint8List image;
}

class MainSecondTask extends MainState {
  const MainSecondTask(this.image);

  @override
  final Uint8List image;
}

class MainThirdTask extends MainState {
  const MainThirdTask(this.image);

  @override
  final Uint8List? image;
}