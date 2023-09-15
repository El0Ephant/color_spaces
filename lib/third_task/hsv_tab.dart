import 'dart:typed_data';

import 'package:color_spaces/byte_image.dart';
import 'package:color_spaces/custom_image.dart';
import 'package:color_spaces/third_task/bloc/hsv_bloc.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class HsvTab extends StatefulWidget {
  const HsvTab({Key? key, required this.image}) : super(key: key);
  final ByteImage image;

  @override
  State<HsvTab> createState() => _HsvTabState();
}

class _HsvTabState extends State<HsvTab> {

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider<HsvBloc>(
        create: (context) => HsvBloc()..add(HsvInit(widget.image)),
        child: BlocBuilder<HsvBloc, HsvState>(
          buildWhen: (previous, current) => previous is HsvError || current is HsvError,
          builder: (context, state) => switch (state) {
            HsvError(message: var message) => Center(child: Text(message),),
            _ => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Center(
                      child: BlocBuilder<HsvBloc, HsvState>(
                        builder: (context, state) => switch (state){
                          HsvLoading() => const CircularProgressIndicator(),
                          HsvLoaded(imageBytes: final imageBytes) => CustomImage(imageBytes),
                          _ => const SizedBox.shrink()
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 50,),
                  SizedBox(
                    height: MediaQuery.of(context).size.height - 170,
                    child: Center(
                      child: SizedBox(
                        height: 230,
                        child: BlocBuilder<HsvBloc, HsvState>(
                          builder: (context, state) {
                            return ColorPicker(
                              color: state.pickerColor.toColor(),
                              pickersEnabled: const {
                                ColorPickerType.both: false,
                                ColorPickerType.primary: false,
                                ColorPickerType.accent: false,
                                ColorPickerType.bw: false,
                                ColorPickerType.custom: false,
                                ColorPickerType.wheel: true,
                              },
                              enableTonalPalette: false,
                              enableShadesSelection: false,
                              onColorChanged: (_) {} ,
                              onColorChangeEnd: (color) {
                                context.read<HsvBloc>().add(HsvUpdate(HSVColor.fromColor(color)));
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          }
        ),
      ),
    );
  }
}
