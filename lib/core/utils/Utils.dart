import 'package:flutter/material.dart';

void showNewDialog(BuildContext context, Color bgColor, String msg) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Container(
          child: Row(
    children: [
      Icon(
        Icons.verified,
        color: bgColor,
      ),
      SizedBox(
        width: 25,
      ),
      Text(msg),
    ],
  ))));
}

void showLoadingDialog(
    BuildContext context, Color secondaryColor, Color primaryColor, Text text) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: secondaryColor,
        content: Container(
          padding: EdgeInsets.all(20),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
              SizedBox(width: 20),
              text,
            ],
          ),
        ),
      );
    },
  );
}
