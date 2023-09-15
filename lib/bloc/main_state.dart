part of 'main_bloc.dart';

@immutable
sealed class MainState {
  const MainState([this.image]);
  final ByteImage? image;
}

class MainImageLoad extends MainState {
  const MainImageLoad([super.image]);
}

class MainFirstTask extends MainState {
  const MainFirstTask(this.image);

  @override
  final ByteImage image;
}

class MainSecondTask extends MainState {
  const MainSecondTask(this.image);

  @override
  final ByteImage image;
}

class MainThirdTask extends MainState {
  const MainThirdTask(this.image);

  @override
  final ByteImage image;
}