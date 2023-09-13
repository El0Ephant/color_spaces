part of 'hsv_bloc.dart';

@immutable
abstract class HsvEvent {}

class HsvInit extends HsvEvent{
  final img.Image image;
  HsvInit(this.image);
}

class HsvUpdate extends HsvEvent{
  final HSVColor color;
  HsvUpdate(this.color);
}