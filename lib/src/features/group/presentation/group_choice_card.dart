import 'package:flutter/material.dart';

class GroupChoiceCard extends StatefulWidget {
  // Attribute
  final String title;
  final String hintText;
  final String tipText;
  final String buttonText;
  final void Function(String value) onPressed;

  // Konstruktor
  const GroupChoiceCard({
    super.key,
    required this.title,
    required this.hintText,
    required this.tipText,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  State<GroupChoiceCard> createState() => _GroupChoiceCardState();
}

class _GroupChoiceCardState extends State<GroupChoiceCard> {
  final _textController = TextEditingController();

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
                Text(widget.title,
                    style: Theme.of(context).textTheme.titleMedium),
                TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                      hintText: widget.hintText, labelText: widget.hintText),
                ),
                Text(
                  widget.tipText,
                  style: Theme.of(context)
                      .textTheme
                      .labelSmall!
                      .copyWith(fontStyle: FontStyle.italic),
                ),
                FilledButton(
                  onPressed: () {
                    widget.onPressed(_textController.text);
                  },
                  child: Text(widget.buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }
}
