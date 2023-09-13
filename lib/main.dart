import 'package:color_spaces/bloc/main_bloc.dart';
import 'package:color_spaces/image_load/image_load.dart';
import 'package:color_spaces/task_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Цветовые пространства",
          ),
        ),
        body: BlocProvider(
          create: (context) => MainBloc(),
          child: BlocBuilder<MainBloc, MainState>(
            builder: (context, state) {
              return Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TaskPicker(
                        buttons: [
                          ButtonData("Исходное изображение", () {
                            BlocProvider.of<MainBloc>(context)
                                .add(const MainImageLoadRequested());
                          }),
                          ButtonData("Задание 1", () {
                            BlocProvider.of<MainBloc>(context)
                                .add(const MainFirstTaskRequested());
                          }),
                          ButtonData("Задание 2", () {
                            BlocProvider.of<MainBloc>(context)
                                .add(const MainSecondTaskRequested());
                          }),
                          ButtonData("Задание 3", () {
                            BlocProvider.of<MainBloc>(context)
                                .add(const MainThirdTaskRequested());
                          }),
                        ],
                        inactiveButtons:
                            state.image == null ? [1, 2, 3] : null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: switch (state) {
                          MainImageLoad() => ImageLoad(
                              state: state,
                              onLoad: () {
                                BlocProvider.of<MainBloc>(context)
                                    .add(const MainImageLoadStarted());
                              },
                            ),
                          MainFirstTask() => Text("1"),
                          MainSecondTask() => Text("2"),
                          MainThirdTask() => Text("3"),
                        },
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
