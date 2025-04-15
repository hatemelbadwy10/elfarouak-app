import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final Function()? onPressed;
  final String text;
  final Color? textColor, bgColor;
  final Color borderColor;
  final double? textFontSize;
  final double borderRadius, borderThickness;
  final bool isLoading;
  final Size? size;

  const ActionButton({
    super.key,
    this.onPressed,
    required this.text,
    this.isLoading = false,
    this.textColor,
    this.textFontSize = 18,
    this.bgColor,
    this.borderRadius = 0,
    this.borderThickness = 1,
    this.borderColor = Colors.transparent,
    this.size
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        minimumSize: size?? const Size(double.infinity, 45),
        backgroundColor: bgColor,
        foregroundColor: bgColor,
        elevation: 0,
        side: BorderSide(
          color: borderColor,
          width: borderThickness,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
              width: 25,
              height: 25,
              child: CircularProgressIndicator.adaptive(strokeWidth: 2.5),
            ))
          : Text(
              text,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.w500,
                fontSize: textFontSize,
              ),
            ),
    );
  }
}
