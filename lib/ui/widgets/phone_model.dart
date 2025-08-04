import 'package:flutter/material.dart';

class PhoneModal extends StatefulWidget {
  final String text;
  final String textLabel;

  const PhoneModal({super.key, required this.text, required this.textLabel});

  @override
  State<PhoneModal> createState() => _PhoneModalState();
}

class _PhoneModalState extends State<PhoneModal> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    const padding = EdgeInsets.all(16);
    return SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: colorScheme.primary,
            child: Padding(
              padding: padding,
              child: Text(
                widget.text,
                style: theme.textTheme.bodyMedium!.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.surface,
                ),
              ),
            ),
          ),
          Padding(
            padding: padding.copyWith(bottom: 0),
            child: TextFormField(
              keyboardAppearance: Brightness.dark,
              controller: textEditingController,
              autofocus: true,
              decoration: InputDecoration(
                label: Text(widget.textLabel),
                floatingLabelBehavior: FloatingLabelBehavior.always,
              ),
              enableSuggestions: false,
            ),
          ),
          Padding(
            padding: padding,
            child: OutlinedButton(
              onPressed: () => Navigator.of(context).pop(textEditingController.text),
              child: const Text('Confirm'),
            ),
          ),
          const SizedBox(height: 44, width: 44),
        ],
      ),
    );
  }
}
