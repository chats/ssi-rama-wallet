import 'package:flutter/material.dart';

class SnackbarHelper {
  static void showSnackbar(BuildContext context, String message,
      {Color? textColor, Color? backgroundColor}) {
    final theme = Theme.of(context);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: textColor ?? theme.colorScheme.onInverseSurface,
        ),
      ),
      //elevation: 6.0,
      behavior: SnackBarBehavior.floating,
      backgroundColor: backgroundColor ?? theme.colorScheme.inverseSurface,
    ));
  }
}
