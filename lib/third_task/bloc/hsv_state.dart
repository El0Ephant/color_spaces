part of 'hsv_bloc.dart';

@immutable
sealed class HsvState {
  final HSVColor pickerColor;
  const HsvState(this.pickerColor);
}

class HsvLoading extends HsvState{
  const HsvLoading(super.pickerColor);
}

class HsvError extends HsvState{
  final String message;
  const HsvError(super.pickerColor, this.message);
}

class HsvLoaded extends HsvState {
  final Uint8List imageBytes;
  const HsvLoaded(super.pickerColor, this.imageBytes);
}
