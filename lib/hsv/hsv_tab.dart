import 'package:color_spaces/hsv/bloc/hsv_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image/image.dart' as img;
import 'package:flutter_bloc/flutter_bloc.dart';


class HsvTab extends StatefulWidget {
  const HsvTab({Key? key, required this.image}) : super(key: key);
  final img.Image image;

  @override
  State<HsvTab> createState() => _HsvTabState();
}

class _HsvTabState extends State<HsvTab> {
  final _initColor = const HSVColor.fromAHSV(1, 180, 0.5, 0.5).toColor();
  late Color _hsvSelected = _initColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: BlocProvider<HsvBloc>(
        create: (context) => HsvBloc()..add(HsvInit(widget.image)),
        child: SizedBox(
          width: 600,
          child: Column(
            children: [
              SizedBox(
                height: 400,
                child: BlocBuilder<HsvBloc, HsvState>(
                  builder: (context, state) => switch (state){
                    HsvLoading() => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    HsvLoaded(imageBytes: final imageBytes) => Image.memory(imageBytes),
                  },
                ),
              ),
              SizedBox(
                child: SlidePicker(
                  showParams: false,
                  sliderSize: const Size(600, 40),
                  onColorChanged: (Color color) {
                    _hsvSelected = color;
                  },
                  showIndicator: false,
                  colorModel: ColorModel.hsv,
                  enableAlpha: false,
                  displayThumbColor: false,
                  pickerColor: _hsvSelected,
                ),
              ),
              BlocBuilder<HsvBloc, HsvState>(
                builder: (context, state) {
                  return ElevatedButton(
                    onPressed: switch (state){
                      HsvLoading() => null,
                      HsvLoaded() => () {
                        context.read<HsvBloc>().add(HsvUpdate(HSVColor.fromColor(_hsvSelected)));
                      },
                    },
                    child: const Text("Применить")
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
