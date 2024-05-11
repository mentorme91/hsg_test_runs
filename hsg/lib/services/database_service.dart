import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/staff.dart';
import '../models/student.dart';
import '../models/user.dart';

// Database service: controls manipulation of the database
class DatabaseService extends ChangeNotifier {
  // string user id
  final String? uid;

  // constructor for database service
  DatabaseService({
    required this.uid,
  });

  // get the collection of all students in the database
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('all_students');

  final CollectionReference schoolsCollection =
      FirebaseFirestore.instance.collection('all_schools');

  final CollectionReference superUserCollection =
      FirebaseFirestore.instance.collection('super_admins');

  final CollectionReference staffCollection =
      FirebaseFirestore.instance.collection('all_staff');


  // update a myuser
  Future updateMyUser(MyUser? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.toMap() ?? {};
    // update all student collections and student collections in respective schools
    try {
      await studentsCollection.doc(user?.uid).update(dic);
    } catch (e) {
      await staffCollection.doc(user?.uid).update(dic);
    }
    notifyListeners();
  }

  // update all student collections and student collections in respective schools
  Future updateStudentCollection(Student? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.toMap() ?? {};
    // update all student collections and student collections in respective schools
    await studentsCollection.doc(user?.uid).set(dic);
    notifyListeners();
  }

  Future uppdateStudentCollection(MyUser? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.toMap() ?? {};
    // update all student collections and student collections in respective schools
    await studentsCollection.doc(user?.uid).update(dic);
    notifyListeners();
  }

  Future updateStaffCollection(Staff? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.toMap() ?? {};
    // update all student collections and student collections in respective schools
    await staffCollection.doc(user?.uid).set(dic);
    notifyListeners();
  }

  Future uppdateStaffCollection(MyUser? user) async {
    // get dictionary representation of user
    Map<String, dynamic> dic = user?.toMap() ?? {};
    // update all student collections and student collections in respective schools
    await staffCollection.doc(user?.uid).update(dic);
    notifyListeners();
  }


  // get user data snapshots
  Stream<DocumentSnapshot> get userData {
    return studentsCollection.doc(uid).snapshots();
  }


  // unregister student
  Future<void> unregisterStudent(String email, String school) async {
    await schoolsCollection
        .doc(school)
        .collection('students')
        .doc(email)
        .delete();
  }

  // unregister staff
  Future<void> unregisterStaff(String email, String school) async {
    await schoolsCollection.doc(school).collection('staff').doc(email).delete();
  }

  // get all registered students
  Future<List<Map<String, dynamic>>> allRegisteredStudents(
      String school) async {
    List<Map<String, dynamic>> allStudents = [];
    QuerySnapshot<Object?> students =
        await schoolsCollection.doc(school).collection('students').get();
    for (var student in students.docs) {
      Map<String, dynamic> studentData = student.data() as Map<String, dynamic>;
      allStudents.add(studentData);
    }
    return allStudents;
  }

  // get all registered staff
  Future<List<Map<String, dynamic>>> allRegisteredStaff(String school) async {
    List<Map<String, dynamic>> allStaff = [];
    QuerySnapshot<Object?> staff =
        await schoolsCollection.doc(school).collection('staff').get();
    for (var staffMember in staff.docs) {
      Map<String, dynamic> staffData =
          staffMember.data() as Map<String, dynamic>;
      allStaff.add(staffData);
    }
    return allStaff;
  }

  // get student registered courses
  Future<List<String>> getRegisteredCourses(String email, String school) async {
    DocumentSnapshot<Object?> student = await schoolsCollection
        .doc(school)
        .collection('students')
        .doc(email)
        .get();
    Map<String, dynamic>? studentData = student.data() as Map<String, dynamic>?;
    return (studentData?['courses'] ?? []).cast<String>();
  }

  // get staff registered courses
  Future<List<String>> getStaffCourses(String email, String school) async {
    DocumentSnapshot<Object?> staff = await schoolsCollection
        .doc(school)
        .collection('staff')
        .doc(email)
        .get();
    Map<String, dynamic>? staffData = staff.data() as Map<String, dynamic>?;
    return (staffData?['courses'] ?? []).cast<String>();
  }

