import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

class QandA {
  String question, topic, course, id, uid;
  Timestamp time = Timestamp.now();
  List<File> files = [];
  List<Map<String, dynamic>> fileData = [];
  List<QandAAnswer> answers;
  int answerCount = 0;
  bool isAnswered = false;

  QandA(
      {required this.question,
      required this.answers,
      required this.topic,
      required this.course,
      required this.id,
      required this.uid,
      required this.answerCount,
      required this.isAnswered});

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'topic': topic,
      'course': course,
      'id': id,
      'answerCount': answerCount,
      'isAnswered': isAnswered,
      'time': time,
      'uid': uid,
      'fileData': fileData,
    };
  }

  factory QandA.fromMap(Map<String, dynamic> data) {
    QandA qa = QandA(
      question: data['question'],
      answers: data['answers'] ?? [],
      topic: data['topic'],
      course: data['course'],
      id: data['id'],
      answerCount: data['answerCount'] ?? 0,
      uid: data['uid'],
      isAnswered: data['isAnswered'] ?? false,
    );
    if (data['time'] != null) {
      qa.time = data['time'];
    }
    if (data['fileData'] != null) {
      qa.fileData = (data['fileData'] ?? []).cast<Map<String, dynamic>>();
    }

    return qa;
  }
}

class QandAAnswer {
  String answer, userId, id;
  Timestamp time = Timestamp.now();
  List<File> files = [];
  List<Map<String, dynamic>> fileData = [];

  QandAAnswer({required this.answer, required this.userId, required this.id});

  Map<String, dynamic> toMap() {
    return {
      'answer': answer,
      'userId': userId,
      'id': id,
      'fileData': fileData,
      'time': time,
    };
  }

  QandAAnswer copyWith({
    String? answer,
    String? userId,
    String? id,
  }) {
    return QandAAnswer(
      answer: answer ?? this.answer,
      userId: userId ?? this.userId,
      id: id ?? this.id,
    );
  }

  factory QandAAnswer.fromMap(Map<String, dynamic> data) {
    QandAAnswer qa = QandAAnswer(
      answer: data['answer'],
      userId: data['userId'],
      id: data['id'],
    );
    if (data['time'] != null) {
      qa.time = data['time'];
    }
    if (data['fileData'] != null) {
      qa.fileData = data['fileData'].cast<Map<String, dynamic>>();
    }
    return qa;
  }
}
