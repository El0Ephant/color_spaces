part of 'color_channels_bloc.dart';

@immutable
sealed class ColorChannelsState {
  const ColorChannelsState();
}

class ColorChannelsLoading extends ColorChannelsState {}

class ColorChannelsLoaded extends ColorChannelsState {
  const ColorChannelsLoaded(
    this.redVersion,
    this.greenVersion,
    this.blueVersion,
    this.redPixels,
    this.greenPixels,
    this.bluePixels,
  );

  final ByteImage redVersion;
  final ByteImage greenVersion;
  final ByteImage blueVersion;
  final List<num> redPixels;
  final List<num> greenPixels;
  final List<num> bluePixels;
}

class ColorChannelsError extends ColorChannelsState {
  const ColorChannelsError();
}
