import 'package:color_spaces/bloc/main_bloc.dart';
import 'package:color_spaces/bloc_singletons.dart';
import 'package:color_spaces/custom_image.dart';
import 'package:color_spaces/first_task/bloc/grayscale_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GrayscaleTab extends StatelessWidget {
  const GrayscaleTab({super.key, required this.state});

  final MainFirstTask state;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => BlocSingletons.createGrayscaleBloc(
        state.image,
      ),
      child: BlocBuilder<GrayscaleBloc, GrayscaleState>(
        builder: (context, state) {
          final screenWidth = MediaQuery.of(context).size.width;
          final screenHeight = MediaQuery.of(context).size.height;

          return switch (state) {
            GrayscaleLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            GrayscaleLoaded(
              firstVersion: final firstVersion,
              secondVersion: final secondVersion,
              subtraction: final subtraction,
              firstIntensity: final firstIntensity,
              secondIntensity: final secondIntensity,
            ) =>
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomImage(
                        firstVersion.bytes,
                        title: "NTSC",
                        width: screenWidth / 3,
                      ),
                      CustomImage(
                        secondVersion.bytes,
                        title: "HDTV",
                        width: screenWidth / 3,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: screenWidth / 4,
                        child: SfCartesianChart(
                          series: <ChartSeries>[
                            ColumnSeries<MapEntry<int, num>, num>(
                              dataSource:
                                  firstIntensity.asMap().entries.toList(),
                              xValueMapper: (MapEntry<int, num> data, _) =>
                                  data.key,
                              yValueMapper: (MapEntry<int, num> data, _) =>
                                  data.value,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: screenWidth / 4,
                        child: SfCartesianChart(
                          series: <ChartSeries>[
                            ColumnSeries<MapEntry<int, int>, num>(
                              dataSource:
                                  secondIntensity.asMap().entries.toList(),
                              xValueMapper: (MapEntry<int, int> data, _) =>
                                  data.key,
                              yValueMapper: (MapEntry<int, int> data, _) =>
                                  data.value,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  CustomImage(
                    subtraction.bytes,
                    title: "Нормализованная разность",
                    width: screenWidth / 3,
                  ),
                ],
              ),
            GrayscaleError() => const Center(
                child: Text(
                  "Не удалось декодировать изображение",
                ),
              ),
          };
        },
      ),
    );
  }
}
