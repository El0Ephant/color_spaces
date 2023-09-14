import 'package:flutter/material.dart';
import 'package:image/image.dart' as image;

class TaskPicker extends StatefulWidget {
  const TaskPicker(
      {super.key, required this.buttons, List<int>? inactiveButtons})
      : inactiveButtons = inactiveButtons ?? const [];

  final List<ButtonData> buttons;
  final List<int> inactiveButtons;

  @override
  State<TaskPicker> createState() => _TaskPickerState();
}

class _TaskPickerState extends State<TaskPicker> {
  int currentIndex = 0;

  Color _colorForIndex(
    int index,
    Color pickedColor,
    Color unpickedColor,
    Color inactiveColor,
  ) {
    if (widget.inactiveButtons.contains(index)) {
      return inactiveColor;
    } else {
      return currentIndex == index ? pickedColor : unpickedColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: widget.buttons.asMap().entries.map(
        (data) {
          final index = data.key;
          final title = data.value.title;
          final callback = data.value.callback;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                backgroundColor: _colorForIndex(
                  index,
                  Colors.purple,
                  Colors.white,
                  Colors.white,
                ),
                foregroundColor: _colorForIndex(
                  index,
                  Colors.white,
                  Colors.purple,
                  Colors.grey,
                ),
              ),
              onPressed: () {
                if (!widget.inactiveButtons.contains(index)) {
                  setState(() {
                    currentIndex = index;
                    callback();
                  });
                }
              },
              child: Text(
                title,
              ),
            ),
          );
        },
      ).toList(growable: false),
    );
  }
}

class ButtonData {
  const ButtonData(this.title, this.callback);

  final String title;
  final VoidCallback callback;
}
