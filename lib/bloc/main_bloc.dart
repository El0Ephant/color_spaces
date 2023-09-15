import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:color_spaces/byte_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;
import 'package:meta/meta.dart';

part 'main_event.dart';

part 'main_state.dart';

class MainBloc extends Bloc<MainEvent, MainState> {
  MainBloc() : super(const MainImageLoad()) {
    on<MainImageLoadStarted>((event, emit) async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        withData: true,
        type: FileType.image,
      );
      final bytes = result?.files.single.bytes;
      final filePath = result?.files.single.path;
      if (bytes != null && filePath != null) {
        emit(
          MainImageLoad(
            ByteImage(
              bytes,
              ImageExtension.fromString(
                path.extension(
                  filePath,
                ),
              ),
            ),
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
      final path = await FilePicker.platform.saveFile(
        type: FileType.image,
      );
      if (path != null) {
        File(path).writeAsBytes(event.image);
      }
    });
  }
}
