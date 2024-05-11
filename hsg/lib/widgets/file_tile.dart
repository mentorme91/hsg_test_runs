import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// file tile
Widget fileTile(Map<String, dynamic> file, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      Text(file['title'], style: TextStyle(color: const Color.fromARGB(255, 12, 139, 243))),
      IconButton(
          onPressed: () async {
            // download file
            try {
              // download file
              await launchUrl(Uri.parse(file['url']));
            } catch (error) {
              // show error
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('An error occurred while loading file'),
                ),
              );
            }
          },
          icon: Icon(Icons.open_in_browser))
    ],
  );
}