  // check if student is registered
  Future<bool> isRegisteredStudent(String email, String school) async {
    QuerySnapshot querySnapshot = await schoolsCollection
        .doc(school)
        .collection('students')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  // check if staff is registered
  Future<bool> isRegisteredStaff(
      String email, String school, String position) async {
    QuerySnapshot superUserQuerySnapshot =
        await superUserCollection.where('email', isEqualTo: email).get();
    if (position == 'Administrative Staff' &&
        superUserQuerySnapshot.docs.isNotEmpty) {
      return true;
    }

    QuerySnapshot querySnapshot = await schoolsCollection
        .doc(school)
        .collection('staff')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty;
  }

  Future<bool> isSuperUser(String email) async {
    QuerySnapshot querySnapshot =
        await superUserCollection.where('email', isEqualTo: email).get();
    return querySnapshot.docs.isNotEmpty;
  }

  // get user information and converts it into a [MyUser]
  Future<MyUser?> get userInfo async {
    // get the information as a Map
    DocumentSnapshot<Object?> val = await studentsCollection.doc(uid).get();
    if (!val.exists) {
      DocumentSnapshot<Object?> staffVal = await staffCollection.doc(uid).get();
      if (!staffVal.exists) {
        return null;
      }
      Map<String, dynamic> data = staffVal.data() as Map<String, dynamic>;
      MyUser user = MyUser.fromMap(data);
      return user;
    }
    Map data = val.data() as Map<String, dynamic>;

    // convert map to [MyUser]
    MyUser user = MyUser.fromMap(data);
    return user;
  }

  // get user information and converts it into a [MyUser]
  Future<MyUser?> getUserInfo(String uid) async {
    // get the information as a Map
    DocumentSnapshot<Object?> val = await studentsCollection.doc(uid).get();
    if (!val.exists) {
      DocumentSnapshot<Object?> staffVal = await staffCollection.doc(uid).get();
      if (!staffVal.exists) {
        return null;
      }
      Map<String, dynamic> data = staffVal.data() as Map<String, dynamic>;
      MyUser user = MyUser.fromMap(data);
      return user;
    }
    Map data = val.data() as Map<String, dynamic>;

    // convert map to [MyUser]
    MyUser user = MyUser.fromMap(data);
    return user;
  }

  // get user information and converts it into a [MyUser]
  Future<Student?> getStudent(String studentID) async {
    // get the information as a Map
    DocumentSnapshot<Object?> val =
        await studentsCollection.doc(studentID).get();
    Map<String, dynamic>? data = val.data() as Map<String, dynamic>?;

    // convert map to [MyUser]
    if (data == null) {
      return null;
    }
    if (data.isEmpty) {
      return null;
    }
    Student user = Student.fromMap(data);
    return user;
  }

  // get staff
  Future<Staff?> getStaff(String staffID) async {
    // get the information as a Map
    DocumentSnapshot<Object?> val = await staffCollection.doc(staffID).get();
    Map<String, dynamic>? data = val.data() as Map<String, dynamic>?;
    if (data == null) {
      return null;
    }

    // convert map to [MyUser]
    if (data.isEmpty) {
      return null;
    }
    Staff user = Staff.fromMap(data);
    return user;
  }

  // get course staff
  Future<List<Staff>> getCourseStaff(List<String> staffIDs) async {
    List<Staff> staff = [];
    for (var staffID in staffIDs) {
      Staff? thisStaff = await getStaff(staffID);
      if (thisStaff != null) {
        staff.add(thisStaff);
      }
    }
    return staff;
  }

  // get schools
  Future<Map<String, Map<String, dynamic>>> getSchools() async {
    Map<String, Map<String, dynamic>> schools = {};
    var schoolsData = await schoolsCollection.get();
    for (var school in schoolsData.docs) {
      Map<String, dynamic> schoolData = school.data() as Map<String, dynamic>;
      schools[school.id] = schoolData;
    }

    return schools;
  }
}
