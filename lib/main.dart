import 'dart:io';

import 'package:color_spaces/hsv/hsv_tab.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;


void main() async {
  final fileBytes = await File('image.jpg').readAsBytes();
  final image = img.decodeJpg(fileBytes)!;
  runApp(MyApp(image: image,));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.image});
  final img.Image image;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true
      ),
      home: HsvTab(
        image: image,
      ),
    );
  }
}
