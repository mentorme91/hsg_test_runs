import 'package:flutter/material.dart';

class MultiInputField extends StatefulWidget {
  final List<String> list;
  final String input;
  const MultiInputField({super.key, required this.list, required this.input});

  @override
  State<MultiInputField> createState() => _MultiInputFieldState();
}

class _MultiInputFieldState extends State<MultiInputField> {
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            hintText: 'Enter ${widget.input}',
          ),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              if (_controller.text.trim().isNotEmpty)
                widget.list.add(_controller.text.toUpperCase().trim());
              _controller.clear();
            });
          },
          child: Text('Add'),
        ),
        for (var item in widget.list)
          ListTile(
            title: Text(item),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  widget.list.remove(item);
                });
              },
            ),
          ),
      ],
    );
  }
}
