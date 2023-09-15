part of 'grayscale_bloc.dart';

@immutable
sealed class GrayscaleState {
  const GrayscaleState();
}

class GrayscaleLoading extends GrayscaleState {}

class GrayscaleLoaded extends GrayscaleState {
  const GrayscaleLoaded(
    this.firstVersion,
    this.secondVersion,
    this.subtraction,
  );

  final ByteImage firstVersion;
  final ByteImage secondVersion;
  final ByteImage subtraction;
}

class GrayscaleError extends GrayscaleState {
  const GrayscaleError();
}
