import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseAnnouncement {
  String title;
  String information;
  Timestamp date;
  final Icon icon = Icon(Icons.announcement);

  CourseAnnouncement({
    required this.title,
    required this.information,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'date': date,
      'information': information,
      'title': title,
    };
  }

  void updateFromAnnouncement(CourseAnnouncement announcement) {
    title = announcement.title;
    information = announcement.information;
    date = announcement.date;
  }

  factory CourseAnnouncement.fromMap(Map<String, dynamic> map) {
    return CourseAnnouncement(
      title: map['title'],
      information: map['information'],
      date: map['date'],
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CourseAnnouncement &&
        other.title == title &&
        other.information == information &&
        other.date == date;
  }

  @override
  int get hashCode =>
      title.hashCode ^
      information.hashCode ^
      date.hashCode;
}
