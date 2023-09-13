part of 'hsv_bloc.dart';

@immutable
sealed class HsvState {}

class HsvLoading extends HsvState{

}

class HsvLoaded extends HsvState {
  final Uint8List imageBytes;
  HsvLoaded(this.imageBytes);
}
