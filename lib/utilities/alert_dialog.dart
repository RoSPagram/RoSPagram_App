import 'package:flutter/cupertino.dart';

void showAlertDialog(BuildContext context, {
  required String title,
  required String content,
  required String defaultActionText,
  String? destructiveActionText,
  void Function()? destructiveActionOnPressed
}) {
  showCupertinoModalPopup<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(content),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () => Navigator.pop(context),
          child: Text(defaultActionText),
        ),
        if (destructiveActionText != null)
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: destructiveActionOnPressed,
            child: Text(destructiveActionText),
          ),
      ],
    ),
  );
}