import 'package:flutter/material.dart';

class GroupChoiceCard extends StatelessWidget {
  final String title;
  final String hintText;
  final String tipText;
  final String buttonText;

  const GroupChoiceCard({
    super.key,
    required this.title,
    required this.hintText,
    required this.tipText,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              spacing: 16,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                TextFormField(
                  decoration:
                      InputDecoration(hintText: hintText, labelText: hintText),
                ),
                Text(
                  tipText,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontStyle: FontStyle.italic),
                ),
                FilledButton(
                  onPressed: () {},
                  child: Text(buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
/* 
1. Neue Gruppe erstellen

2. Gruppe beitreten

3. Auswahl vorhandener Gruppen


->>>> HomeScreen (mit eine Gruppe)


 */
