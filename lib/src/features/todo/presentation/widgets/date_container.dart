import 'package:do_now/src/theme/palette.dart';
import 'package:flutter/material.dart';

class DateContainer extends StatelessWidget {
  final String day;
  final bool isToday;
  final bool isSelected;
  final VoidCallback? onTap;

  const DateContainer({
    super.key,
    required this.day,
    required this.isToday,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          border: isToday
              ? Border.all(
                  color: Palette.white,
                  width: 1.6,
                )
              : null,
          color: isSelected ? Palette.white.withAlpha(0.2 * 255 ~/ 1) : null,
        ),
        child: Center(
          child: Text(
            day,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Palette.white,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
