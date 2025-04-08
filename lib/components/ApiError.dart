import 'package:flutter/material.dart';

class ApiError extends StatelessWidget {
  final Widget child;

  const ApiError({super.key, required this.child})

  static Future<void> apiError(BuildContext build, Widget widget) {
    return showGeneralDialog(context: context, pageBuilder: pageBuilder)
  }
}