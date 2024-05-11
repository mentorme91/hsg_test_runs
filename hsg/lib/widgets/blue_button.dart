import 'package:flutter/material.dart';

Widget BlueButton(
  String text,
  void Function() onPressed,
  double margin, {
  Color? color,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll<Color>(
              color == null ? Color.fromARGB(255, 56, 107, 246) : color),
        ),
        onPressed: onPressed,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: margin),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              color: Colors.white,
            ),
          ),
        ),
      ),
    ],
  );
}
