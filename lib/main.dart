import 'package:color_spaces/bloc/main_bloc.dart';
import 'package:color_spaces/bloc_singletons.dart';
import 'package:color_spaces/first_task/grayscale_tab.dart';
import 'package:color_spaces/image_load/image_load.dart';
import 'package:color_spaces/task_picker.dart';
import 'package:color_spaces/second_task/channels_tab.dart';
import 'package:color_spaces/third_task/hsv_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
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
          child: BlocConsumer<MainBloc, MainState>(
            listenWhen: (previous, current) =>
                previous.image.hashCode != current.image.hashCode,
            listener: (context, state) {
              BlocSingletons.closeGrayscaleBloc();
              BlocSingletons.closeHsvBloc();
            },
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
                          ButtonData("Оттенки серого", () {
                            BlocProvider.of<MainBloc>(context)
                                .add(const MainFirstTaskRequested());
                          }),
                          ButtonData("Цветовые каналы", () {
                            BlocProvider.of<MainBloc>(context)
                                .add(const MainSecondTaskRequested());
                          }),
                          ButtonData("HSV", () {
                            BlocProvider.of<MainBloc>(context)
                                .add(const MainThirdTaskRequested());
                          }),
                        ],
                        inactiveButtons: state.image == null ? [1, 2, 3] : null,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: switch (state) {
                            MainImageLoad() => ImageLoad(
                                state: state,
                                onLoad: () {
                                  BlocProvider.of<MainBloc>(context)
                                      .add(const MainImageLoadStarted());
                                },
                              ),
                            MainFirstTask() => GrayscaleTab(
                                state: state,
                              ),
                            MainSecondTask() => ChannelsTab(
                                state: state,
                              ),
                            MainThirdTask(
                              image: var image,
                            ) =>
                              HsvTab(
                                image: image,
                              ),
                          },
                        ),
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
