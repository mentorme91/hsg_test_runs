import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../models/assignment.dart';
import '../services/date_formatting.dart';

Future<Timestamp?> selectedDate(
    Timestamp? timestamp, BuildContext context) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: timestamp?.toDate(),
    firstDate: DateTime.now(),
    lastDate: DateTime(DateTime.now().year + 2),
  );
  final TimeOfDay? time = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.fromDateTime(timestamp?.toDate() ?? DateTime.now()),
  );
  if (picked != null && time != null) {
    return Timestamp.fromDate(
      DateTime(
        picked.year,
        picked.month,
        picked.day,
        time.hour,
        time.minute,
      ),
    );
  }
  return null;
}

Widget datesTiles(
  Timestamp startDate,
  Timestamp endDate,

  ThemeData theme,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      startDateTile(startDate, endDate, theme),
      SizedBox(
        width: 10,
      ),
      dueDateTile(startDate, endDate, theme),
    ],
  );
}

Widget editDatesTiles(
  Assignment assignment,
  ThemeData theme,
  Function setState,
  BuildContext context,
) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: [
      editStartDateTile(assignment, theme, context, setState),
      SizedBox(
        width: 10,
      ),
      editDueDateTile(assignment, theme, context, setState),
    ],
  );
}

Widget dueDateTile(
  Timestamp startDate,
  Timestamp endDate,
  ThemeData theme,
) {
  Timestamp now = Timestamp.now();
  double divisor = (endDate.seconds - startDate.seconds) / 2;
  double progress = (divisor + now.seconds - endDate.seconds) / (divisor);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Due Date', style: TextStyle(fontSize: 17)),
      SizedBox(
        height: 10,
      ),
      Container(
        height: 90,
        width: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 5.0,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(formatDate(endDate.toDate()),
                        style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(36, 92, 157, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        formatTime(endDate.toDate()),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF5C9DFF),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget editDueDateTile(
  Assignment assignment,
  ThemeData theme,
  BuildContext context,
  Function setState,
) {
  
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Due Date', style: TextStyle(fontSize: 17)),
      SizedBox(
        height: 10,
      ),
      Container(
        height: 90,
        width: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              child: LinearProgressIndicator(
                value: 1,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                minHeight: 5.0,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(formatDate(assignment.dueDate.toDate()),
                        style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 7,
                    ),
                    GestureDetector(
                      onTap: () {
                        selectedDate(assignment.dueDate, context)
                            .then((value) {
                          if (value != null) {
                            assignment.dueDate = value;
                          }
                          setState();
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(36, 92, 157, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          formatTime(assignment.dueDate.toDate()),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF5C9DFF),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget startDateTile(
  Timestamp startDate,
  Timestamp endDate,
  ThemeData theme,
) {
  Timestamp now = Timestamp.now();
  double progress = (now.seconds - startDate.seconds) /
      ((endDate.seconds - startDate.seconds) / 2);
  if (progress > 1) {
    progress = 1;
  }
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Start Date', style: TextStyle(fontSize: 17)),
      SizedBox(
        height: 10,
      ),
      Container(
        height: 90,
        width: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              child: LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 5.0,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(formatDate(startDate.toDate()),
                        style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 7,
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color.fromARGB(36, 92, 157, 255),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        formatTime(startDate.toDate()),
                        style: TextStyle(
                          fontSize: 15,
                          color: Color(0xFF5C9DFF),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
Widget editStartDateTile(
  Assignment assignment,
  ThemeData theme,
  BuildContext context,
  Function setState,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text('Start Date', style: TextStyle(fontSize: 17)),
      SizedBox(
        height: 10,
      ),
      Container(
        height: 90,
        width: 140,
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 10,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              child: LinearProgressIndicator(
                value: 1,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                minHeight: 5.0,
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Text(formatDate(assignment.startDate.toDate()),
                        style: TextStyle(fontSize: 15)),
                    SizedBox(
                      height: 7,
                    ),
                    GestureDetector(
                      onTap: () {
                        selectedDate(assignment.startDate, context)
                            .then((value) {
                          if (value != null) {
                            assignment.startDate = value;
                          }
                          setState();
                        });
                      },
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                        decoration: BoxDecoration(
                          color: Color.fromARGB(36, 92, 157, 255),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          formatTime(assignment.startDate.toDate()),
                          style: TextStyle(
                            fontSize: 15,
                            color: Color(0xFF5C9DFF),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}
