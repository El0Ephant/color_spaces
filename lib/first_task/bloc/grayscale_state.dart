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
    this.firstIntensity,
    this.secondIntensity,
  );

  final ByteImage firstVersion;
  final ByteImage secondVersion;
  final ByteImage subtraction;
  final List<int> firstIntensity;
  final List<int> secondIntensity;
}

class GrayscaleError extends GrayscaleState {
  const GrayscaleError();
}
