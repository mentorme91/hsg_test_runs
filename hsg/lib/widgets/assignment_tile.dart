import 'package:flutter/material.dart';

import '../models/assignment.dart';
import '../services/date_formatting.dart';
import 'blue_button.dart';

Widget assignmentTile(
  Assignment assignment,
  ThemeData theme,
  void Function(Assignment assignment) toPage,
) {
  return Container(
    margin: EdgeInsets.only(right: 10, top: 20),
    decoration: BoxDecoration(
      color: theme.colorScheme.background,
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 5,
          blurRadius: 10,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 3,
          height: 200,
          color: Colors.blue,
        ),
        SizedBox(
          width: 10,
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // main part

            Row(
              children: [
                TextButton(
                  onPressed: null,
                  child: CircleAvatar(
                    radius: 25,
                    backgroundImage: (assignment.posterPhoto == null)
                        ? const AssetImage('assets/images/face.png')
                        : null,
                    foregroundImage: (assignment.posterPhoto != null)
                        ? NetworkImage(assignment.posterPhoto ?? '', scale: 1)
                        : null,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.poster,
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text('Staff (${assignment.posterPosition})')
                  ],
                )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              formatText(assignment.description, 200),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                Text(
                  'Start Date: ${formatDate(assignment.startDate.toDate())}',
                  style: TextStyle(fontSize: 12, color: Colors.green),
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  'Due Date: ${formatDate(assignment.dueDate.toDate())}',
                  style: TextStyle(fontSize: 12, color: Color(0xFFF44336)),
                ),
              ],
            ),
            BlueButton('Details', () => toPage(assignment), 20,
                color: Color(0xFF84A4FD))
          ],
        )
      ],
    ),
  );
}
