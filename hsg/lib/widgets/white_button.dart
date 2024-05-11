import 'package:flutter/material.dart';

Widget whiteButton(
    String text, void Function() onPressed, double margin, ThemeData theme) {
  return TextButton(
    style: ButtonStyle(
      backgroundColor:
          MaterialStatePropertyAll<Color>(theme.colorScheme.background),
      side: MaterialStatePropertyAll<BorderSide>(
        BorderSide(
          width: 2,
          color: Color.fromARGB(255, 56, 107, 246),
        ),
      ),
    ),
    onPressed: onPressed,
    child: Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 17,
          color: Color.fromARGB(255, 56, 107, 246),
        ),
      ),
    ),
  );
}
