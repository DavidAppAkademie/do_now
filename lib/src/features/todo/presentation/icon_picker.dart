import 'package:do_now/src/features/todo/domain/todo.dart';
import 'package:do_now/src/theme/palette.dart';
import 'package:flutter/material.dart';

class IconPicker extends StatefulWidget {
  final void Function(TodoIcon icon) onIconChanged;
  const IconPicker({super.key, required this.onIconChanged});

  @override
  State<IconPicker> createState() => _IconPickerState();
}

class _IconPickerState extends State<IconPicker> {
  // State
  TodoIcon _selectedIcon = TodoIcon.values.first;
  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final colorWeak = color;
    return Wrap(
      runSpacing: 16,
      spacing: 32,
      children: TodoIcon.values.map(
        (e) {
          bool isSelected = _selectedIcon == e;
          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIcon = e;
              });
              widget.onIconChanged(_selectedIcon);
            },
            child: Opacity(
              opacity: isSelected ? 1 : 0.6,
              child: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: color.withAlpha(200),
                        blurRadius: isSelected ? 6 : 0,
                        spreadRadius: 0),
                  ],
                  color: isSelected ? color : colorWeak,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    e.icon,
                    color: isSelected ? Palette.white : null,
                    size: 32,
                  ),
                ),
              ),
            ),
          );

          // return IconButton(
          //   onPressed: () {
          //     setState(() {
          //       _selectedIcon = e;
          //     });
          //   },
          //   icon: Icon(e.icon, size: 32),
          //   color: _selectedIcon == e ? Theme.of(context).primaryColor : null,
          // );
        },
      ).toList(),
    );
  }
}
