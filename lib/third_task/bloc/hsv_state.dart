part of 'hsv_bloc.dart';

@immutable
sealed class HsvState {}

class HsvLoading extends HsvState{}

class HsvError extends HsvState{
  final String message;
  HsvError(this.message);
}

class HsvLoaded extends HsvState {
  final Uint8List imageBytes;
  HsvLoaded(this.imageBytes);
}
