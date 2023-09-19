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
  );

  final ByteImage redVersion;
  final ByteImage greenVersion;
  final ByteImage blueVersion;
}

class ColorChannelsError extends ColorChannelsState {
  const ColorChannelsError();
}
