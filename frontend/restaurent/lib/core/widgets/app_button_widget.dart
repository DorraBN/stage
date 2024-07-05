import 'package:flutter/material.dart';

enum ButtonType { PRIMARY, PLAIN }

class AppButton extends StatelessWidget {
  final ButtonType? type;
  final VoidCallback? onPressed;
  final String? text;

  AppButton({this.type, this.onPressed, this.text});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: this.onPressed,
      child: Container(
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
          color: getButtonColor(context, type ?? ButtonType.PLAIN), // Added null check for type
          borderRadius: BorderRadius.circular(4.0),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(169, 176, 185, 0.42),
              spreadRadius: 0,
              blurRadius: 3.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(this.text ?? '', // Added null check for text
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(color: getTextColor(context, type ?? ButtonType.PLAIN))), // Added null check for type
        ),
      ),
    );
  }
}

Color getButtonColor(BuildContext context, ButtonType type) {
  switch (type) {
    case ButtonType.PRIMARY:
      return Theme.of(context).primaryColor; // Adjusted to return primaryColor
    case ButtonType.PLAIN:
      return Colors.white;
    default:
      return Theme.of(context).primaryColor; // Adjusted to return primaryColor
  }
}

Color getTextColor(BuildContext context, ButtonType type) {
  switch (type) {
    case ButtonType.PLAIN:
      return Theme.of(context).primaryColor;
    case ButtonType.PRIMARY:
      return Colors.white;
    default:
      return Theme.of(context).primaryColor;
  }
}
