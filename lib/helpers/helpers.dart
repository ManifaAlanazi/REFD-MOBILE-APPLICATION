import 'package:flutter/material.dart';
import 'package:refd_app/helpers/colors.dart';

class Helpers {
  static showRequestMessageResponse({
    required String message,
    required BuildContext context,
    isError = false,
  }) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: isError ? AppColors.errorColor : AppColors.successColor,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
