import 'package:flutter/material.dart';

Widget customInputField(
  String initVal,
  Function(String) onChanged,
  String hintText,
  ThemeData theme, {
  String? Function(String?)? validator,
  bool changeAllcharacters = false,
  IconData? prefixIcon,
  IconData? suffixIcon,
  Function(String)? onIconPressed,
  int maxLines = 1,
  int minLines = 1,
  String? labelText,
  double labelSize = 15,
  bool obscureText = false,
  List<String>? autofillHints,
  double margin = 3,
  void Function()? onEditingComplete,
}) {
  String val = initVal;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: margin),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text(
            labelText,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: labelSize,
            ),
          ),
        SizedBox(
          height: 5,
        ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(40),
          color: theme.shadowColor,
          child: TextFormField(
            obscureText: obscureText,
            initialValue: initVal,
            autofillHints: autofillHints,
            decoration: InputDecoration(
              hintText: hintText,
              fillColor: Colors.white,
              filled: true,
              prefixIcon: IconButton(
                icon: Icon(
                  prefixIcon,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () =>
                    onIconPressed == null ? null : onIconPressed(val.trim()),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  suffixIcon,
                  color: theme.colorScheme.onPrimary,
                ),
                onPressed: () =>
                    onIconPressed == null ? null : onIconPressed(val.trim()),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
            validator: validator,
            onChanged: changeAllcharacters
                ? onChanged
                : (value) {
                    val = value.trim().toLowerCase();
                  },
            minLines: minLines,
            maxLines: maxLines,
            onEditingComplete: onEditingComplete,
          ),
        ),
      ],
    ),
  );
}

Widget searchBar(
    void Function(String) setState, String searchVal, ThemeData theme) {
  return customInputField(
    searchVal,
    setState,
    'Search connections',
    theme,
    changeAllcharacters: false,
    prefixIcon: Icons.search,
    onIconPressed: setState,
    margin: 25,
  );
}
