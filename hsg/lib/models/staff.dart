import 'package:cloud_firestore/cloud_firestore.dart';

import 'request.dart';
import 'user.dart';

class Staff extends MyUser {
  String position;
  List<String> courses;

  Staff({
    required String id,
    required String email,
    required String firstName,
    required String lastName,
    required String schoolId,
    required String department,
    required String? photoURL,
    required String? about,
    required this.position,
    this.courses = const [],
    List<String> cancels = const [],
    List<String> rejects = const [],
    Map<String, dynamic> requests = const {},
    Map<String, dynamic> connections = const {},
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
          requests: requests.map(
            (key, value) => MapEntry(
              key,
              Request(
                recieverUID: value['reciever'],
                senderUID: value['sender'],
                status: Status.values[value['status']],
              ),
            ),
          ),
          connections: connections.cast<String, Timestamp?>(),
        );

  @override
  Map<String, dynamic> toMap() {
    return super.toMap()
      ..addAll({
        'position': position,
        'courses': courses,
      });
  }

  void updateStaffFromStaff(Staff staff) {
    super.updateUserFromUser(staff);
    position = staff.position;
    courses = staff.courses;
  }

  @override
  void updateFromMap(Map<dynamic, dynamic> studentData) {
    super.updateFromMap(studentData);
    position = studentData['position'];
    courses = List<String>.from(studentData['courses']);
  }

  factory Staff.fromMap(Map<String, dynamic> data) {
    return Staff(
      id: data['uid'],
      email: data['email'],
      firstName: data['first_name'],
      lastName: data['last_name'],
      schoolId: data['school_id'],
      department: data['department'],
      photoURL: data['photoURL'],
      about: data['about'],
      position: data['position'] ?? 'Instructor',
      connections: (data['connections'] ?? {}).cast<String, Timestamp?>(),
      courses: (data['courses'] ?? []).cast<String>(),
      cancels: (data['cancels'] ?? []).cast<String>(),
      rejects: (data['rejects'] ?? []).cast<String>(),
      requests: (data['requests'] ?? {}).cast<String, dynamic>(),
    );
  }

  bool isValidStaff() {
    return isValidUser() && position.isNotEmpty;
  }
}

Staff randomStaff() {
  return Staff(
    id: '',
    email: '',
    firstName: '',
    lastName: '',
    schoolId: '',
    department: '',
    photoURL: '',
    about: '',
    position: '',
  );
}
