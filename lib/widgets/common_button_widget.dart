import 'package:flutter/material.dart';

class CommonButtonWidget extends StatelessWidget {
  final Color textColor;
  final Color borderColor;
  final String buttonText;
  final Color buttonBackgroundColor;
  final double padding;
  final VoidCallback onTap;

  const CommonButtonWidget({
    super.key,
    required this.textColor,
    required this.borderColor,
    required this.buttonText,
    required this.onTap,
    this.padding = 12.0,
    required this.buttonBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor,
        ),
        color: buttonBackgroundColor,
        borderRadius: BorderRadius.circular(32.0),
      ),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding:  EdgeInsets.symmetric(vertical: padding),
          backgroundColor: buttonBackgroundColor,
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
          ),
        ),
        onPressed: onTap,
        child: Text(
          buttonText,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
