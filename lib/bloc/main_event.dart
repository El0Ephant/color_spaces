part of 'main_bloc.dart';

@immutable
sealed class MainEvent {
  const MainEvent();
}

class MainImageLoadStarted extends MainEvent {
  const MainImageLoadStarted();
}
class MainImageLoadRequested extends MainEvent {
  const MainImageLoadRequested();
}
class MainFirstTaskRequested extends MainEvent {
  const MainFirstTaskRequested();
}
class MainSecondTaskRequested extends MainEvent {
  const MainSecondTaskRequested();
}
class MainThirdTaskRequested extends MainEvent {
  const MainThirdTaskRequested();
}

class MainSaveRequested extends MainEvent {
  const MainSaveRequested(this.image);
  final Uint8List image;
}
