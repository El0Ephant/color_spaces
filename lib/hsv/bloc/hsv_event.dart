part of 'hsv_bloc.dart';

@immutable
abstract class HsvEvent {}

class HsvInit extends HsvEvent{

}

class HsvUpdate extends HsvEvent{
  final HSVColor color;
  HsvUpdate(this.color);
}