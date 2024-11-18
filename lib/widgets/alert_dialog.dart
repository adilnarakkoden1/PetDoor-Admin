import 'package:flutter/material.dart';

class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final String cancelText;
  final String continueText;
  final VoidCallback onCancel;
  final VoidCallback onContinue;

  const CustomAlertDialog({
    Key? key,
    required this.title,
    required this.content,
    required this.cancelText,
    required this.continueText,
    required this.onCancel,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      content: Text(
        content,
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[800],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.redAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(cancelText),
        ),
        TextButton(
          onPressed: onContinue,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          ),
          child: Text(continueText),
        ),
      ],
    );
  }
}
