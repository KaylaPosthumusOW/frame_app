import 'package:flutter/material.dart';

class MFAVerificationModal extends StatefulWidget {
  final String text;
  final String textLabel;

  const MFAVerificationModal({super.key, required this.text, required this.textLabel});

  @override
  State<MFAVerificationModal> createState() => _MFAVerificationModalState();
}

class _MFAVerificationModalState extends State<MFAVerificationModal> {
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
        mainAxisSize: MainAxisSize.min,
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
              controller: textEditingController,
              decoration: const InputDecoration(
                icon: Icon(Icons.phone_iphone),
                labelText: 'SMS code',
              ),
              keyboardAppearance: Brightness.dark,
              keyboardType: TextInputType.number,
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
