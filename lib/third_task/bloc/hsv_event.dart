part of 'hsv_bloc.dart';

@immutable
abstract class HsvEvent {}

class HsvInit extends HsvEvent{
  final Uint8List imageBytes;
  HsvInit(this.imageBytes);
}

class HsvUpdate extends HsvEvent{
  final HSVColor color;
  HsvUpdate(this.color);
}