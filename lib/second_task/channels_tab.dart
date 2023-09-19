import 'package:color_spaces/bloc/main_bloc.dart';
import 'package:color_spaces/bloc_singletons.dart';
import 'package:color_spaces/custom_image.dart';
import 'package:color_spaces/second_task/bloc/color_channels_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChannelsTab extends StatelessWidget {
  const ChannelsTab({super.key, required this.state});

  final MainSecondTask state;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocSingletons.createColorChannelsBloc(
        state.image,
      ),
      child: BlocBuilder<ColorChannelsBloc, ColorChannelsState>(
        builder: (context, state) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return Container(
            child: switch (state) {
              ColorChannelsLoading() => const Center(
                  child: CircularProgressIndicator(),
                ),
              ColorChannelsLoaded(
                redVersion: final redVersion,
                greenVersion: final greenVersion,
                blueVersion: final blueVersion,
              ) =>
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomImage(
                          redVersion.bytes,
                          title: "Red",
                          width: screenWidth / 4,
                        ),
                        CustomImage(
                          greenVersion.bytes,
                          title: "Green",
                          width: screenWidth / 4,
                        ),
                        CustomImage(
                          blueVersion.bytes,
                          title: "Blue",
                          width: screenWidth / 4,
                        ),
                      ],
                    ),
                  ],
                ),
              ColorChannelsError() => const Center(
                  child: Text(
                    "Не удалось декодировать изображение",
                  ),
                ),
            },
          );
        },
      ),
    );
  }
}
