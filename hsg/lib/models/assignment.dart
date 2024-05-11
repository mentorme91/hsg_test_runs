import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class Assignment {
  String title;
  String? id;
  String description;
  Timestamp dueDate = Timestamp.now(), startDate = Timestamp.now();
  List<File> files = [];
  List<Map<String, dynamic>> fileData = [];
  String poster;
  String posterID;
  String? posterPhoto;
  String posterPosition;

  Assignment({
    required this.title,
    required this.description,
    this.id,
    required this.dueDate,
    required this.startDate,
    required this.poster,
    required this.posterID,
    required this.posterPosition,
    this.posterPhoto,
    this.files = const [],
    this.fileData = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'startDate': startDate,
      'fileData': fileData,
      'poster': poster,
      'posterID': posterID,
      'posterPhoto': posterPhoto,
      'posterPosition': posterPosition
    };
  }

  Assignment copyWith({
    String? id,
    String? title,
    String? description,
    Timestamp? dueDate,
    Timestamp? startDate,
    List<File>? files,
    List<Map<String, dynamic>>? fileData,
  }) {
    return Assignment(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      startDate: startDate ?? this.startDate,
      files: files ?? this.files,
      fileData: fileData ?? this.fileData,
      poster: poster,
      posterID: posterID,
      posterPhoto: posterPhoto,
      posterPosition: posterPosition,
    );
  }

  void updateFromAssignment(Assignment assignment) {
    id = assignment.id;
    title = assignment.title;
    description = assignment.description;
    dueDate = assignment.dueDate;
    startDate = assignment.startDate;
    files = assignment.files;
    fileData = assignment.fileData;
    poster = assignment.poster;
    posterID = assignment.posterID;
    posterPhoto = assignment.posterPhoto;
    posterPosition = assignment.posterPosition;
  }

  void updateFromMap(Map<String, dynamic> data) {
    id = data['id'];
    title = data['title'];
    description = data['description'];
    dueDate = data['dueDate'];
    startDate = data['startDate'];
    poster = data['poster'];
    posterID = data['posterID'];
    posterPhoto = data['posterPhoto'];
    posterPosition = data['posterPosition'];
  }

  factory Assignment.fromMap(Map<String, dynamic> data) {
    List<Map<String, dynamic>> fData =
        (data['fileData'] ?? []).cast<Map<String, dynamic>>();
    return Assignment(
      id: data['id'],
      title: data['title'],
      description: data['description'],
      dueDate: data['dueDate'],
      startDate: data['startDate'],
      fileData: fData,
      poster: data['poster'],
      posterID: data['posterID'],
      posterPhoto: data['posterPhoto'],
      posterPosition: data['posterPosition'],
    );
  }
}
