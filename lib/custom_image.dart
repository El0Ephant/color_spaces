import 'dart:typed_data';

import 'package:color_spaces/bloc/main_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomImage extends StatefulWidget {
  const CustomImage(this.image, {super.key, this.height, this.width});

  final Uint8List image;
  final double? height;
  final double? width;

  @override
  State<CustomImage> createState() => _CustomImageState();
}

class _CustomImageState extends State<CustomImage> {
  bool hoveredOver = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          hoveredOver = true;
        });
      },
      onExit: (_) {
        setState(() {
          hoveredOver = false;
        });
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Opacity(
            opacity: hoveredOver ? 0.5 : 1.0,
            child: Image.memory(
              widget.image,
              width: widget.width,
              height: widget.height,
            ),
          ),
          if (hoveredOver)
            ElevatedButton(
              onPressed: () {
                BlocProvider.of<MainBloc>(context).add(
                  MainSaveRequested(
                    widget.image,
                  ),
                );
              },
              child: const Icon(
                Icons.save_alt,
              ),
            ),
        ],
      ),
    );
  }
}
