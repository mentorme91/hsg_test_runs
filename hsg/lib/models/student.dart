import 'package:cloud_firestore/cloud_firestore.dart';

import 'request.dart';
import 'user.dart';

class Student extends MyUser {
  String status;
  int? year;
  List<String> registeredCourses = [];

  Student({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String schoolId,
    required String department,
    required this.status,
    required this.year,
    required String? photoURL,
    required String? about,
    this.registeredCourses = const [],
    List<String> cancels = const [],
    List<String> rejects = const [],
    Map<String, dynamic> connections = const {},
    Map<String, dynamic> requests = const {},
  }) : super(
          uid: id,
          firstName: firstName,
          email: email,
          lastName: lastName,
          schoolId: schoolId,
          department: department,
          photoURL: photoURL,
          about: about,
          cancels: cancels,
          rejects: rejects,
          connections: connections.cast<String, Timestamp?>(),
          requests: requests.map((key, value) => MapEntry(
                key,
                Request(
                  recieverUID: value['reciever'],
                  senderUID: value['sender'],
                  status: Status.values[value['status']],
                ),
              )),
        );

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'registeredCourses': registeredCourses,
        'status': status,
        'year': year,
      });
  }

  factory Student.fromMap(Map<dynamic, dynamic> studentData) {
    return Student(
      id: studentData['uid'],
      email: studentData['email'],
      firstName: studentData['first_name'],
      lastName: studentData['last_name'],
      schoolId: studentData['school_id'],
      department: studentData['department'],
      status: studentData['status'],
      year: studentData['year'],
      photoURL: studentData['photoURL'],
      about: studentData['about'],
      connections:
          (studentData['connections'] ?? {}).cast<String, Timestamp?>(),
      registeredCourses: List<String>.from(studentData['registeredCourses']),
      cancels: List<String>.from(studentData['cancels']),
      rejects: List<String>.from(studentData['rejects']),
      requests: (studentData['requests'] ?? {}).cast<String, dynamic>(),
    );
  }

  void updateStudentFromStudent(Student student) {
    super.updateUserFromUser(student);
    status = student.status;
    year = student.year;
    registeredCourses = student.registeredCourses;
  }

  @override
  void updateFromMap(Map<dynamic, dynamic> studentData) {
    super.updateFromMap(studentData);
    registeredCourses = List<String>.from(studentData['registeredCourses']);
    status = studentData['status'];
    year = studentData['year'];
  }

  bool isValidStudent() {
    return isValidUser() && status.isNotEmpty && year != null;
  }
}

Student randomStudent() {
  return Student(
    id: '',
    email: '',
    firstName: '',
    lastName: '',
    schoolId: '',
    department: '',
    status: '',
    year: 0,
    photoURL: '',
    about: '',
  );
}
