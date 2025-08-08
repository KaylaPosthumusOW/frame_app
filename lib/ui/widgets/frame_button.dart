import 'package:flutter/material.dart';
import 'package:frameapp/constants/themes.dart';

enum ButtonType { primary, secondary, outline }

class FrameButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final String? label;
  final bool isLoading;
  final bool isDisabled;
  final Widget? loadingIndicator;
  final Icon? icon;
  final ButtonType type;
  final Color? textColor;
  final Color? outlineColor;
  final VoidCallback? onDisabledPress;
  final Color? buttonColor;

  const FrameButton({
    super.key,
    this.onPressed,
    this.label,
    this.isLoading = false,
    this.isDisabled = false,
    this.loadingIndicator,
    this.icon,
    required this.type,
    this.textColor,
    this.outlineColor,
    this.onDisabledPress,
    this.buttonColor,
  });

  @override
  State<FrameButton> createState() => _FrameButtonState();
}

class _FrameButtonState extends State<FrameButton> {
  Widget _buildLoadingIndicator() {
    return SizedBox(width: 18, height: 18, child: Center(child: widget.loadingIndicator ?? const CircularProgressIndicator(strokeWidth: 2)));
  }

  Widget _buildLabel(BuildContext context) {
    return Text(
      widget.label ?? '',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  ButtonStyle _getButtonStyle(bool isDisabled) {
    switch (widget.type) {
      case ButtonType.primary:
        return FilledButton.styleFrom(backgroundColor: isDisabled ? AppColors.framePurple.withValues(alpha: 0.4) : widget.buttonColor ?? AppColors.framePurple, foregroundColor: AppColors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)));
      case ButtonType.secondary:
        return FilledButton.styleFrom(backgroundColor: isDisabled ? AppColors.limeGreen.withValues(alpha: 0.4) : widget.buttonColor ?? AppColors.limeGreen, foregroundColor: AppColors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)));
      case ButtonType.outline:
        return OutlinedButton.styleFrom(backgroundColor: AppColors.white, side: BorderSide(color: isDisabled ? AppColors.framePurple : widget.outlineColor ?? AppColors.framePurple), foregroundColor: isDisabled ? AppColors.framePurple : AppColors.framePurple, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)));
    }
  }

  Widget _buildButton(Widget? icon, Widget label, VoidCallback? onPressed, ButtonStyle style) {
    switch (widget.type) {
      case ButtonType.primary:
        return FilledButton.icon(onPressed: onPressed, icon: icon ?? const SizedBox.shrink(), label: label, style: style);
      case ButtonType.secondary:
        return FilledButton.icon(onPressed: onPressed, icon: icon ?? const SizedBox.shrink(), label: label, style: style);
      case ButtonType.outline:
        return OutlinedButton.icon(onPressed: onPressed, icon: icon ?? const SizedBox.shrink(), label: label, style: style);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool effectiveIsDisabled = widget.isDisabled || widget.isLoading;
    final buttonStyle = _getButtonStyle(effectiveIsDisabled);

    return SizedBox(
      height: 50,
      child: _buildButton(
        widget.isLoading ? _buildLoadingIndicator() : widget.icon,
        widget.isLoading ? const SizedBox.shrink() : _buildLabel(context),
        effectiveIsDisabled
            ? () {
          widget.onDisabledPress != null ? widget.onDisabledPress!() : () {};
        }
            : widget.onPressed,
        buttonStyle,
      ),
    );
  }
}
