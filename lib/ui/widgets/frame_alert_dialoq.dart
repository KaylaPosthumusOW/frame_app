import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';
import 'package:frameapp/ui/widgets/frame_button.dart';

class FrameAlertDialoq extends StatefulWidget {
  final String title;
  final String content;
  final Widget? widgetContent;
  final Function? action;
  final String? actionTitle;
  final Function? cancelAction;
  final String? cancelText;
  final bool onlyShowOneButton;
  final String? oneButtonText;
  final Color? buttonColor;

  const FrameAlertDialoq({super.key, this.widgetContent, this.cancelText, required this.title, this.action, this.cancelAction, required this.content, this.onlyShowOneButton = false, this.actionTitle, this.oneButtonText, this.buttonColor});

  @override
  FrameAlertDialoqState createState() => FrameAlertDialoqState();
}

class FrameAlertDialoqState extends State<FrameAlertDialoq> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppColors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
      title: Text(widget.title, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.black)),
      content: widget.widgetContent ?? Text(widget.content, style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.black)),
      actions: [
        widget.onlyShowOneButton
            ? Center(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FrameButton(
              onPressed: () => widget.action != null ? widget.action!() : Navigator.pop(context),
              label: widget.oneButtonText ?? '',
              type: ButtonType.primary,
              buttonColor: widget.buttonColor,
            ),
          ),
        )
            : Row(
          children: [
            Expanded(
              child: FrameButton(
                onPressed: () => widget.cancelAction != null ? widget.cancelAction!() : Navigator.pop(context),
                label: widget.cancelText ?? 'Cancel',
                type: ButtonType.outline,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: FrameButton(
                onPressed: () => widget.action!(),
                label: widget.actionTitle ?? 'Yes',
                type: ButtonType.primary,
                buttonColor: widget.buttonColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
