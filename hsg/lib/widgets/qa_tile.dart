import 'package:flutter/material.dart';

import '../models/q_and_a_model.dart';
import '../services/database_service.dart';
import '../services/date_formatting.dart';

Widget QATile(
    QandA qa, String courseCode, void Function() onTap, ThemeData theme) {
  DatabaseService databaseService = DatabaseService(uid: '');
  return Container(
    margin: EdgeInsets.symmetric(vertical: 10.0),
    decoration: BoxDecoration(
      color: theme.colorScheme.tertiaryContainer,
      border: Border.all(color: const Color.fromARGB(255, 208, 208, 208)),
      borderRadius: BorderRadius.circular(10.0),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          spreadRadius: 2,
          blurRadius: 10,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
          future: databaseService.getUserInfo(qa.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Center(
                child:
                    Text('Oops! Something went wrong. Please try again later.'),
              );
            }
            return Container(
              child: ListTile(
                leading: CircleAvatar(
                  radius: 30.0,
                  backgroundImage: (snapshot.data?.photoURL != null)
                      ? NetworkImage(snapshot.data?.photoURL ?? '')
                      : AssetImage('assets/images/face.png') as ImageProvider,
                ),
                title: Text(formatText(qa.topic, 20),
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(formatDateTime(qa.time.toDate()),
                    style: TextStyle(
                        color: const Color.fromARGB(255, 128, 128, 128),
                        fontSize: 12.0)),
                trailing: (qa.isAnswered)
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.green[50],
                        ),
                        child: Text(
                          'Solved',
                          style: TextStyle(color: Colors.green, fontSize: 13.0),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          color: Colors.red[50],
                        ),
                        child: Text(
                          'Unsolved',
                          style: TextStyle(color: Colors.red, fontSize: 13.0),
                        ),
                      ),
              ),
            );
          },
        ),
        Container(
          margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 17.0),
          child: Text(formatText(qa.question, 200),
              style: TextStyle(
                fontSize: 14.0,
              )),
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 17.0),
            child: RichText(
              text: TextSpan(children: [
                TextSpan(
                    text: 'Files: ',
                    style: TextStyle(
                        color: const Color.fromARGB(255, 128, 128, 128),
                        fontSize: 16.0)),
                TextSpan(
                    text: (qa.fileData.length > 0)
                        ? formatText(
                            qa.fileData
                                .map((Map<String, dynamic> file) {
                                  return file['title'];
                                })
                                .toList()
                                .join(', '),
                            40)
                        : 'No files attached',
                    style: TextStyle(
                        color: theme.colorScheme.primary, fontSize: 15.0)),
              ]),
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: onTap,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 17.0, bottom: 5.0),
                    child: Text(
                      'View answers',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
