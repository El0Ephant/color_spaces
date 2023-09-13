import 'package:color_spaces/bloc/main_bloc.dart';
import 'package:color_spaces/custom_image.dart';
import 'package:flutter/material.dart';

class ImageLoad extends StatelessWidget {
  const ImageLoad({super.key, required this.onLoad, required this.state, });

  final VoidCallback onLoad;
  final MainImageLoad state;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          onPressed: onLoad,
          child: const Text(
            "Загрузить",
          ),
        ),
        if (state.image != null)
          CustomImage(state.image!),
      ],
    );
  }
}
