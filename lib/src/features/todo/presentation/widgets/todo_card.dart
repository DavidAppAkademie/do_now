import 'package:do_now/src/theme/palette.dart';
import 'package:flutter/material.dart';

class TodoCard extends StatelessWidget {
  // Attribute
  final String title;
  final String subTitle;
  final IconData icon;
  final Color color;

  const TodoCard({
    super.key,
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          spacing: 16,
          children: [
            Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: color.withAlpha(200),
                      blurRadius: 12,
                      spreadRadius: 0),
                ],
                color: color,
                borderRadius: BorderRadius.all(Radius.circular(16)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(
                  icon,
                  color: Palette.white,
                  size: 40,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleLarge),
                  Text(subTitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
