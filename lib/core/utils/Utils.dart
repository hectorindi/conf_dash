import 'package:flutter/material.dart';

void showNewDialog (BuildContext context, Color bgColor, String msg) {
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