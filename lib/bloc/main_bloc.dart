import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:file_picker/file_picker.dart';
import 'package:meta/meta.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainImageLoad()) {
    on<MainImageLoadStarted>((event, emit) async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
      );
      if (result != null && result.files.single.bytes != null) {
        emit(
          MainImageLoad(
            result.files.single.bytes!,
          ),
        );
      }
    });

    on<MainImageLoadRequested>((event, emit) async {
      emit(MainImageLoad(state.image));
    });

    on<MainFirstTaskRequested>((event, emit) {
      if (state.image != null) {
        emit(MainFirstTask(state.image!));
      }
    });

    on<MainSecondTaskRequested>((event, emit) {
      if (state.image != null) {
        emit(MainSecondTask(state.image!));
      }
    });

    on<MainThirdTaskRequested>((event, emit) {
      if (state.image != null) {
        emit(MainThirdTask(state.image!));
      }
    });

    on<MainSaveRequested>((event, emit) async {
      final path = await FilePicker.platform.saveFile();
      if (path != null) {
        File(path).writeAsBytes(event.image);
      }
    });
  }
}
