import 'package:flutter/material.dart';

Widget topNavBar(
  List<String> labels,
  String selectedLabel,
  double margin,
  ThemeData theme, {
  Function(String)? onSelected,
  bool showIcons = true,
  List<IconData> icons = const [],
  double textSize = 17,
}) {
  return Container(
      margin: EdgeInsets.symmetric(horizontal: margin),
      height: 50,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: Color(0x1F84A4FD),
      ),
      child: Row(children: [
        for (int i = 0; i < labels.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () {
                if (onSelected != null) onSelected(labels[i]);
              },
              child: Container(
                decoration: (labels[i] == selectedLabel)
                    ? BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Color(0xFF84A4FD))
                    : null,
                alignment: Alignment.center,
                child: RichText(
                  text: TextSpan(children: [
                    if (showIcons)
                      WidgetSpan(
                          child: Icon(
                        icons[i],
                        color:
                            (labels[i] == selectedLabel) ? Colors.white : null,
                        size: 19,
                      )),
                    TextSpan(
                      text: '  ${labels[i]}',
                      style: TextStyle(
                        color: (labels[i] == selectedLabel)
                            ? Colors.white
                            : theme.colorScheme.onPrimary,
                        fontSize: textSize,
                      ),
                    ),
                  ]),
                ),
              ),
            ),
          )
      ]));
}
