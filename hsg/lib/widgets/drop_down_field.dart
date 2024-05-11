import 'package:flutter/material.dart';

Widget customDropDownField(
  List<dynamic>? items,
  Function(dynamic) onChanged,
  ThemeData theme, {
  String? Function(dynamic)? validator,
  Widget? prefixIcon,
  Widget? suffixIcon,
  String? hintText,
  String? labelText,
}) {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 3),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (labelText != null)
          Text(
            labelText,
            style: TextStyle(
              color: theme.colorScheme.onPrimary,
              fontSize: 15,
            ),
          ),
        Material(
          elevation: 5,
          borderRadius: BorderRadius.circular(20),
          child: DropdownButtonFormField(
            items: createDropDown(items),
            onChanged: onChanged,
            validator: validator,
            dropdownColor: theme.colorScheme.tertiaryContainer,
            style: TextStyle(
              backgroundColor: theme.colorScheme.tertiaryContainer,
              color: theme.colorScheme.onPrimary,
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none),
              filled: true,
              hintText: hintText,
              prefixIcon: prefixIcon,
              suffixIcon: suffixIcon,
              fillColor: Colors.white,
            ),
            
          ),
        ),
      ],
    ),
  );
}

// CreateDropDown: Used to create a custom dropdown from a list of items
List<DropdownMenuItem>? createDropDown(List<dynamic>? items) {
  if (items == null) return null;
  return items
      .map((item) => DropdownMenuItem(
            value: item,
            child: Text(
              item,
            ),
          ))
      .toList();
}

// produceList: Generates list of keys from a dictionary
List<String> produceList(Map<String, dynamic> m) {
  List<String> l = [];
  m.forEach((key, value) {
    l.add(key);
  });
  return l;
}
